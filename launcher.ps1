# Configuration
# ---------------------------------------------------------
# Target App: __APP_NAME__
$BatFileName = "monitor.bat"
# ---------------------------------------------------------

# Get the path of the batch file located in the same directory as this script
$ScriptPath = $MyInvocation.MyCommand.Path
$Dir = Split-Path $ScriptPath -Parent
$BatPath = Join-Path -Path $Dir -ChildPath $BatFileName

# Execute the batch file in a hidden window
Start-Process -FilePath $BatPath -WindowStyle Hidden
