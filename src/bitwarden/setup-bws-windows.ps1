<#
.SYNOPSIS
Bitwarden Secret Manager (bws) Installation Script for Windows
🚀 Installs bws v2.0.0 to $env:USERPROFILE\.local\bin
#>

$ErrorActionPreference = "Stop"

# --------------------------
# 📦 Dependency Check
# --------------------------
if (-not (Get-Command "Expand-Archive" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: PowerShell 5.1 or higher is required" -ForegroundColor Red
    exit 1
}

# --------------------------
# 🔍 Check existing installation
# --------------------------
$targetVersion = "2.0.0"
if (Get-Command "bws" -ErrorAction SilentlyContinue) {
    $existingVersion = (bws --version | Select-String -Pattern "\d+\.\d+\.\d+").Matches.Value
    if ($existingVersion -eq $targetVersion) {
        Write-Host "✅ bws v$targetVersion is already installed" -ForegroundColor Green
        exit 0
    }
    Write-Host "⚠️  Found existing bws v$existingVersion, upgrading to v$targetVersion..." -ForegroundColor Yellow
}

# --------------------------
# 📂 Prepare directories
# --------------------------
$installDir = Join-Path $env:USERPROFILE ".local\bin"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
    Write-Host "✅ Created installation directory: $installDir" -ForegroundColor Green
}

# --------------------------
# 📥 Download bws
# --------------------------
$url = "https://github.com/bitwarden/sdk-sm/releases/download/bws-v$targetVersion/bws-x86_64-pc-windows-msvc-$targetVersion.zip"
$tmpZip = Join-Path $env:TEMP "bws-$targetVersion.zip"

Write-Host "📥 Downloading bws v$targetVersion..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $tmpZip -UseBasicParsing
Write-Host "✅ Download completed: $tmpZip" -ForegroundColor Green

# --------------------------
# 📤 Extract and install
# --------------------------
Write-Host "📤 Extracting bws executable..." -ForegroundColor Cyan
Expand-Archive -Path $tmpZip -DestinationPath $env:TEMP -Force
$exePath = Join-Path $env:TEMP "bws.exe"
$targetPath = Join-Path $installDir "bws.exe"
Move-Item -Path $exePath -Destination $targetPath -Force
Write-Host "✅ Installed bws to $targetPath" -ForegroundColor Green

# --------------------------
# 🧹 Cleanup
# --------------------------
Remove-Item -Path $tmpZip -Force -ErrorAction SilentlyContinue
Write-Host "🧹 Cleaned up temporary files" -ForegroundColor Green

# --------------------------
# ✅ Verify installation
# --------------------------
Write-Host ""
Write-Host "🎉 Installation completed successfully!" -ForegroundColor Green
$installedVersion = (& $targetPath --version | Select-String -Pattern "\d+\.\d+\.\d+").Matches.Value
Write-Host "ℹ️  bws version: $installedVersion" -ForegroundColor Cyan

# Add to PATH if not already present
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", $currentPath + ";$installDir", "User")
    Write-Host ""
    Write-Host "💡 Added $installDir to your user PATH" -ForegroundColor Cyan
    Write-Host "⚠️  Please restart your terminal for changes to take effect" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "💡 $installDir is already in your PATH" -ForegroundColor Cyan
}