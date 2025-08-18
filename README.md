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
---

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