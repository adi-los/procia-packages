#!/bin/bash
# One command to install Procia + App Platform on RHEL / Rocky / Fedora / CentOS
# Usage:
#   curl -fsSL https://adi-los.github.io/procia-packages/setup-dnf.sh | bash

set -e
PAGES_BASE="${PAGES_BASE:-https://adi-los.github.io/procia-packages}"

[ "$EUID" -ne 0 ] && exec sudo bash "$0" "$@"

printf "\n\033[1m══════════════════════════════════════════════════════════\033[0m\n"
printf "\033[1;36m  Procia — Installing on %s\033[0m\n" "$(. /etc/os-release && echo $PRETTY_NAME)"
printf "\033[1m══════════════════════════════════════════════════════════\033[0m\n\n"

# ── Docker CE repo (so dnf resolves docker-ce as a dependency) ───────────────
if ! command -v docker >/dev/null 2>&1; then
  echo "Adding Docker CE repository..."
  dnf install -y dnf-plugins-core 2>/dev/null || true
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 2>/dev/null || true
fi

# ── Procia repo ───────────────────────────────────────────────────────────────
echo "Adding Procia repository..."
cat > /etc/yum.repos.d/procia.repo <<EOF
[procia]
name=Procia - App Platform
baseurl=${PAGES_BASE}/rpm/x86_64
enabled=1
gpgcheck=0
metadata_expire=300
EOF

# ── Clean any cached metadata from old repo ───────────────────────────────────
dnf clean metadata --disablerepo="*" --enablerepo="procia" 2>/dev/null || dnf clean all 2>/dev/null || true

# ── Install ───────────────────────────────────────────────────────────────────
echo "Installing Procia..."
dnf install -y procia

printf "\n\033[1;32m  Done! Run: procia --help\033[0m\n\n"
