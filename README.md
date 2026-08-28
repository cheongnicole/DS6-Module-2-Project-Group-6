# NTU SCTP Data Science & AI (Cohort 6) — Module 2 Assignment Project (Group 6)

## 📌 Overview

In this project, you will join a data engineering team to build a complete system for moving and analyzing data. You will start with raw data files, put them into a digital warehouse, clean them up, and then use Python to find helpful information.

At the end, you will present your work and what you discovered to both business leaders (like the CEO) and technical leaders (like the CTO). Your goal is to explain your technical steps in a way that everyone can understand and use to make better business decisions.

---
## 📊 Olist Data Pipeline Project Dataset

[Brazilian E-Commerce Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Orders:** ~99k records  
- **Customers:** ~96k unique IDs  
- **Products:** ~71 categories  
- **Sellers:** ~3k sellers  
- **Payments:** Multiple methods (credit card, boleto, etc.)  
- **Reviews:** ~100k customer reviews with ratings  
- **Geolocation:** 27 Brazilian states, thousands of zip codes 

This project builds an **end-to-end automated cloud data pipeline** using Python, Google Cloud Storage, BigQuery, dbt, Great Expectations, and Airflow.  
The pipeline transforms raw Olist CSV datasets into **trusted business KPIs** for executives and analysts.

**Flow:** Raw Data → Ingestion → Warehouse → Transformation → Quality →  Analytics → KPIs → Business Decisions

---

## ⚙️ Tools & Technologies
- **Python** → ETL scripts for ingestion  
- **Google Cloud Storage (GCS)** → Raw data landing zone  
- **BigQuery** → Cloud data warehouse (star schema)  
- **dbt** → Transformations, lineage, modular SQL  
- **Great Expectations + dbt tests** → Data quality validation  
- **Airflow / Cloud Composer** → Orchestration, scheduling, monitoring  
- **Pandas, SQLAlchemy, Streamlit** → Analytics & visualization  

---

## 👥 Project Team
- **Data Ingestion Lead** → Python ETL scripts, schema mapping  
- **Warehouse Architect** → BigQuery star schema design  
- **Transformation Engineer** → dbt models, modular SQL  
- **Data Quality Analyst** → Great Expectations + dbt tests  
- **Data Analyst** → Pandas, KPIs, dashboards  
- **Documentation & Presentation Lead** → Reports, diagrams, executive deck  

---

## 🚀 Pipeline Steps
1. **Exploratory Data Analysis (EDA)**  
   - Validate dataset quality (missing values, duplicates, outliers).  
   - Identify early insights (sales distribution, customer segments, delivery delays).  

2. **Ingestion & Storage**  
   - Python scripts extract CSVs, encode UTF‑8, and upload to GCS.  
   - Automated jobs with logging and error handling.  

3. **Warehouse Design**  
   - BigQuery star schema:  
     - **Fact Table:** `fact_orders` → central table with order + item details  
     - **Dimension Tables:**  
       - `dim_customers` → customer attributes (city, state, unique ID)  
       - `dim_products` → product attributes + category translation  
       - `dim_sellers` → seller attributes (location, ID)  
       - `dim_geolocation` → zip prefix, latitude/longitude, city/state  
       - `dim_date` → derived from order timestamps (day, month, year, weekday) 
   - Centralized, scalable single source of truth.  

4. **Transformation (dbt)**  
   - Modular SQL models for staging, fact, and dimension tables.  
   - Lineage documentation auto‑generated.  

5. **Data Quality**  
   - Great Expectations + dbt tests for schema checks, nulls, duplicates.  
   - Ensures trusted KPIs.  
 
6. **Analytics & Visualization**  
   - Pandas + Streamlit dashboards for insights.  
   - KPIs delivered to executives and analysts.  

---
## 📂 Project Structure

| Pipeline Step              | Folder            | Purpose                                                                 |
|-----------------------------|------------------|-------------------------------------------------------------------------|
| Exploratory Data Analysis   | analytics/       | Pandas notebooks for profiling, early insights, and validation          |
| Ingestion & Storage         | ingestion/       | Python ETL scripts to load CSVs into Google Cloud Storage               |
| Warehouse Design            | warehouse/       | BigQuery schema definitions (fact/dim tables for star schema)           |
| Transformation (dbt)        | transformations/ | dbt models for staging, fact, and dimension layers with lineage docs    |
| Data Quality                | tests/           | Great Expectations + dbt tests for schema, nulls, duplicates, anomalies |
| Analytics & Visualization   | analytics/       | Streamlit dashboards and KPI reporting                                  |
| Documentation & Presentation| docs/            | Diagrams, architecture visuals, and project documentation              |
| Project Overview            | README.md        | High‑level description, setup guide, and business context               |

---

## ❓ Business Questions & 📈 KPIs
**Key Business Questions:**
- Are **sales growing** month over month?  
- Which **categories drive revenue**?  
- Who are our **most valuable customers**?  
- Where are **delivery delays** concentrated?  
- How do **delivery times affect satisfaction**?  
- What is the **customer lifetime value (CLV)**?  

**Corresponding KPIs:**
- **Sales Growth %** → Tracks revenue trends over time  
- **Revenue by Category** → Identifies top‑performing product groups  
- **Customer Lifetime Value (CLV)** → Measures long‑term customer profitability  
- **Delivery SLA Compliance** → Monitors operational efficiency  
- **Net Promoter Score (NPS)** → Captures customer satisfaction and loyalty  

**Key takeaway:** Business questions are directly answered by measurable KPIs, ensuring technical outputs drive executive decisions.


---

## 🔑 Key Takeaways
- **Automation:** End‑to‑end pipeline reduces manual effort.  
- **Governance:** Data quality gates ensure trusted insights.  
- **Scalability:** Cloud‑native design grows with demand.  
- **Business Impact:** Direct link from raw data to executive KPIs.  

---

## 📈 Next Steps
- Expand pipeline to multi‑region datasets.  
- Integrate ML models for predictive analytics.  
- Enable real‑time dashboards for operations.  
- Add Orchestration → Use Airflow/Cloud Composer to automate ingestion, transformation, and testing with scheduling, retries, and monitoring.  


