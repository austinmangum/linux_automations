#!/usr/bin/env bash
set -euo pipefail

fileSize() {
  local f="$1"
  if [[ -f "$f" ]]; then
    stat -c%s "$f" 2>/dev/null || wc -c < "$f"
  else
    echo 0
  fi
}

TS="$(date +%Y%m%d_%H%M%S)"
TAR_GZ="etc_${TS}.tar.gz"
TAR_BZ2="etc_${TS}.tar.bz2"

sudo tar -C / -czf "${TAR_GZ}" etc
sudo tar -C / -cjf "${TAR_BZ2}" etc

SZ_GZ=$(fileSize "${TAR_GZ}")
SZ_BZ2=$(fileSize "${TAR_BZ2}")

echo "gzip size : ${SZ_GZ} bytes (${TAR_GZ})"
echo "bzip2 size: ${SZ_BZ2} bytes (${TAR_BZ2})"

diff=$(( SZ_GZ - SZ_BZ2 ))
if (( diff == 0 )); then
  echo "Both archives are the same size."
elif (( diff > 0 )); then
  echo "bzip2 is smaller by ${diff} bytes."
else
  echo "gzip is smaller by $((-diff)) bytes."
fi
