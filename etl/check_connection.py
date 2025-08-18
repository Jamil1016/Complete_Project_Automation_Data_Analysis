import os
import argparse
from datetime import datetime
from loguru import logger
from dotenv import load_dotenv

try:
    import psycopg
except ImportError:
    raise SystemExit("Please install psycopg: pip install psycopg[binary]")

load_dotenv()

def get_conn_kwargs():
    host = os.getenv("SUPABASE_HOST")
    port = int(os.getenv("SUPABASE_PORT", "6543"))
    db = os.getenv("SUPABASE_DB", "postgres")
    user = os.getenv("SUPABASE_USER", "postgres")
    pw = os.getenv("SUPABASE_PASSWORD")
    sslmode = os.getenv("SUPABASE_SSLMODE", "require")
    if not all([host, db, user, pw]):
        raise SystemExit("Missing one or more required env vars: SUPABASE_HOST/DB/USER/PASSWORD")
    return dict(host=host, port=port, dbname=db, user=user, password=pw, sslmode=sslmode)

def list_tables(cur, schema="public"):
    cur.execute("""            SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_type='BASE TABLE' AND table_schema=%s
        ORDER BY table_schema, table_name
    """, (schema,))
    return cur.fetchall()

def main():
    parser = argparse.ArgumentParser(description="Check Supabase/Postgres connection")
    parser.add_argument("--schema", default=os.getenv("SUPABASE_SCHEMA", "public"))
    parser.add_argument("--list-tables", action="store_true")
    args = parser.parse_args()

    kwargs = get_conn_kwargs()
    logger.info(f"Connecting to {kwargs['host']}:{kwargs['port']} db={kwargs['dbname']} user={kwargs['user']} sslmode={kwargs['sslmode']}")

    with psycopg.connect(**kwargs) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT version();")
            version = cur.fetchone()[0]
            cur.execute("SELECT current_database(), current_user, now();")
            db, user, now = cur.fetchone()
            logger.info(f"Connected: version={version}")
            logger.info(f"Context: db={db}, user={user}, now={now}")

            if args.list_tables:
                rows = list_tables(cur, args.schema)
                if rows:
                    for s, t in rows:
                        print(f"{s}.{t}")
                else:
                    print(f"No tables found in schema '{args.schema}'.")

            # Minimal test query
            cur.execute("SELECT 1;")
            assert cur.fetchone()[0] == 1
            logger.success("Basic query OK (SELECT 1)")

if __name__ == "__main__":
    main()