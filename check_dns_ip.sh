#!/usr/bin/env bash
set -euo pipefail

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  echo "Connectivity to 8.8.8.8 is OK."
  exit 0
else
  echo "Cannot reach 8.8.8.8" >&2
  exit 1
fi
