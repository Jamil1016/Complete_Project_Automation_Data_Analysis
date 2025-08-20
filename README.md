# 📘 Project Automation Data Analysis

This repository documents my **study plan, practice, and automation projects** based on my preparation for the **Data Analyst role at Nanoninth**.  
The content is derived from guided chats where I planned, tested, and documented step-by-step learning.  

---

## 📂 Documentation

### 1. **Setup & Environment**
- Installed PostgreSQL and connected with Supabase.  
- Created `.env` file for connection variables (host, port, db, user, password, schema, sslmode).  
- Debugged Supabase host migration issues (old → new pooled host).  
- Verified database connection with Python scripts (`check_connection.py`).  

---

### 2. **PostgreSQL & Supabase Training**
- Learned how to **list all tables** in PostgreSQL.  
- Practiced **basic SQL queries** (SELECT, WHERE, ORDER BY).  
- Moved towards **joins, group by, and aggregation** for real analysis.  
- Planned to create **mock datasets** (using Mockaroo) for practice.  

---

### 3. **ETL & Automation**
- Started building **ETL pipeline** with Python → Supabase → Power BI.  
- Goal: Automate refresh of Power BI dashboards using **Python + OneDrive**.  
- Learned how to store credentials securely in `.env`.  
- Began modular ETL script structure inside `etl/` folder.  

---

### 4. **Power BI & DAX**
- Practiced DAX measures:
  - Percentage of subgroup values.  
  - Keeping all filters except one column (using `REMOVEFILTERS`).  
- Created **mock datasets** for Power BI practice.  
- Plan to integrate **Supabase live data** with Power BI dashboards.  

---

### 5. **Excel & Macros**
- Built macros for file automation:
  - Copy all files from source → destination folder (if not already present).  
  - Check missing files between folders.  
- Planned to extend automation for reporting tasks.  

---

### 6. **Power Automate & SharePoint**
- Created a flow to send **weekly email reports**.  
- Planned a flow to **extract Excel attachments from specific emails** and save to SharePoint.  
- Documented automation process in markdown.  

---

## 🎯 Study Plan Goals

- ✅ Strengthen **SQL & PostgreSQL** with Supabase.  
- ✅ Build ETL pipeline with Python → Power BI.  
- ⬜ Automate dataset refresh with OneDrive & Power BI Service.  
- ⬜ Deploy **Power BI dashboards** for live reporting.  
- ⬜ Enhance automation using Macros & Power Automate.  

---

## **Setup & Environment**
1) Create repo layout.

*Reference*
```bash
/Complete_Project_Automation_Data_Analysis
  /etl
    supabase_extract.py
    transform_clean.py
    load_sharepoint.py
    config.json
    requirements.txt
  /tests
    test_validation.py
  /bi
    model.pbit
    measures.md
  /docs
    process-map.md
    sop-pipeline.md
    training-guide.md
    runbook.md
  /ops
    scheduler_task.xml
    logging.conf
```

*Initial Structure*
```bash
/Complete_Project_Automation_Data_Analysis
  etl/
    check_connection.py
    sql/
      01_schema.sql
      02_seed_data.sql
  tests/
    test_validation.py
  bi/
    measures.md
  docs/
    process-map.md
    training-guide.md
    runbook.md
  ops/
    logging.conf
```

2.) Create a Python virtual environment and install dependencies:
```powershell
# Windows (PowerShell)
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

3.) Create .env file, this will contains credentials.
* Supabase Connect to your project
  * Type = Python
  * Transaction pooler

```bash
SUPABASE_HOST=your-project.supabase.co
SUPABASE_PORT=6543
SUPABASE_DB=postgres
SUPABASE_USER=postgres      # or a dedicated read-only user
SUPABASE_PASSWORD=*********
SUPABASE_SCHEMA=public
SUPABASE_SSLMODE=require
```

4.)  (Optional) Create a least-privileged DB user in Supabase (run in SQL editor):
```sql
-- Replace STRONG_PASSWORD with your own.
create role etl_user login password 'STRONG_PASSWORD';
grant usage on schema public to etl_user;
grant select on all tables in schema public to etl_user;
alter default privileges in schema public grant select on tables to etl_user;
```

5.) Run the connectivity check:
```bash
python etl/check_connection.py --list-tables
```

6.) (Optional) Create Schema & Seed Sample Data

You can initialize your database schema and populate it with sample data using the `psql` client.
```bash
psql "host=$SUPABASE_HOST dbname=$SUPABASE_DB user=$SUPABASE_USER password=$SUPABASE_PASSWORD port=$SUPABASE_PORT sslmode=require" -f etl/sql/01_schema.sql
psql "host=$SUPABASE_HOST dbname=$SUPABASE_DB user=$SUPABASE_USER password=$SUPABASE_PASSWORD port=$SUPABASE_PORT sslmode=require" -f etl/sql/02_seed_data.sql
```
  **Prerequisites**
* Ensure PostgreSQL client (psql) is installed.

* Add the directory containing psql.exe to your Environment Variables → System Variables → Path.
  ```markfile
  C:\Program Files\PostgreSQL\17\bin\
  ```

**Running via PowerShell Script**

* To simplify execution, you can use the `run_sql.ps1` script. This script loads environment variables from your `.env` file and runs the SQL files automatically.
```ps1
# run_sql.ps1
Write-Host "Loading environment variables from .env..."

