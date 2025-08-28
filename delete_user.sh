#!/usr/bin/env bash
# delete_user.sh
# REQUIREMENTS COVERED:
# 1) Takes username arg – errors if missing
# 2) Asks for confirmation
# 3) Deletes user and home directory
# 4) Displays /etc/passwd to verify
# 5) Demo file provided separately (demo_delete_user.sh)

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <username>" >&2
  exit 1
fi

USERNAME="$1"

if ! id -u "${USERNAME}" >/dev/null 2>&1; then
  echo "User ${USERNAME} does not exist." >&2
  exit 1
fi

read -r -p "Are you sure you want to delete user '${USERNAME}' and their home directory? [y/N] " ans
case "${ans:-N}" in
  y|Y|yes|YES)
    echo "Deleting user ${USERNAME} (and home) ..."
    userdel -r "${USERNAME}"
    ;;
  *)
    echo "Aborted."
    exit 0
    ;;
esac

echo
echo "Verifying deletion from /etc/passwd:"
if grep -E "^${USERNAME}:" /etc/passwd; then
  echo "User still present in /etc/passwd (unexpected)." >&2
  exit 1
else
  echo "User ${USERNAME} removed from /etc/passwd."
fi

