# Configuration
# ---------------------------------------------------------
# Target App: __APP_NAME__
$BatFileName = "monitor.bat"
# ---------------------------------------------------------

# Get the full path of the batch file located in the same directory as this script
$BatPath = Join-Path -Path $PSScriptRoot -ChildPath $BatFileName

# Execute the batch file in a hidden window
Start-Process -FilePath $BatPath -WindowStyle Hidden

