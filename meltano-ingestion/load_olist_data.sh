#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Configuration
# ==========================================================

KAGGLE_DATASET="olistbr/brazilian-ecommerce"
DATA_DIR="data"

ELT_ENV="elt"
GX_ENV="gx-env"

GCP_PROJECT="rock-partition-505312-a6"
BQ_DATASET="ingestion"
BQ_LOCATION="US"

GX_RUNNER="gx_tests/run_all_validations.py"


# ==========================================================
# Helper function
# ==========================================================

step() {
    echo ""
    echo "=========================================================="
    echo "$1"
    echo "=========================================================="
}


# ==========================================================
# Step 1: Check required tools
# ==========================================================

step "Step 1: Checking required tools"

if ! command -v conda >/dev/null 2>&1; then
    echo "ERROR: Conda is not installed or not in PATH."
    exit 1
fi

if ! command -v bq >/dev/null 2>&1; then
    echo "ERROR: Google BigQuery CLI (bq) is not available."
    exit 1
fi

echo "Required command-line tools found."


# ==========================================================
# Step 2: Check Conda environments
# ==========================================================

step "Step 2: Checking Conda environments"
conda env list | awk '{print $1}'
if ! conda env list | awk '{print $1}' | grep -qx "$ELT_ENV"; then
    echo "ERROR: Conda environment '$ELT_ENV' was not found."
    exit 1
fi

echo "ELT environment found: $ELT_ENV"

if ! conda env list | awk '{print $1}' | grep -qx "$GX_ENV"; then
    echo "ERROR: Conda environment '$GX_ENV' was not found."
    exit 1
fi

echo "Great Expectations environment found: $GX_ENV"


# ==========================================================
# Step 3: Check Kaggle CLI
# ==========================================================

step "Step 3: Checking Kaggle CLI"

if ! conda run -n "$ELT_ENV" kaggle --version >/dev/null 2>&1; then
    echo "ERROR: Kaggle CLI is not available in '$ELT_ENV'."
    exit 1
fi

echo "Kaggle CLI found."


# ==========================================================
# Step 4: Prepare data directory
# ==========================================================

step "Step 4: Preparing data directory"

mkdir -p "$DATA_DIR"

