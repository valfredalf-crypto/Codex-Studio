#!/usr/bin/env bash
# Avvia Codex Studio + un tunnel pubblico sicuro (Cloudflare): usalo dal telefono
# OVUNQUE, con le risposte generate da Claude tramite il TUO abbonamento sul PC.
set -e
cd "$(dirname "$0")" || exit 1

PORT="${CODEX_PORT:-4100}"

if [ -z "${CODEX_PASSWORD:-}" ]; then
  CODEX_PASSWORD="$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom 2>/dev/null | head -c 12)"
  [ -z "$CODEX_PASSWORD" ] && CODEX_PASSWORD="codex$RANDOM$RANDOM"
fi
export CODEX_PASSWORD
export CODEX_USER="${CODEX_USER:-codex}"

if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node.js non trovato: installalo da https://nodejs.org"
  read -n 1 -s -r -p "Premi un tasto per chiudere…"; exit 1
fi
if command -v claude >/dev/null 2>&1; then
  claude auth status >/dev/null 2>&1 || echo "⚠️  Non sei connesso a Claude Code. Esegui prima:  claude auth login"
else
  echo "⚠️  Claude Code non trovato: installalo da https://www.anthropic.com/claude-code"
fi
if ! command -v cloudflared >/dev/null 2>&1; then
  echo "❌ 'cloudflared' non trovato. Installalo una volta sola:"
  echo "   • macOS:  brew install cloudflared"
  echo "   • Windows/Linux: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
  read -n 1 -s -r -p "Premi un tasto per chiudere…"; exit 1
fi

CODEX_PORT="$PORT" npm start &
CODEX_PID=$!
cleanup() { kill "$CODEX_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM
sleep 2

echo ""
echo "============================================================"
echo "  Qui sotto comparirà un link 'https://....trycloudflare.com'."
echo ""
echo "  • iPhone/iPad: apri   <link>/?token=$CODEX_PASSWORD"
echo "    (così l'accesso resta salvato anche dopo 'Aggiungi a Home')."
echo "  • In alternativa apri il link e inserisci:"
echo "       utente:   $CODEX_USER"
echo "       password: $CODEX_PASSWORD"
echo ""
echo "  Il PC deve restare acceso con questa finestra aperta."
echo "============================================================"
echo ""

cloudflared tunnel --url "http://localhost:$PORT"
