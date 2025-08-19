import os
import pandas as pd
import psycopg
from dotenv import load_dotenv

# Load env variables
load_dotenv()

host= os.getenv("SUPABASE_HOST")
port= os.getenv("SUPABASE_PORT")
dbname= os.getenv("SUPABASE_DB")
user= os.getenv("SUPABASE_USER")
password= os.getenv("SUPABASE_PASSWORD")
sslmode= os.getenv("SUPABASE_SSLMODE")

# Connection string
conninfo= f"host={host} port={port} dbname={dbname} user={user} password={password} sslmode={sslmode}"

def upload_csv(table_name, csv_path):
    df = pd.read_csv(csv_path)

    # Replace NaN with None for SQL NULL
    df = df.where(pd.notnull(df), None)

    with psycopg.connect(conninfo) as conn:
        with conn.cursor() as cur:
            for _, row in df.iterrows():
                # Build insert query dynamically
                columns = ", ".join(df.columns)
                placeholders = ", ".join(["%s"] * len(row))
                sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
                cur.execute(sql, tuple(row))
        conn.commit()

upload_csv("departments", "datasets/to_upload/departments.csv")
upload_csv("employees", "datasets/to_upload/employees.csv")
upload_csv("projects", "datasets/to_upload/projects.csv")
upload_csv("timesheets", "datasets/to_upload/timesheets.csv")
upload_csv("automation_logs", "datasets/to_upload/automation_logs.csv")
upload_csv("sales_orders", "datasets/to_upload/sales_orders.csv")
