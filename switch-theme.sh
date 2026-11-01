#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

THEMES_DIR="colors"
ACTIVE="$THEMES_DIR/active.rasi"

list_themes() {
    ls "$THEMES_DIR" 2>/dev/null | grep -v '^active\.rasi$' | sed 's/\.rasi$//'
}

if [[ $# -eq 0 ]]; then
    echo "Использование: $0 <тема>"
    echo
    echo "Доступные темы:"
    list_themes | sed 's/^/  - /'
    exit 1
fi

THEME="$1"
SRC="$THEMES_DIR/${THEME}.rasi"

if [[ ! -f "$SRC" ]]; then
    echo "Ошибка: тема '$THEME' не найдена."
    echo
    echo "Доступные темы:"
    list_themes | sed 's/^/  - /'
    exit 1
fi

cp "$SRC" "$ACTIVE"
echo "✓ Активная тема: $THEME"

if [[ -f ./switch-style.sh ]]; then
    bash ./switch-style.sh refresh
fi
