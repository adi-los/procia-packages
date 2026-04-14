#!/bin/sh
# Procia installer — downloads the pre-built binary for macOS or Linux
# Usage:
#   curl -fsSL https://adi-los.github.io/procia-packages/install.sh | bash

set -e

PAGES_BASE="https://adi-los.github.io/procia-packages"
INSTALL_DIR="/usr/local/bin"
BINARY="procia"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  arm64)   ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

case "$OS" in
  linux)
    # On Linux, prefer the package manager repos (they run postinstall which sets everything up)
    if command -v dnf >/dev/null 2>&1; then
      echo "Tip: For full platform setup use: curl -fsSL ${PAGES_BASE}/setup-dnf.sh | bash"
    elif command -v apt-get >/dev/null 2>&1; then
      echo "Tip: For full platform setup use: curl -fsSL ${PAGES_BASE}/setup-apt.sh | bash"
    fi
    DOWNLOAD_URL="${PAGES_BASE}/linux/${ARCH}/procia"
    ;;
  darwin)
    DOWNLOAD_URL="${PAGES_BASE}/mac/${ARCH}/procia"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Installing procia for $OS/$ARCH..."
echo "  from: $DOWNLOAD_URL"
echo "  to:   $INSTALL_DIR/$BINARY"

# Download
TMP=$(mktemp)
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$DOWNLOAD_URL" -o "$TMP"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$TMP" "$DOWNLOAD_URL"
else
  echo "Error: curl or wget is required"
  exit 1
fi

chmod +x "$TMP"

# Install (use sudo if not root)
if [ "$(id -u)" = "0" ]; then
  mv "$TMP" "$INSTALL_DIR/$BINARY"
else
  echo "  (requires sudo to write to $INSTALL_DIR)"
  sudo mv "$TMP" "$INSTALL_DIR/$BINARY"
fi

echo ""
echo "procia installed successfully!"
echo ""
procia --version 2>/dev/null || true
echo ""
echo "Next steps:"
echo "  procia store seed          # seeds local package cache (~500 npm packages)"
echo "  procia new my-api --type=api --db=postgres"
echo "  cd my-api && procia install && procia dev"
