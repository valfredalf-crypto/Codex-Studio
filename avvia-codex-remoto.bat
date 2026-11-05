@echo off
REM Avvia Codex Studio + tunnel pubblico sicuro (Cloudflare) su Windows.
REM Usalo dal telefono ovunque (anche 4G): risposte da Claude col TUO abbonamento sul PC.
setlocal EnableDelayedExpansion
cd /d "%~dp0"

if "%CODEX_PORT%"=="" set CODEX_PORT=4100
if "%CODEX_USER%"=="" set CODEX_USER=codex
if "%CODEX_PASSWORD%"=="" set CODEX_PASSWORD=codex%RANDOM%%RANDOM%

where node >nul 2>nul || (echo Node.js non trovato: https://nodejs.org & pause & exit /b 1)

REM Trova cloudflared: nel PATH, oppure un .exe scaricato in questa cartella (qualsiasi nome cloudflared*).
set "CF="
where cloudflared >nul 2>nul && set "CF=cloudflared"
if not defined CF if exist "%~dp0cloudflared.exe" set "CF=%~dp0cloudflared.exe"
if not defined CF for %%f in ("%~dp0cloudflared*.exe") do set "CF=%%f"
if not defined CF (
  echo.
  echo  cloudflared non trovato. Scarica cloudflared-windows-amd64.exe e mettilo in questa cartella, poi riprova.
  echo  Link: https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe
  echo.
  pause & exit /b 1
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
"!CF!" tunnel --url http://localhost:%CODEX_PORT%
pause
