#!/usr/bin/env bash
set -euo pipefail

if nslookup example.com >/dev/null 2>&1; then
  echo "DNS resolution for example.com succeeded."
  exit 0
else
  echo "DNS check failed: cannot resolve example.com" >&2
  exit 1
fi
