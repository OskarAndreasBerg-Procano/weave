#!/bin/sh
# weave installer for macOS / Linux.
# usage:  curl -fsSL https://raw.githubusercontent.com/OskarAndreasBerg-Procano/weave/main/install.sh | sh

set -e

REPO_URL="https://raw.githubusercontent.com/OskarAndreasBerg-Procano/weave/main/weave"
INSTALL_DIR="${WEAVE_INSTALL_DIR:-$HOME/.local/bin}"
DEST="$INSTALL_DIR/weave"

step() { printf "\033[36m->\033[0m %s\n" "$1"; }
ok()   { printf "\033[32m+\033[0m %s\n" "$1"; }
warn() { printf "\033[33m!\033[0m %s\n" "$1" >&2; }
die()  { printf "\033[31mx\033[0m %s\n" "$1" >&2; exit 1; }

# 1. tools
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  die "Python 3 not found on PATH. Install it from https://python.org first."
fi

if ! command -v claude >/dev/null 2>&1; then
  warn "'claude' CLI not on PATH yet. Install Claude Code from https://claude.com/code first, then re-run this installer."
  exit 1
fi

# 2. download
mkdir -p "$INSTALL_DIR"
step "downloading weave -> $DEST"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REPO_URL" -o "$DEST"
elif command -v wget >/dev/null 2>&1; then
  wget -q "$REPO_URL" -O "$DEST"
else
  die "neither curl nor wget found on PATH"
fi
chmod +x "$DEST"
ok "installed $DEST"

# 3. PATH
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    case "$(basename "${SHELL:-}")" in
      zsh)  RC="$HOME/.zshrc" ;;
      bash) RC="$HOME/.bashrc" ;;
      *)    RC="$HOME/.profile" ;;
    esac
    if [ -w "$(dirname "$RC")" ]; then
      printf '\n# weave\nexport PATH="%s:$PATH"\n' "$INSTALL_DIR" >> "$RC"
      ok "added $INSTALL_DIR to PATH in $RC (open a new shell to pick it up)"
    else
      warn "could not write to $RC; add $INSTALL_DIR to PATH manually"
    fi
    ;;
esac

# 4. register globally
step "registering weave with Claude Code (user scope)"
"$PY" "$DEST" install

cat <<EOF

  weave is installed.

  Next:
    cd <any project>
    $PY $DEST init       # creates .weave/graph.json + a CLAUDE.md block
    claude               # open Claude Code - weave_* tools are live

  Optional:
    $PY $DEST serve      # opens the live workspace at 127.0.0.1:4747

EOF
