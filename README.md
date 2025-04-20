# DataEngineeringMySQL

A curated toolkit of MySQL assets for data engineers: reusable **ETL** templates, staging‑to‑core transformations, schema‑evolution scripts, and analytics‑ready views—battle‑tested on **MySQL 8.0**.

---

## 📂 Repository layout

| Path / file | Purpose |
|-------------|---------|
| **`Sales.csv`** | Raw sales extract (CSV). Used as the “source‑of‑truth” for the demo pipeline. |
| **`Data Cleaning Sample Data.xlsx`** | Spreadsheet version of the same dataset—handy for ad‑hoc tweaks or quick profile checks. |
| **`Data Cleaning.sql`** | End‑to‑end SQL script that:<br>1️⃣ creates a working copy of the dataset<br>2️⃣ performs cleansing & type‑casting<br>3️⃣ detects / removes duplicates<br>4️⃣ generates roll‑ups for reporting (total revenue by department, state, etc.). |

---

## ⚙️ Requirements

* **MySQL 8.0** (or MariaDB 10.5+)  
* MySQL Workbench / CLI client  
* Disk space for local imports (dataset is tiny ≈ 20 KB)

---

## 🚀 Quick start

```bash
# 1. Clone the repo
git clone https://github.com/1pongs/DataEngineeringMySQL.git
cd DataEngineeringMySQL

# 2. Load the raw CSV into a table called `sales`
mysql -u root -p -e "
  CREATE DATABASE IF NOT EXISTS projects;
  USE projects;
  CREATE TABLE sales LIKE csv_table_template;   -- or define columns manually
  LOAD DATA LOCAL INFILE 'Sales.csv'
    INTO TABLE sales
    FIELDS TERMINATED BY ',' 
    OPTIONALLY ENCLOSED BY '\"'
    IGNORE 1 ROWS;
"

# 3. Run the cleaning / aggregation script
mysql -u root -p projects < "Data Cleaning.sql"
