#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

CONF="styles/settings.conf"
ACTIVE="styles/active.rasi"
COLOR_ACTIVE="colors/active.rasi"
mkdir -p styles

RADIUS=8; INNER=4; BORDER=2; OPACITY=100; WIDTH=600; LINES=8; POSITION=center
[[ -f "$CONF" ]] && source "$CONF"

save() {
    cat > "$CONF" <<EOF
RADIUS=$RADIUS
INNER=$INNER
BORDER=$BORDER
OPACITY=$OPACITY
WIDTH=$WIDTH
LINES=$LINES
POSITION=$POSITION
EOF
}

render() {
    local bg alpha loc yoff
    bg=$(sed -n 's/^[[:space:]]*bg:[[:space:]]*\(#[0-9a-fA-F]\{6\}\).*/\1/p' "$COLOR_ACTIVE" 2>/dev/null | head -1 || true)
    bg=${bg:-#000000}
    alpha=$(printf '%02X' $(( OPACITY * 255 / 100 )))
    case "$POSITION" in
        top)    loc=north;  yoff=60 ;;
        bottom) loc=south;  yoff=-60 ;;
        *)      loc=center; yoff=0 ;;
    esac
    cat > "$ACTIVE" <<EOF
* {
    radius: ${RADIUS}px;
    radius-inner: ${INNER}px;
    border-width: ${BORDER}px;
    win-width: ${WIDTH}px;
    list-lines: ${LINES};
    bg-win: ${bg}${alpha};
}

window {
    location: ${loc};
    y-offset: ${yoff}px;
}
EOF
}

die() { echo "Ошибка: $*" >&2; exit 1; }

num() { [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= $2 && $1 <= $3 )) || die "нужно число от $2 до $3"; }

show() {
    echo "Текущий стиль:"
    echo "  radius:   ${RADIUS}px (inner ${INNER}px)"
    echo "  border:   ${BORDER}px"
    echo "  opacity:  ${OPACITY}%"
    echo "  width:    ${WIDTH}px"
    echo "  lines:    ${LINES}"
    echo "  position: ${POSITION}"
}

usage() {
    cat <<EOF
Использование: $0 <команда> [значение]

  radius   square | round | soft | pill
  border   0-8        толщина рамки (px)
  opacity  0-100      прозрачность фона (%)
  width    300-1600   ширина окна (px)
  lines    1-20       число строк в списке
  position top | center | bottom
  preset   classic | glass | sharp
  show                показать текущие настройки
  reset               сбросить всё по умолчанию
  refresh             перегенерировать (после смены темы)
EOF
    exit 1
}

case "${1:-}" in
    radius)
        case "${2:-}" in
            square) RADIUS=0;  INNER=0 ;;
            round)  RADIUS=8;  INNER=4 ;;
            soft)   RADIUS=16; INNER=8 ;;
            pill)   RADIUS=24; INNER=12 ;;
            *) die "square | round | soft | pill" ;;
        esac ;;
    border)   num "${2:-x}" 0 8;      BORDER=$2 ;;
    opacity)  num "${2:-x}" 0 100;    OPACITY=$2 ;;
    width)    num "${2:-x}" 300 1600; WIDTH=$2 ;;
    lines)    num "${2:-x}" 1 20;     LINES=$2 ;;
    position)
        case "${2:-}" in
            top|center|bottom) POSITION=$2 ;;
            *) die "top | center | bottom" ;;
        esac ;;
    preset)
        case "${2:-}" in
            classic) RADIUS=8;  INNER=4; BORDER=2; OPACITY=100 ;;
            glass)   RADIUS=16; INNER=8; BORDER=1; OPACITY=80 ;;
            sharp)   RADIUS=0;  INNER=0; BORDER=2; OPACITY=100 ;;
            *) die "classic | glass | sharp" ;;
        esac ;;
    reset)
        RADIUS=8; INNER=4; BORDER=2; OPACITY=100; WIDTH=600; LINES=8; POSITION=center ;;
    refresh) render; exit 0 ;;
    show)    show; exit 0 ;;
    *)       usage ;;
esac

save
render
echo "✓ Готово"
show
