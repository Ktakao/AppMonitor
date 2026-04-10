@echo off
:: Set character encoding to UTF-8
chcp 65001 > nul
cd /d "%~dp0"

:: Configuration
:: ---------------------------------------------------------
SET "LOG_FILE=monitor_log.txt"
SET "APP_NAME=__APP_NAME__"
SET "APP_PATH=__APP_PATH__"
:: ---------------------------------------------------------

call :Logger "Start Monitoring: %APP_NAME%"

:loop
tasklist /FI "IMAGENAME eq %APP_NAME%" 2>nul | find /i "%APP_NAME%" > nul

:: If not running (ErrorLevel is not 0), restart the app
if errorlevel 1 (
    call :Logger "WARNING: %APP_NAME% is not running. Restarting..."
    start "" "%APP_PATH%"

    timeout /t 3 > nul
    call :Logger "INFO: Restart command executed."
)

timeout /t 10 > nul
goto loop

:: ---------------------------------------------------------
:: Logger
:: ---------------------------------------------------------
:Logger
set "MSG=%~1"
set "TIMESTAMP=%date% %time%"

:: Output to Console
echo [%TIMESTAMP%] %MSG%

:: Append to Log File
echo [%TIMESTAMP%] %MSG% >> "%LOG_FILE%"

exit /b
