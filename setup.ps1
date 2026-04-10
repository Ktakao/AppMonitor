<#
.SYNOPSIS
    AppMonitor Setup Script
.DESCRIPTION
    Reads template files under Git management, injects the provided arguments,
    and deploys them to the target directory (C:\AppMonitor).
    It also creates a startup shortcut for background execution.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AppName,

    [Parameter(Mandatory=$true)]
    [string]$AppPath
)

# --- Configuration ---
# Installation Target Directory
$TargetDir = "C:\AppMonitor"
# ---------------------

# 1. Check Administrator Privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Please run this script with Administrator privileges." -ForegroundColor Red
    exit
}

# 2. Create Target Directory
if (-not (Test-Path -Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
    Write-Host "Directory created: $TargetDir" -ForegroundColor Green
}

# Source files location (same directory as this script)
$SourceDir = $PSScriptRoot

# 3. Generate and Deploy monitor.bat
$BatTemplate = Get-Content (Join-Path $SourceDir "monitor.bat") -Raw -Encoding UTF8
$BatContent = $BatTemplate -replace "__APP_NAME__", $AppName `
                           -replace "__APP_PATH__", $AppPath

$BatDest = Join-Path $TargetDir "monitor.bat"
# Ensure proper UTF-8 encoding for batch files to avoid execution issues
[System.IO.File]::WriteAllText($BatDest, $BatContent, [System.Text.Encoding]::UTF8)
Write-Host "Generated: $BatDest" -ForegroundColor Green

# 4. Generate and Deploy launcher.ps1
$PsTemplate = Get-Content (Join-Path $SourceDir "launcher.ps1") -Raw -Encoding UTF8
$PsContent = $PsTemplate -replace "__APP_NAME__", $AppName

$PsDest = Join-Path $TargetDir "launcher.ps1"
[System.IO.File]::WriteAllText($PsDest, $PsContent, [System.Text.Encoding]::UTF8)
Write-Host "Generated: $PsDest" -ForegroundColor Green

# 5. Create Startup Shortcut
$StartupDir = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path -Path $StartupDir -ChildPath "AppMonitor_Launcher.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# Configure shortcut to run launcher.ps1 hidden via PowerShell
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PsDest`""
$Shortcut.WorkingDirectory = $TargetDir
$Shortcut.IconLocation = "shell32.dll,238" # Optional: set a standard system icon
$Shortcut.Save()

Write-Host "Startup registration completed: $ShortcutPath" -ForegroundColor Cyan
Write-Host "---------------------------------------------------"
Write-Host "Setup completed successfully."
Write-Host "To start immediately, run the following command:"
Write-Host "powershell -File `"$PsDest`"" -ForegroundColor Yellow
