#!/usr/bin/env bash
# Install Claude Code dotfiles to ~/.claude/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

# Settings: merge if exists, write if not
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "~/.claude/settings.json already exists"
    echo "  Review $SCRIPT_DIR/settings.json and merge manually"
    echo "  (Overwriting may lose your existing permissions and hooks)"
else
    cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
    echo "Installed settings.json"
fi

# CLAUDE.md: never silently overwrite
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "~/.claude/CLAUDE.md already exists"
    echo "  Review $SCRIPT_DIR/CLAUDE.md and merge manually"
    echo "  (This file likely has personal customisations)"
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "Installed CLAUDE.md"
fi

# Status line: safe to overwrite
cp "$SCRIPT_DIR/statusline.sh" "$CLAUDE_DIR/statusline.sh"
chmod +x "$CLAUDE_DIR/statusline.sh"
echo "Installed statusline.sh"

# Commands: safe to overwrite (no user customisation)
mkdir -p "$CLAUDE_DIR/commands"
for cmd in "$SCRIPT_DIR"/commands/*.md; do
    [ -f "$cmd" ] || continue
    cp "$cmd" "$CLAUDE_DIR/commands/"
    echo "Installed command: $(basename "$cmd" .md)"
done

echo ""
echo "Done. Review installed files:"
echo "  $CLAUDE_DIR/settings.json"
echo "  $CLAUDE_DIR/CLAUDE.md"
echo "  $CLAUDE_DIR/statusline.sh"
echo "  $CLAUDE_DIR/commands/"