# Load .env file into PowerShell $env: variables
Get-Content .env | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        Write-Host "Loaded $($matches[1])"
    }
}

Write-Host "Environment variables loaded."
Write-Host "Running SQL files against Supabase..."

# Run schema
psql "host=$env:SUPABASE_HOST dbname=$env:SUPABASE_DB user=$env:SUPABASE_USER password=$env:SUPABASE_PASSWORD port=$env:SUPABASE_PORT sslmode=require" -f etl/sql/01_schema.sql

# Run seed data
psql "host=$env:SUPABASE_HOST dbname=$env:SUPABASE_DB user=$env:SUPABASE_USER password=$env:SUPABASE_PASSWORD port=$env:SUPABASE_PORT sslmode=require" -f etl/sql/02_seed_data.sql

Write-Host "Done!"

```

VS Code SQLTools (optional)
Add this to your `.vscode/settings.json` if you use SQLTools:
```json
{
  "sqltools.connections": [
    {
      "name": "Supabase (Postgres)",
      "driver": "PostgreSQL",
      "server": "${env:SUPABASE_HOST}",
      "port": 5432,
      "database": "${env:SUPABASE_DB}",
      "username": "${env:SUPABASE_USER}",
      "password": "${env:SUPABASE_PASSWORD}",
      "ssl": "require"
    }
  ]
}
```
---
### Checking of Setup and Environment

* Python venv works `pip list` shows packages installed.
    ```powershell
    Package            Version
    ------------------ -----------
    certifi            2025.8.3
    charset-normalizer 3.4.3
    colorama           0.4.6
    greenlet           3.2.4
    idna               3.10
    iniconfig          2.1.0
    loguru             0.7.3
    numpy              2.3.2
    packaging          25.0
    pandas             2.3.1
    pip                25.2
    pluggy             1.6.0
    psycopg            3.2.9
    psycopg-binary     3.2.9
    Pygments           2.19.2
    pytest             8.4.1
    python-dateutil    2.9.0.post0
    python-dotenv      1.1.1
    pytz               2025.2
    requests           2.32.4
    six                1.17.0
    SQLAlchemy         2.0.43
    typing_extensions  4.14.1
    tzdata             2025.2
    urllib3            2.5.0
    win32_setctime     1.2.0
    ```

* `python etl/check_connection.py --list-tables` succeeds.

    ```powershell
    2025-08-18 15:02:53.998 | INFO     | __main__:main:40 - Connecting to aws-1-ap-southeast-1.pooler.supabase.com:6543 db=postgres user=postgres.cspfypozqwlxfdplyevj sslmode=require
    2025-08-18 15:02:54.777 | INFO     | __main__:main:48 - Connected: version=PostgreSQL 17.4 on aarch64-unknown-linux-gnu, compiled by gcc (GCC) 13.2.0, 64-bit
    2025-08-18 15:02:54.777 | INFO     | __main__:main:49 - Context: db=postgres, user=postgres, now=2025-08-18 07:02:54.134358+00:00
    2025-08-18 15:02:54.860 | SUCCESS  | __main__:main:62 - Basic query OK (SELECT 1)
    ```

* Test connectivity to Supabase Postgres DB.

    [test_connectivity.ps1](./tests/test_connectivity.ps1)

    ```powershell
    # Load .env file into PowerShell $env: variables
    Get-Content .env | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
            Write-Host "Loaded $($matches[1])"
        }
    }

    Test-NetConnection $env:SUPABASE_HOST -Port $env:SUPABASE_PORT
    ```
  * If the test is succesfull that means your network can reach Supabase you'll see something like this:
  ```powershell
  ComputerName     : db.abc123xyz.supabase.co
  RemoteAddress    : 3.218.45.11
  RemotePort       : 5432
  InterfaceAlias   : Wi-Fi
  TcpTestSucceeded : True
  ```
  * If failed it means your network/firewall is blocking outbound 5432. We’ll need to either:

    * Use Supabase SQL Editor (browser) for now, or

    * Connect via pgAdmin / DBeaver with SSL enabled, or

    * Check firewall rules.
  ```powershell
  TcpTestSucceeded : False
  ```
## **PostgreSQL & Supabase Training**

1.) Copy the sql script from [03_database_schema.sql](/etl/sql/03_database_schema.sql) then run the script in Supabase > SQL Editor. This will create tables in supabase project.
```sql
-- 1. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 2. Employees Table
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    department_id INT REFERENCES departments(department_id),
    hire_date DATE,
    salary NUMERIC(10,2)
);

