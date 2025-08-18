# Runbook — Local Developer Setup

## 1. Secrets & Environment
- Copy `.env.example` to `.env`
- Fill in Supabase Postgres credentials
- Never commit `.env` to git

## 2. Python
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## 3. Connectivity Test
```bash
python etl/check_connection.py --list-tables
```

## 4. Troubleshooting
- SSL errors: ensure `SUPABASE_SSLMODE=require`
- Auth: verify username/password and role grants
- Network: confirm no local firewall blocking port

## 5. Operational Notes
- Logs go to console for now; Week 2 adds rotating logs
- Use least-privileged DB users for reads