rm -f "$DATA_DIR"/*.csv
rm -f "$DATA_DIR"/*.zip

echo "Data directory ready."


# ==========================================================
# Step 5: Download Olist dataset
# ==========================================================

step "Step 5: Downloading Olist dataset from Kaggle"

conda run -n "$ELT_ENV" kaggle datasets download \
    "$KAGGLE_DATASET" \
    -p "$DATA_DIR" \
    --unzip \
    --force

echo ""
echo "Downloaded CSV files:"
ls -lh "$DATA_DIR"/*.csv


# ==========================================================
# Step 6: Clean CSV files
# ==========================================================

step "Step 6: Cleaning CSV files"

conda run --no-capture-output -n "$ELT_ENV" python - <<'PY'

from pathlib import Path
import pandas as pd

data_dir = Path("data")

csv_files = list(data_dir.glob("*.csv"))

if not csv_files:
    raise SystemExit("ERROR: No CSV files found in data directory.")


# ----------------------------------------------------------
# Remove BOM and standardise line endings
# ----------------------------------------------------------

for path in csv_files:

    text = path.read_text(
        encoding="utf-8-sig"
    )

    path.write_text(
        text,
        encoding="utf-8",
        newline="\n"
    )

    print(f"Cleaned: {path.name}")


# ----------------------------------------------------------
# Rename translation-table column
# ----------------------------------------------------------

translation_file = (
    data_dir /
    "product_category_name_translation.csv"
)

if not translation_file.exists():

    raise SystemExit(
        "ERROR: product_category_name_translation.csv "
        "was not downloaded."
    )


df = pd.read_csv(translation_file)


if "product_category_name" in df.columns:

    df = df.rename(
        columns={
            "product_category_name": "category_name"
        }
    )

    df.to_csv(
        translation_file,
        index=False
    )

    print(
        "Renamed product_category_name "
        "-> category_name"
    )


elif "category_name" in df.columns:

    print("category_name already exists.")


else:

    raise SystemExit(
        "ERROR: Expected category column "
        "was not found."
    )


# ----------------------------------------------------------
# Final verification
# ----------------------------------------------------------

verify_df = pd.read_csv(
    translation_file,
    nrows=1
)

required_columns = {
    "category_name",
    "product_category_name_english",
}

missing = (
    required_columns -
    set(verify_df.columns)
)

if missing:

    raise SystemExit(
        f"ERROR: Missing translation columns: {missing}"
    )


print("")
print("Translation table columns:")
print(verify_df.columns.tolist())

print("")
print("CSV cleaning completed successfully.")

PY


# ==========================================================
# Step 7: Check source row counts
# ==========================================================

step "Step 7: Checking CSV row counts"

conda run --no-capture-output -n "$ELT_ENV" python - <<'PY'

import csv
from pathlib import Path

data_dir = Path("data")

for file in sorted(data_dir.glob("*.csv")):

    with open(
        file,
        "r",
        encoding="utf-8",
        newline=""
    ) as f:

        reader = csv.reader(f)

        next(reader, None)

        rows = sum(
            1 for _ in reader
        )

    print(
        f"{file.name}: "
        f"{rows:,} rows"
    )

PY


# ==========================================================
# Step 8: Reset BigQuery ingestion dataset
# ==========================================================

step "Step 8: Resetting BigQuery ingestion dataset"

echo "Removing old ingestion dataset..."

bq rm \
    -r \
    -f \
    -d \
    "${GCP_PROJECT}:${BQ_DATASET}" \
    2>/dev/null || true


echo "Creating fresh ingestion dataset..."

bq mk \
    --dataset \
    --location="$BQ_LOCATION" \
    "${GCP_PROJECT}:${BQ_DATASET}"

echo "BigQuery ingestion dataset recreated."


# ==========================================================
# Step 9: Meltano ingestion
# ==========================================================

step "Step 9: Loading CSV data into BigQuery"

conda run \
    --no-capture-output \
    -n "$ELT_ENV" \
    meltano run tap-csv target-bigquery

echo "Meltano ingestion completed successfully."


# ==========================================================
# Step 10: Great Expectations
# ==========================================================

step "Step 10: Running Great Expectations"

conda run \
    --no-capture-output \
    -n "$GX_ENV" \
    python "$GX_RUNNER"

echo "Critical raw-data quality checks passed."


# ==========================================================
# Step 11: Run dbt transformations
# ==========================================================

step "Step 11: Running dbt transformations"

conda run \
    --no-capture-output \
    -n "$ELT_ENV" \
    meltano invoke dbt-bigquery run

echo "dbt models created successfully."


# ==========================================================
# Step 12: Run dbt tests
# ==========================================================

step "Step 12: Running dbt tests"

conda run \
    --no-capture-output \
    -n "$ELT_ENV" \
    meltano invoke dbt-bigquery test

echo "dbt tests passed."


# ==========================================================
# Pipeline complete
# ==========================================================

step "PIPELINE COMPLETED SUCCESSFULLY"

echo "Kaggle download             : SUCCESS"
echo "CSV cleaning                : SUCCESS"
echo "BigQuery ingestion          : SUCCESS"
echo "Great Expectations          : SUCCESS"
echo "dbt transformations         : SUCCESS"
echo "dbt tests                   : SUCCESS"

echo ""
echo "Raw dataset:"
echo "  ${GCP_PROJECT}.${BQ_DATASET}"

echo ""
echo "Analytics dataset:"
echo "  ${GCP_PROJECT}.analytics"

echo ""
echo "Run Streamlit separately with:"
echo "  conda activate ${ELT_ENV}"
echo "  streamlit run app.py"

echo ""