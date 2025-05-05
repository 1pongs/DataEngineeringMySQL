# Startup Layoffs (2020 – 2023) 📉

A fully cleaned dataset **and** a set of reproducible SQL queries that explore tech & startup layoffs reported from **Jan 2020 → Mar 2023**.

> *This repo only covers everything I actually completed: data cleaning in Excel, loading into MySQL, and running core analysis queries.*

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Repository Structure](#repository-structure)
3. [Data Source](#data-source)
4. [Setup & Usage](#setup--usage)
5. [Cleaning Workflow](#cleaning-workflow)
6. [Analysis Queries](#analysis-queries)
7. [Key Findings](#key-findings)

---

## Project Overview

* **Scope** Layoff events scraped from **Layoffs.fyi** and enriched with industry, stage, and funds‑raised fields.
* **Goal** Produce a clean, well‑typed table in MySQL to support ad‑hoc analysis.

---

## Repository Structure

```text
.
├── data
│   ├── Layoffs.csv            # Raw export
│   └── LayoffsCleaned.xlsx    # Cleaned & deduped (upload‑ready)
├── sql
│   ├── schema.sql             # CREATE TABLE + LOAD DATA script
│   └── analysis_queries.sql   # KPI queries used in the write‑up
└── docs
    └── Startup_Layoffs_Dataset_Documentation.pdf  # Step‑by‑step methodology
```

---

## Data Source

| Field               | Description                                                                  |
| ------------------- | ---------------------------------------------------------------------------- |
| **Layoffs.fyi**     | Crowd‑sourced tracker of tech/startup layoffs (CSV download)                 |
| **Manual look‑ups** | Used to fill missing `Industry`, `Stage`, and `Funds_Raised_Millions` values |

*Dataset last refreshed **2025‑03‑31***

---

## Setup & Usage

```bash
# Clone the repo
git clone https://github.com/<your‑username>/startup‑layoffs.git
cd startup‑layoffs

# Spin up MySQL (or connect to your own)
# Example: Docker
docker run -d --name mysql8 \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -p 3306:3306 mysql:8.0

# Load schema + data
mysql -u root -p < sql/schema.sql

# Run analysis
mysql -u root -p < sql/analysis_queries.sql
```

> **Note** `secure_file_priv` must allow `LOAD DATA INFILE`. Adjust the path in `schema.sql` if needed.

---

## Cleaning Workflow

1. **Back‑up raw CSV** to `data/Layoffs.csv`.
2. **Excel transformations**

   * Trim/PROPER case text columns.
   * Convert dates to ISO `YYYY‑MM‑DD`.
   * Remove 5 exact duplicates after building a helper `Concat` column.
3. **Missing values**

   * `Industry` & `Stage` ⇒ lookup same company; if unknown ⇒ `Unknown`.
   * Numeric blanks (`Total_Laid_Off`, `Funds_Raised_Millions`, etc.) ⇒ `NULL`.
4. **MySQL import** via `LOAD DATA INFILE` with `STR_TO_DATE` + `NULLIF` for type safety.

Details are in **docs/Startup\_Layoffs\_Dataset\_Documentation.pdf**.

---

## Analysis Queries

All queries live in `sql/analysis_queries.sql`. Highlights:

| Query                   | Purpose                                                |
| ----------------------- | ------------------------------------------------------ |
| `overall_impact.sql`    | Total events, employees laid off, avg. % workforce cut |
| `ytd_running_total.sql` | Running total of layoffs per year (window functions)   |
| `industries_hit.sql`    | Aggregate layoffs by industry                          |
| `countries_rank.sql`    | Aggregate layoffs by country                           |
| `top10_events.sql`      | Largest single layoff events                           |

Run them straight from the MySQL shell or your favourite client.

---

## Key Findings

* **Total events:** 1 620
* **Employees laid off:** 386 079
* **Average % workforce cut:** 22.4 %
* **Peak month:** **Jan 2023** (\~84 k layoffs)
* **Most‑affected industry:** Consumer (46 782 layoffs)
* **Country with most layoffs:** USA (\~256 k, ≈ 66 % of total)

---

*README last updated: 05 May 2025 (KST)*
