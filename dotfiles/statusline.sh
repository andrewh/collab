#!/usr/bin/env bash
# Claude Code status line: model, context usage, cost, and lines changed.

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "unknown"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | xargs printf '%.0f')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' | xargs printf '%.2f')
ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Colour context percentage: green <50%, yellow 50-75%, red >75%
if [ "$PCT" -ge 75 ]; then
    CLR='\033[31m'
elif [ "$PCT" -ge 50 ]; then
    CLR='\033[33m'
else
    CLR='\033[32m'
fi
RST='\033[0m'

printf '%b' "${MODEL} | ${CLR}${PCT}%% context${RST} | \$${COST} | +${ADDED}/-${REMOVED}"
