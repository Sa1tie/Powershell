# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator."
    exit
}

# Placeholder download URL for SQL Server installer
$downloadUrl = "http://example.com/sqlserver/SQLServerInstaller.exe"

# Placeholder path for SQL Server installer
$installerPath = "$env:TEMP\SQLServerInstaller.exe"

# Check if the SQL Server installer is already present, otherwise download it
if (-Not (Test-Path $installerPath)) {
    Write-Host "Downloading SQL Server Installer..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
}

# Prompt for SQL instance name with default
$instanceName = Read-Host "Enter the SQL Instance Name (default: MSSQLSERVER)" -DefaultValue "MSSQLSERVER"

# Provide options for Authentication Mode and get user's selection
$authOptions = @("Windows Authentication", "Mixed Authentication")
$authMode = $authOptions | Out-GridView -Title "Choose Authentication Mode" -PassThru
if ($authMode -eq "Mixed Authentication") {
    $saPassword = Read-Host "Enter SA password" -AsSecureString
}

# Provide options for SQL features to install and get user's selections
$featureOptions = @(
    @{ Name = "Database Engine Services"; Value = "SQLENGINE" },
    @{ Name = "Full-Text and Semantic Extractions"; Value = "FULLTEXT" },
    @{ Name = "SQL Server Replication"; Value = "REPLICATION" }
)

$features = $featureOptions | Out-GridView -Title "Select Features to Install (Ctrl + Click for multiple)" -PassThru | ForEach-Object { $_.Value } -join ","

# Prompt for installation directory with default
$installDir = Read-Host "Enter Installation Directory" -DefaultValue "C:\Program Files\Microsoft SQL Server"

# Create configuration file for silent installation
$configPath = "$env:TEMP\SQLConfigurationFile.ini"
$configContent = @"
[OPTIONS]
ACTION="Install"
FEATURES="$features"
INSTANCENAME="$instanceName"
SQLSVCACCOUNT="NT AUTHORITY\SYSTEM"
SQLSYSADMINACCOUNTS="$env:USERDOMAIN\$env:USERNAME"
SECURITYMODE="$authMode"
AGTSVCSTARTUPTYPE="Automatic"
TCPENABLED="1"
NPENABLED="1"
INSTANCEDIR="$installDir"
IACCEPTSQLSERVERLICENSETERMS="True"
"@

if ($authMode -eq "Mixed Authentication") {
    $saPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($saPassword))
    $configContent += "SAPWD=""$saPasswordPlain"""
}

$configContent | Out-File -FilePath $configPath

# Run SQL Server installer with the generated configuration file
Write-Host "Running SQL Server Installer..."
Start-Process -FilePath $installerPath -ArgumentList "/ConfigurationFile=$configPath" -Wait -NoNewWindow

# Clean up the downloaded files
Remove-Item $installerPath
Remove-Item $configPath

Write-Host "SQL Server installation completed."
