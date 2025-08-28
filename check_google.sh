#!/usr/bin/env bash
set -euo pipefail

if ping -c 1 -W 2 google.com >/dev/null 2>&1; then
  echo "Network is up."
  exit 0
else
  echo "Network check failed: cannot reach google.com" >&2
  exit 1
fi
