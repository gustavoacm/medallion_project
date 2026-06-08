# 🏅 Medallion Architecture Project
### Data Engineering Portfolio | Snowflake + dbt

> A hands-on project implementing a full Medallion Architecture (Bronze → Silver → Gold) using Snowflake as the cloud data warehouse and dbt for data transformation — with a strong emphasis on **data quality from the very first layer**.

---

## 📌 Background

This project was built as part of my transition from **QA Professional to Data Engineer**. My background in software quality shaped how I approached the entire pipeline: I never assumed the data was correct.

The dataset simulates sales records with intentional errors (duplicates, nulls, inconsistent formats) to demonstrate how a Medallion Architecture progressively detects, cleans, and consolidates data in a traceable and auditable way.

---

## 🏗️ Architecture

```
                ┌─────────────────────────────────────────┐
                │           Snowflake Cloud DW            │
                │         (medallion_practice DB)          │
                └─────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   ┌────▼────┐          ┌─────▼─────┐         ┌────▼────┐
   │ BRONZE  │  ──dbt──▶│  SILVER   │ ──dbt──▶│  GOLD   │
   │  Layer  │          │   Layer   │         │  Layer  │
   │         │          │           │         │         │
   │ Raw data│          │ Cleaned + │         │Business │
   │  as-is  │          │ validated │         │ metrics │
   └─────────┘          └───────────┘         └─────────┘
   sales_bronze         sales_silver          (coming soon)
   (10 records          (incremental +
   with intentional      upsert on
   errors)               sale_id)
```

---

## 🛠️ Tech Stack

| Tool | Role | Why |
|---|---|---|
| **Snowflake** | Cloud Data Warehouse | Scalable, compute/storage separation, columnar analytics |
| **dbt Core** | Transformation & modeling | Modular SQL, native testing, data lineage, Git-versioned |
| **Soda** | Automated QA *(coming soon)* | Declarative YAML checks, native Snowflake integration |
| **Git + GitHub** | Version control | Change traceability, CI/CD ready |

---

## 📁 Project Structure

```
medallion_project/
├── models/
│   ├── bronze/
│   │   └── sources.yml          # Source declarations
│   ├── silver/
│   │   ├── sales_silver.sql     # Incremental model with upsert
│   │   └── schema.yml           # Quality tests
│   └── gold/                    # 🚧 In progress
├── macros/                      # Reusable macros
├── tests/                       # Singular tests
├── seeds/                       # Reference data
├── analyses/                    # Exploratory queries
├── dbt_project.yml              # Main configuration
└── .gitignore                   # Credentials excluded ✅
```

---

## 🔑 Key Design Decisions

### 1. Incremental Materialization in Silver
```sql
-- sales_silver.sql (excerpt)
{{ config(
    materialized='incremental',
    unique_key='sale_id'
) }}
```
**Why:** In production, sales tables grow by millions of rows daily. Reprocessing everything would be costly. Incremental mode only processes new or changed records, and `unique_key` guarantees idempotency — running the model twice yields the same result.

### 2. Intentional Errors in Bronze
The Bronze layer stores data **exactly as it arrives**: with duplicates, nulls, and inconsistent formats. This is intentional — Bronze is the historical source of truth. Cleaning happens in Silver, preserving a full audit trail.

### 3. Credentials via Environment Variables
Snowflake credentials are **never hardcoded**. They are managed through environment variables (`SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, etc.) — a fundamental security practice in any production environment.

---

## ✅ Data Quality Tests (dbt)

Tests declared in `schema.yml` run automatically with `dbt test`:

| Test | Column | What it validates |
|---|---|---|
| `not_null` | `sale_id` | Every record has an ID |
| `unique` | `sale_id` | No duplicates in Silver |
| `not_null` | `amount` | Amount is always present |
| `accepted_values` | `status` | Only valid status values |

---

## 🚀 How to Run

### Prerequisites
- Python 3.8+
- Snowflake account (free trial available)
- dbt Core installed

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/gustavoacm/medallion_project.git
cd medallion_project

# 2. Install dbt with Snowflake adapter
pip install dbt-snowflake

# 3. Configure credentials (create ~/.dbt/profiles.yml)
# See profiles.yml.example for the required structure

# 4. Verify connection
dbt debug

# 5. Run models
dbt run

# 6. Run quality tests
dbt test

# 7. Generate and serve documentation
dbt docs generate && dbt docs serve
```

### Required Environment Variables

```bash
export SNOWFLAKE_ACCOUNT="your_account"
export SNOWFLAKE_USER="your_user"
export SNOWFLAKE_PASSWORD="your_password"
export SNOWFLAKE_DATABASE="medallion_practice"
export SNOWFLAKE_WAREHOUSE="your_warehouse"
export SNOWFLAKE_ROLE="your_role"
```

---

## 🗺️ Roadmap

- [x] Snowflake database with bronze/silver/gold schemas
- [x] `sales_bronze` table with intentional data quality issues
- [x] `sales_silver` model — incremental + upsert
- [x] Sources declared in `sources.yml`
- [x] Quality tests in `schema.yml`
- [x] Secure credentials via environment variables
- [x] Published on GitHub
- [ ] Gold layer models (aggregated business metrics)
- [ ] Soda integration for automated QA
- [ ] GitHub Actions for CI/CD (automated `dbt run` + `dbt test`)
- [ ] Data lineage visualization with dbt docs

---

## 💡 Key Takeaways

Coming from QA, my approach to this project was shaped by one principle: **never trust the data**. That led to:

- Designing Bronze to preserve raw data without transformation (audit-ready source of truth)
- Prioritizing idempotency in Silver (transformations must be safely repeatable)
- Treating intentional errors as explicit test cases, not just noise to discard

Applying a quality mindset to data engineering is what separates a robust Medallion architecture from a fragile one.

---

## 👤 Author

**Gustavo Alexander Cabrera** — QA Professional transitioning to Data Engineering

[![GitHub](https://img.shields.io/badge/GitHub-gustavoacm-181717?logo=github)](https://github.com/gustavoacm)

---

*Stack: Snowflake · dbt Core · Python · SQL · Git*
