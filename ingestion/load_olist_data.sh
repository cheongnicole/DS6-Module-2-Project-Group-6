#!/usr/bin/env bash

set -e

# ==========================================================
# Olist Kaggle -> Meltano -> Google BigQuery Pipeline
# ==========================================================

KAGGLE_DATASET="olistbr/brazilian-ecommerce"
DATA_DIR="data"

echo "======================================"
echo "Olist Data Pipeline"
echo "Kaggle -> Meltano -> BigQuery"
echo "======================================"

# ----------------------------------------------------------
# STEP 1: Check Kaggle CLI
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 1: Checking Kaggle CLI"
echo "======================================"

if ! command -v kaggle >/dev/null 2>&1; then
    echo "ERROR: Kaggle CLI is not installed."
    echo ""
    echo "Install it using:"
    echo "pip install kaggle"
    exit 1
fi

echo "Kaggle CLI found."

# ----------------------------------------------------------
# STEP 2: Create data directory
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 2: Preparing data directory"
echo "======================================"

mkdir -p "$DATA_DIR"

# Remove old CSV files so this is a fresh pipeline run
rm -f "$DATA_DIR"/*.csv

echo "Data directory ready."

# ----------------------------------------------------------
# STEP 3: Download Olist dataset from Kaggle
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 3: Downloading Olist from Kaggle"
echo "======================================"

kaggle datasets download \
    "$KAGGLE_DATASET" \
    -p "$DATA_DIR" \
    --unzip \
    --force

echo ""
echo "Kaggle download completed."

# ----------------------------------------------------------
# STEP 4: Show downloaded CSV files
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 4: Downloaded files"
echo "======================================"

ls -lh "$DATA_DIR"/*.csv

# ----------------------------------------------------------
# STEP 5: Clean CSV files
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 5: Cleaning CSV files"
echo "======================================"

python - <<'PY'

from pathlib import Path
import pandas as pd

data_dir = Path("data")

# ------------------------------------------------------
# Remove UTF-8 BOM and standardise line endings
# ------------------------------------------------------

for path in data_dir.glob("*.csv"):

    text = path.read_text(
        encoding="utf-8-sig"
    )

    path.write_text(
        text,
        encoding="utf-8",
        newline="\n"
    )

    print(f"Cleaned: {path.name}")


# ------------------------------------------------------
# Rename problematic translation-table column
# ------------------------------------------------------

translation_file = (
    data_dir /
    "product_category_name_translation.csv"
)

if translation_file.exists():

    df = pd.read_csv(translation_file)

    if "product_category_name" in df.columns:

        df = df.rename(
            columns={
                "product_category_name":
                "category_name"
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

    else:
        print(
            "category_name already renamed "
            "or source column not found."
        )

else:

    print(
        "ERROR: "
        "product_category_name_translation.csv "
        "was not downloaded."
    )

    raise SystemExit(1)


print("")
print("Translation table columns:")
print(df.columns.tolist())

PY

# ----------------------------------------------------------
# STEP 6: Count source rows
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 6: Source CSV row counts"
echo "======================================"

python - <<'PY'

import csv
from pathlib import Path

for file in sorted(Path("data").glob("*.csv")):

    with open(
        file,
        "r",
        encoding="utf-8",
        newline=""
    ) as f:

        reader = csv.reader(f)

        next(reader, None)   # Skip header

        rows = sum(1 for _ in reader)

    print(
        f"{file.name}: "
        f"{rows:,} rows"
    )

PY

# ----------------------------------------------------------
# STEP 7: Run Meltano pipeline
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Step 7: Running Meltano pipeline"
echo "======================================"

meltano run tap-csv target-bigquery

# ----------------------------------------------------------
# STEP 8: Pipeline completed
# ----------------------------------------------------------

echo ""
echo "======================================"
echo "Pipeline completed successfully!"
echo "======================================"
echo ""
echo "Source : Kaggle"
echo "Dataset: $KAGGLE_DATASET"
echo "Target : Google BigQuery"
echo ""
