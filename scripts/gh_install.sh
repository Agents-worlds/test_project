#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" != "Linux" ]; then
  echo "Error: this installer supports Linux only." >&2
  exit 1
fi

if [ "$ARCH" != "x86_64" ]; then
  echo "Error: this installer supports x86_64 only." >&2
  exit 1
fi

INSTALL_DIR="$HOME/.local/bin"
TARGET_BIN="$INSTALL_DIR/gh"

mkdir -p "$INSTALL_DIR"

LATEST_TAG="$({
  curl -fsSL "https://api.github.com/repos/cli/cli/releases/latest"
} | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"

if [ -z "$LATEST_TAG" ]; then
  echo "Error: failed to resolve latest gh release tag." >&2
  exit 1
fi

LATEST_VERSION="${LATEST_TAG#v}"

if [ -x "$TARGET_BIN" ]; then
  CURRENT_VERSION="$($TARGET_BIN --version 2>/dev/null | sed -n '1s/^gh version \([^ ]*\).*/\1/p')"
  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "gh already installed at $TARGET_BIN (version $CURRENT_VERSION)."
    exit 0
  fi
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

TARBALL="gh_${LATEST_VERSION}_linux_amd64.tar.gz"
URL="https://github.com/cli/cli/releases/download/${LATEST_TAG}/${TARBALL}"

curl -fsSL "$URL" -o "$TMP_DIR/$TARBALL"
tar -xzf "$TMP_DIR/$TARBALL" -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/gh_${LATEST_VERSION}_linux_amd64"
if [ ! -x "$EXTRACTED_DIR/bin/gh" ]; then
  echo "Error: downloaded gh archive missing bin/gh." >&2
  exit 1
fi

cp "$EXTRACTED_DIR/bin/gh" "$TARGET_BIN"
chmod 0755 "$TARGET_BIN"

echo "Installed gh to $TARGET_BIN"
"$TARGET_BIN" --version