-- 3. Projects Table
CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(12,2),
    department_id INT REFERENCES departments(department_id)
);

-- 4. Timesheets Table
CREATE TABLE IF NOT EXISTS timesheets (
    timesheet_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    work_date DATE,
    hours_worked NUMERIC(5,2)
);

-- 5. Automation Logs Table
CREATE TABLE IF NOT EXISTS automation_logs (
    log_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    log_date TIMESTAMP,
    task_name VARCHAR(100),
    status VARCHAR(20),
    details TEXT
);

-- 6. Sales Orders Table
CREATE TABLE IF NOT EXISTS sales_orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    employee_id INT REFERENCES employees(employee_id),
    amount NUMERIC(10,2),
    status VARCHAR(20)
);

```

2.) Run the python scripts to upload all the csv files to each tables.
```python
import os
import pandas as pd
import psycopg
from dotenv import load_dotenv

# Load env variables
load_dotenv()

host = os.getenv("SUPABASE_HOST")
port = os.getenv("SUPABASE_PORT")
dbname = os.getenv("SUPABASE_DB")
user = os.getenv("SUPABASE_USER")
password = os.getenv("SUPABASE_PASSWORD")
sslmode = os.getenv("SUPABASE_SSLMODE")

# Connection string
conninfo = f"host={host} port={port} dbname={dbname} user={user} password={password} sslmode={sslmode}"

def upload_csv(table_name, csv_path):
    df = pd.read_csv(csv_path)

    # Replace NaN with None for SQL NULL
    df = df.where(pd.notnull(df), None)

    # Build insert query dynamically
    columns = ", ".join(df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"

    with psycopg.connect(conninfo, prepare_threshold=None) as conn:  # 👈 disable auto prepared statements
        with conn.cursor() as cur:
            cur.executemany(sql, [tuple(row) for _, row in df.iterrows()])
        conn.commit()

# Upload all CSVs
upload_csv("departments", "datasets/to_upload/departments.csv")
upload_csv("employees", "datasets/to_upload/employees.csv")
upload_csv("projects", "datasets/to_upload/projects.csv")
upload_csv("timesheets", "datasets/to_upload/timesheets.csv")
upload_csv("automation_logs", "datasets/to_upload/automation_logs.csv")
upload_csv("sales_orders", "datasets/to_upload/sales_orders.csv")

```
3.) Learned how to **list all tables** in PostgreSQL.
  * Activating psql using [psql_access.ps1](/etl/psql_access.ps1)
    ```powershell
    Write-Host "Loading environment variables from .env..."

    # Load .env file into PowerShell $env: variables
    Get-Content .env | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
            Write-Host "Loaded $($matches[1])"
        }
    }

    Write-Host "Environment variables loaded."
    Write-Host "Running SQL files against Supabase..."

    # Run schema
    psql "host=$env:SUPABASE_HOST dbname=$env:SUPABASE_DB user=$env:SUPABASE_USER password=$env:SUPABASE_PASSWORD port=$env:SUPABASE_PORT sslmode=require"
    ```

  * Input `\dt` in powershell to list all tables.
    ```powershell
    postgres=> \dt
                  List of relations
    Schema |      Name       | Type  |  Owner
    --------+-----------------+-------+----------
    public | automation_logs | table | postgres
    public | departments     | table | postgres
    public | employees       | table | postgres
    public | projects        | table | postgres
    public | sales_orders    | table | postgres
    public | timesheets      | table | postgres
    ```

