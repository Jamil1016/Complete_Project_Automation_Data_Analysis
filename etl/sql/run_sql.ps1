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
