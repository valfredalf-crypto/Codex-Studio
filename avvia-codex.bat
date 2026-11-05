@echo off
REM Avvia Codex Studio con un doppio clic (Windows).
REM Motore predefinito: Claude - abbonamento (nessuna chiave, nessun credito API).
setlocal
cd /d "%~dp0"

if "%CODEX_PORT%"=="" set CODEX_PORT=4100

where node >nul 2>nul || (echo Node.js non trovato: https://nodejs.org & pause & exit /b 1)
where claude >nul 2>nul && (claude auth status >nul 2>nul || echo ATTENZIONE: esegui prima  claude auth login) || echo ATTENZIONE: Claude Code non trovato: https://www.anthropic.com/claude-code

start "" http://localhost:%CODEX_PORT%
echo Avvio Codex Studio su http://localhost:%CODEX_PORT%  (chiudi questa finestra per fermare)
call npm start
pause
