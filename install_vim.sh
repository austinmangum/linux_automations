#!/usr/bin/env bash
set -euo pipefail

if command -v vim >/dev/null 2>&1; then
  echo "Vim is already installed"
  exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y vim
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y vim
elif command -v yum >/dev/null 2>&1; then
  sudo yum install -y vim
elif command -v zypper >/dev/null 2>&1; then
  sudo zypper install -y vim
else
  echo "Unsupported distribution" >&2
  exit 1
fi

echo "Vim installed."
