# Olist Brazilian E‑commerce Analysis

This project uses **dbt** with **BigQuery** to transform and analyze the Olist Brazilian E‑commerce dataset.  
It is organized into staging models (cleaning raw data) and marts (business‑ready star schema).

---

## Connection

```bash
pip install dbt-bigquery
```

## Authenticate with Google Cloud
```bash
gcloud auth application-default login
```


## How to Run dbt
Run all commands from the project root (`DS6-Module-2-Project-Group-6`) and point dbt to `olist_staging`:

### Debug connection
```bash
dbt debug --project-dir olist_staging --profiles-dir olist_staging
```

### Run staging models
```bash
dbt run --project-dir olist_staging --profiles-dir olist_staging
```

### Run tests
```bash
dbt test --project-dir olist_staging --profiles-dir olist_staging
```

