#!/bin/bash
# SessionStart hook — check if freshness check is due
STATE="$HOME/.claude/state/freshness.json"

if [ ! -f "$STATE" ]; then
  echo "[FRESHNESS] First run — run /check-freshness full to initialize."
  exit 0
fi

LAST=$(grep -o '"lastCheck": "[^"]*"' "$STATE" | head -1 | cut -d'"' -f4)
if [ -z "$LAST" ]; then
  echo "[FRESHNESS] No last check date found — run /check-freshness full."
  exit 0
fi

NOW=$(date +%s)
LAST_TS=$(date -d "$LAST" +%s 2>/dev/null || echo 0)
if [ "$LAST_TS" -eq 0 ]; then
  exit 0
fi

DAYS=$(( (NOW - LAST_TS) / 86400 ))

if [ $DAYS -ge 30 ]; then
  echo "[FRESHNESS] ${DAYS} days since last check (>=30) — run /check-freshness full."
elif [ $DAYS -ge 7 ]; then
  echo "[FRESHNESS] ${DAYS} days since last check (>=7) — consider /check-freshness light."
fi
