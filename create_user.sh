#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <username>" >&2
  exit 1
fi

USERNAME="$1"
GROUP="dev_group"
INIT_PASS="${USERNAME}123!"   # Assumption for demo convenience

# Create group if not present
if ! getent group "${GROUP}" >/dev/null; then
  echo "Creating group ${GROUP}..."
  groupadd "${GROUP}"
else
  echo "Group ${GROUP} already exists."
fi

# Create user if not present
if id -u "${USERNAME}" >/dev/null 2>&1; then
  echo "User ${USERNAME} already exists. Ensuring group membership..."
  usermod -aG "${GROUP}" "${USERNAME}"
else
  echo "Creating user ${USERNAME} in group ${GROUP}..."
  useradd -m -g "${GROUP}" -s /bin/bash "${USERNAME}"
fi

# Set initial password and force change on first login
echo "${USERNAME}:${INIT_PASS}" | chpasswd
chage -d 0 "${USERNAME}"

echo "User ${USERNAME} created/updated with a temporary password. Password must be changed at next login."
echo
echo "Excerpt from /etc/passwd (verify user creation):"
grep -E "^${USERNAME}:" /etc/passwd || true