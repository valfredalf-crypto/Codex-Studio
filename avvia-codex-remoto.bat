@echo off
REM Avvia Codex Studio + tunnel pubblico sicuro (Cloudflare) su Windows.
REM Usalo dal telefono ovunque (anche 4G): risposte da Claude col TUO abbonamento sul PC.
setlocal
cd /d "%~dp0"

if "%CODEX_PORT%"=="" set CODEX_PORT=4100
if "%CODEX_USER%"=="" set CODEX_USER=codex
if "%CODEX_PASSWORD%"=="" set CODEX_PASSWORD=codex%RANDOM%%RANDOM%

where node >nul 2>nul || (echo Node.js non trovato: https://nodejs.org & pause & exit /b 1)

REM cloudflared: nel PATH, oppure cloudflared.exe in questa cartella.
set "CF=cloudflared"
where cloudflared >nul 2>nul || (
  if exist "%~dp0cloudflared.exe" ( set "CF=%~dp0cloudflared.exe" ) else (
    echo.
    echo  cloudflared non trovato. Scaricalo come cloudflared.exe in questa cartella, poi riprova.
    echo  (comando pronto nelle istruzioni che ti ha dato l'assistente^)
    pause & exit /b 1
  )
)

REM Libera la porta da eventuali vecchi server.
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%CODEX_PORT% " ^| findstr LISTENING') do taskkill /PID %%p /F >nul 2>nul

start "Codex" cmd /c "set CODEX_PORT=%CODEX_PORT%&& set CODEX_USER=%CODEX_USER%&& set CODEX_PASSWORD=%CODEX_PASSWORD%&& npm start"
timeout /t 3 >nul

echo ============================================================
echo   Sul telefono (anche in 4G) apri il link https://....trycloudflare.com
echo   che compare qui sotto, AGGIUNGENDO in fondo:  /?token=%CODEX_PASSWORD%
echo.
echo   Esempio:  https://xxxx.trycloudflare.com/?token=%CODEX_PASSWORD%
echo.
echo   (in alternativa, utente: %CODEX_USER%   password: %CODEX_PASSWORD%)
echo   Tieni il PC acceso con queste finestre aperte.
echo ============================================================
echo.
"%CF%" tunnel --url http://localhost:%CODEX_PORT%
pause
