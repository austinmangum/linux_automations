#!/usr/bin/env bash
set -euo pipefail
LOGFILE="update.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Package update started at $(date) ==="

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get upgrade -y
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf upgrade -y
elif command -v yum >/dev/null 2>&1; then
  sudo yum update -y
elif command -v zypper >/dev/null 2>&1; then
  sudo zypper refresh
  sudo zypper update -y
else
  echo "Unsupported distribution" >&2
  exit 1
fi

echo "=== Package update finished at $(date) ==="
