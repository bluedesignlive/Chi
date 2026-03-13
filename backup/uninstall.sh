#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  Chi — Uninstall Script
# ═══════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[Chi]${NC} $1"; }
ok()    { echo -e "${GREEN}[Chi]${NC} $1"; }
warn()  { echo -e "${YELLOW}[Chi]${NC} $1"; }

echo ""
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo -e "${BOLD}  Chi — Uninstall                      ${NC}"
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo ""

# ── Detect Qt QML path ────────────────────────────────────────
QMAKE_BIN=$(command -v qmake6 2>/dev/null || command -v qmake 2>/dev/null)

if [ -z "$QMAKE_BIN" ]; then
    warn "qmake not found. Trying common paths..."
    for TRYPATH in /usr/lib64/qt6/qml /usr/lib/qt6/qml /usr/lib/x86_64-linux-gnu/qt6/qml; do
        if [ -d "$TRYPATH/Chi" ]; then
            QML_DIR="$TRYPATH"
            break
        fi
    done
else
    QML_DIR=$($QMAKE_BIN -query QT_INSTALL_QML 2>/dev/null)
fi

CHI_INSTALL="$QML_DIR/Chi"
CHI_CONFIG="$HOME/.config/chi"
BUILD_DIR="build"

NEED_SUDO=""
if [ -d "$CHI_INSTALL" ] && [ ! -w "$CHI_INSTALL" ]; then
    NEED_SUDO="sudo"
fi

# ── Show what will be removed ─────────────────────────────────
echo -e "  This will remove:"
echo ""
[ -d "$CHI_INSTALL" ] && echo -e "    ${RED}✗${NC} $CHI_INSTALL  (installed library)"
[ -d "$BUILD_DIR" ]   && echo -e "    ${RED}✗${NC} ./$BUILD_DIR  (build artifacts)"
echo ""

read -rp "$(echo -e "${CYAN}[Chi]${NC} Also remove config (~/.config/chi)? [y/N] ")" DEL_CONFIG
DEL_CONFIG=${DEL_CONFIG:-N}

echo ""
read -rp "$(echo -e "${CYAN}[Chi]${NC} Proceed with uninstall? [y/N] ")" CONFIRM
CONFIRM=${CONFIRM:-N}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
fi

# ── Remove installed library ──────────────────────────────────
if [ -d "$CHI_INSTALL" ]; then
    info "Removing $CHI_INSTALL ..."
    $NEED_SUDO rm -rf "$CHI_INSTALL"
    ok "Library removed."
else
    warn "Library not found at $CHI_INSTALL (already removed?)"
fi

# ── Remove build directory ────────────────────────────────────
if [ -d "$BUILD_DIR" ]; then
    info "Removing ./$BUILD_DIR ..."
    rm -rf "$BUILD_DIR"
    ok "Build directory removed."
fi

# ── Optionally remove config ─────────────────────────────────
if [[ "$DEL_CONFIG" =~ ^[Yy]$ ]]; then
    if [ -d "$CHI_CONFIG" ]; then
        info "Removing $CHI_CONFIG ..."
        rm -rf "$CHI_CONFIG"
        ok "Config removed."
    fi
else
    ok "Config preserved at $CHI_CONFIG"
fi

# ── Also clean old smartui-beta config if present ─────────────
OLD_CONFIG="$HOME/.config/smartui-beta"
if [ -d "$OLD_CONFIG" ]; then
    info "Found old smartui-beta config at $OLD_CONFIG"
    read -rp "$(echo -e "${CYAN}[Chi]${NC} Remove old smartui-beta config? [Y/n] ")" DEL_OLD
    DEL_OLD=${DEL_OLD:-Y}
    if [[ "$DEL_OLD" =~ ^[Yy]$ ]]; then
        rm -rf "$OLD_CONFIG"
        ok "Old config removed."
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}  Chi uninstalled.${NC}"
echo ""
