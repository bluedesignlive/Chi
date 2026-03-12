#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  Chi — Uninstall Script
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[Chi]${NC} $1"; }
ok()    { echo -e "${GREEN}[Chi]${NC} $1"; }
warn()  { echo -e "${YELLOW}[Chi]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo -e "${BOLD}  Chi — Uninstall                      ${NC}"
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo ""

# ── Detect Qt QML path ────────────────────────────────────────
QML_DIR=""
for TRY in qmake6 qmake; do
    if command -v "$TRY" >/dev/null 2>&1; then
        QML_DIR=$("$TRY" -query QT_INSTALL_QML 2>/dev/null)
        break
    fi
done

if [ -z "$QML_DIR" ]; then
    for TRYPATH in /usr/lib64/qt6/qml /usr/lib/qt6/qml /usr/lib/x86_64-linux-gnu/qt6/qml; do
        if [ -d "$TRYPATH/Chi" ]; then
            QML_DIR="$TRYPATH"
            break
        fi
    done
fi

CHI_INSTALL="$QML_DIR/Chi"
CHI_CONFIG="$HOME/.config/chi"
OLD_CONFIG="$HOME/.config/smartui-beta"
BUILD_DIR="$SCRIPT_DIR/build"

NEED_SUDO=""
if [ -d "$CHI_INSTALL" ] && [ ! -w "$CHI_INSTALL" ]; then
    NEED_SUDO="sudo"
fi

# ── Show what will be removed ─────────────────────────────────
echo -e "  Will remove:"
echo ""
[ -d "$CHI_INSTALL" ] && echo -e "    ${RED}✗${NC} $CHI_INSTALL"
[ -d "$BUILD_DIR" ]   && echo -e "    ${RED}✗${NC} $BUILD_DIR"

# Also clean in-source cmake pollution if present
INSOURCE=""
for JUNK in CMakeCache.txt CMakeFiles cmake_install.cmake; do
    [ -e "$SCRIPT_DIR/$JUNK" ] && INSOURCE="yes"
done
[ -n "$INSOURCE" ] && echo -e "    ${RED}✗${NC} In-source CMake artifacts"

echo ""

read -rp "$(echo -e "${CYAN}[Chi]${NC} Also remove config (~/.config/chi)? [y/N] ")" DEL_CONFIG
DEL_CONFIG=${DEL_CONFIG:-N}

echo ""
read -rp "$(echo -e "${CYAN}[Chi]${NC} Proceed? [y/N] ")" CONFIRM
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
    info "Removing $BUILD_DIR ..."
    rm -rf "$BUILD_DIR"
    ok "Build directory removed."
fi

# ── Clean in-source cmake pollution ───────────────────────────
if [ -n "$INSOURCE" ]; then
    info "Cleaning in-source CMake artifacts..."
    rm -rf "$SCRIPT_DIR/CMakeCache.txt" \
           "$SCRIPT_DIR/CMakeFiles" \
           "$SCRIPT_DIR/cmake_install.cmake" \
           "$SCRIPT_DIR/Makefile" \
           "$SCRIPT_DIR/install_manifest.txt" \
           "$SCRIPT_DIR/CTestTestfile.cmake" \
           "$SCRIPT_DIR"/*.cbp 2>/dev/null
    ok "Source tree cleaned."
fi

# ── Config ────────────────────────────────────────────────────
if [[ "$DEL_CONFIG" =~ ^[Yy]$ ]]; then
    [ -d "$CHI_CONFIG" ] && rm -rf "$CHI_CONFIG" && ok "Config removed: $CHI_CONFIG"
else
    ok "Config preserved: $CHI_CONFIG"
fi

# ── Old smartui-beta config ───────────────────────────────────
if [ -d "$OLD_CONFIG" ]; then
    read -rp "$(echo -e "${CYAN}[Chi]${NC} Remove old smartui-beta config ($OLD_CONFIG)? [Y/n] ")" DEL_OLD
    DEL_OLD=${DEL_OLD:-Y}
    if [[ "$DEL_OLD" =~ ^[Yy]$ ]]; then
        rm -rf "$OLD_CONFIG"
        ok "Old smartui-beta config removed."
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}  Chi uninstalled.${NC}"
echo ""
