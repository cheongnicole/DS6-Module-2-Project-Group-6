# NTU SCTP Data Science & AI (Cohort 6) — Module 2 Assignment Project (Group 6)

## 📌 Overview

In this project, you will join a data engineering team to build a complete system for moving and analyzing data. You will start with raw data files, put them into a digital warehouse, clean them up, and then use Python to find helpful information.

At the end, you will present your work and what you discovered to both business leaders (like the CEO) and technical leaders (like the CTO). Your goal is to explain your technical steps in a way that everyone can understand and use to make better business decisions.

---
## 📊 Olist Data Pipeline Project Dataset

[Brazilian E-Commerce Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Orders:** 99,441 records  
- **Customers:** 96,096 unique IDs  
- **Products:** 71 categories  
- **Sellers:** ~3k sellers  
- **Payments:** Multiple methods (credit card, boleto, etc.)  
- **Reviews:** ~100k customer reviews with ratings  
- **Geolocation:** 27 Brazilian states, thousands of zip codes
- **Period:** September 2016 to September 2018

The project consolidates 9 Olist e-commerce datasets into a governed analytical platform. It builds an **end-to-end automated cloud data pipeline** using ingestion, transformation, testing, modelling, and reporting while establishing **trusted business KPIs** for executives and analysts.
**Flow:** Raw Data → Ingestion → Warehouse → Transformation → Quality →  Analytics → KPIs → Business Decisions

---
## ❓ Business Problem & KPIs
The source data was distributed across multiple CSV files, creating:

- Slow, manual analysis
- Inconsistent KPI definitions
- Data-quality and reconciliation risks
- Limited visibility into sales, customers, products, and delivery performance

**Key Business Questions:**
- Are **sales growing** month over month?  
- Which **categories drive revenue**?  
- Who are our **most valuable customers**?  
- Where are **delivery delays** concentrated?  
- How do **delivery times affect satisfaction**?
---
## ⚙️Technology Stack

| Layer | Technology | Purpose |
|---------|------------|---------|
| Source | Olist CSV files | Marketplace source data |
| Validation | Python | File and schema verification |
| Ingestion | Meltano | Repeatable extraction and loading |
| Storage | Google Cloud Storage | Raw-file landing zone |
| Warehouse | Google BigQuery | Scalable analytical storage |
| Transformation | dbt | Cleaning, modelling, documentation, and lineage |
| Quality | dbt tests | Automated integrity checks |
| Analysis | SQL and Pandas | Exploration and business analysis |
| Visualization | Matplotlib and dashboards | Executive reporting |

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
   - dbt tests for schema checks, nulls, duplicates, row count > 0.  
   - Ensures trusted KPIs.  
 
6. **Analytics & Visualization**  
   - Pandas + dashboards for insights.  
   - KPIs delivered to executives and analysts.  

---
## 📂 Project Structure

The project is organised into modular components that support data ingestion, transformation, testing, analytics, and governance throughout the analytics lifecycle.

| Component | Directory | Description |
|------------|------------|-------------|
| Documentation | `docs/` | Project documentation, architecture diagrams, reports, and supporting materials. |
| Ingestion & ELT | `meltano-ingestion/` | Meltano project containing extraction, loading, configuration files, plugins, and execution artefacts for data ingestion. |
| Exploratory Data Analysis | `notebooks/` | Jupyter notebooks used for data profiling, validation, exploratory analysis, and visualisation. |
| Data Warehouse | `olist_dbt/` | Central dbt project responsible for data transformation, modelling, testing, and documentation. |
| Staging Models | `olist_dbt/models/staging/` | Initial transformation layer used to clean, standardise, and prepare raw source data. |
| Core Models | `olist_dbt/models/core/` | Business-ready intermediate models containing transformed and integrated datasets. |
| Data Mart Layer | `olist_dbt/models/datamart/` | Analytical models providing reporting-ready fact and dimension tables. |
| Data Quality & Testing | `olist_dbt/tests/` | Automated tests validating data quality, schema integrity, completeness, and business rules. |
| Reusable Logic | `olist_dbt/macros/` | Shared SQL and Jinja functions used across dbt models. |
| Reference Data | `olist_dbt/seeds/` | Static reference datasets loaded directly into the warehouse. |
| Snapshots | `olist_dbt/snapshots/` | Historical tracking of source data changes over time. |
| Configuration | `dbt_project.yml`, `packages.yml`, `profiles.yml` | Project configuration, package dependencies, and warehouse connection settings. |
| Project Overview | `README.md` | Repository overview, architecture summary, and business context. |

---

## 📈 Key Business Findings & KPIs
**Key Business Questions:**

**1. Sales Growth**
- Sales and order volumes grew strongly during 2017 and remained elevated in 2018.
- Peak monthly sales: R$1.01 million
- Peak period: November 2017
- Q4 performance shows a strong Black Friday seasonal effect

**2. Customer Experience**
- Delivery speed is strongly associated with review scores.
- Average delivery time for one-star reviews: 20.9 days
- Average delivery time for five-star reviews: 10.2 days
- Difference: 10.7 days
- Reducing fulfilment delays can improve ratings, loyalty, and repeat purchasing.

**3. Revenue Concentration**
- Revenue is concentrated in a relatively small number of categories.
- Top 18 categories generate 81.3% of revenue
- Leading categories include:
   - Health and Beauty
   - Watches and Gifts
   - Bed, Bath and Table

**4. Geographic Concentration**
- Customers and revenue are concentrated in:
   - São Paulo
   - Rio de Janeiro
   - Minas Gerais
- São Paulo represents the largest customer base and revenue contribution.


---

## 🔑 Key Takeaways
- **Automation:** End‑to‑end pipeline reduces manual effort.  
- **Governance:** Data quality gates ensure trusted insights.  
- **Scalability:** Cloud‑native design grows with demand.  
- **Business Impact:** Direct link from raw data to executive KPIs.  

---

## 💼 Business Value

- Reproducible and automated data ingestion processes.
- Consistent KPI definitions across reports and dashboards.
- Traceable data transformations with full lineage visibility.
- Early detection and resolution of data quality issues.
- Faster analytical queries and improved reporting performance.
- Reliable and trusted executive reporting.
- Better visibility into revenue growth, order fulfilment, customer behaviour, and product portfolio performance.
---

## 💡 Next Steps

To further enhance the scalability, governance, and operational maturity of the analytics platform, several strategic initiatives have been identified.

The platform will standardise development and production workloads on Google BigQuery while strengthening governance through service accounts, budget controls, and enhanced dbt documentation. CI/CD capabilities will be implemented using GitHub Actions, and workflow orchestration will be introduced through Apache Airflow or Google Cloud Composer to automate ingestion, transformation, testing, and monitoring processes.

Operational resilience will be improved through centralised logging, health monitoring, and alerting. Future enhancements also include support for multi-region datasets, the integration of machine learning for predictive analytics, and the development of near real-time dashboards to provide more timely business insights and support faster decision-making.


## 🎯 Conclusion

This project establishes a trusted and scalable analytics foundation that converts raw marketplace data into reliable executive insight. Automated controls, consistent performance measures, and transparent data lineage strengthen confidence in reporting and support more informed decision-making.

The platform provides improved visibility into growth, customer experience, operational performance, and the product portfolio, while reducing manual effort and reporting risk. It also creates a strong foundation for future expansion, advanced analytics, and sustained business value.
