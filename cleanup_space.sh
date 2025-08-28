#!/usr/bin/env bash
set -euo pipefail

get_free_kb() { df -kP / | awk 'NR==2{print $4}'; }

before_kb=$(get_free_kb)

cleanDir() {
  local d="$1"
  if [[ -d "$d" ]]; then
    sudo rm -rf "${d}/"* "${d}"/.[!.]* "${d}"/..?* 2>/dev/null || true
  fi
}

DIRS_TO_CLEAN=(
  "/var/log"
  "$HOME/.cache"
)

for d in "${DIRS_TO_CLEAN[@]}"; do
  cleanDir "$d"
done

after_kb=$(get_free_kb)
delta=$(( after_kb - before_kb ))

echo "Free space before: ${before_kb} KB"
echo "Free space after : ${after_kb} KB"
if (( delta > 0 )); then
  echo "Freed: ${delta} KB"
else
  echo "No significant disk space was freed"
fi
