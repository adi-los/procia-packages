#!/bin/bash
# Add the Procia APT repository, then install procia.
# Usage:
#   curl -fsSL https://adi-los.github.io/procia-packages/setup-apt.sh | bash

set -e

PAGES_BASE="${PAGES_BASE:-https://adi-los.github.io/procia-packages}"

# ── Require root ──────────────────────────────────────────────────────────────
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: This script must be run as root." >&2
  echo "       Run: sudo bash <(curl -fsSL ${PAGES_BASE}/setup-apt.sh)" >&2
  exit 1
fi

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  Procia — APT Repository Setup"
echo "══════════════════════════════════════════════════════════"
echo ""

# ── Add repo ──────────────────────────────────────────────────────────────────
echo "Adding Procia repository..."
apt-get install -y apt-transport-https ca-certificates curl 2>/dev/null | tail -1

echo "deb [trusted=yes] ${PAGES_BASE}/deb stable main" \
  > /etc/apt/sources.list.d/procia.list

apt-get update -qq
echo "  OK Repository added: /etc/apt/sources.list.d/procia.list"

# ── Install ───────────────────────────────────────────────────────────────────
echo ""
echo "Installing Procia..."
apt-get install -y procia

echo ""
echo "Done! Procia is installed and the App Platform is running."
