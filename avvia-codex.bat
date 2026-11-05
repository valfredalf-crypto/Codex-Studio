@echo off
REM Avvia Codex Studio con un doppio clic (Windows) - versione robusta.
REM Motore predefinito: Claude - abbonamento (nessuna chiave, nessun credito API).
setlocal
cd /d "%~dp0"

if "%CODEX_PORT%"=="" set CODEX_PORT=4100

where node >nul 2>nul || (echo Node.js non trovato: https://nodejs.org & pause & exit /b 1)

REM Libera la porta se un vecchio Codex e' ancora attivo (evita l'errore EADDRINUSE).
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%CODEX_PORT% " ^| findstr LISTENING') do taskkill /PID %%p /F >nul 2>nul

start "" http://localhost:%CODEX_PORT%
echo.
echo   Codex Studio in avvio su http://localhost:%CODEX_PORT%
echo   (Lascia aperta questa finestra mentre lo usi. Chiudila per fermarlo.)
echo.
call npm start
echo.
echo   --- Se qui sopra vedi un errore, fai uno screenshot. ---
pause
