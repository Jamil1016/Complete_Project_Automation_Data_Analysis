# Load .env file into PowerShell $env: variables
Get-Content .env | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        Write-Host "Loaded $($matches[1])"
    }
}

Test-NetConnection $env:SUPABASE_HOST -Port $env:SUPABASE_PORT