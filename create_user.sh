#!/usr/bin/env bash
# create_user.sh
# REQUIREMENTS COVERED:
# 1) Takes username arg – errors if missing
# 2) Ensures group "dev_group" exists
# 3) Adds user and assigns password (non-interactively)
# 4) Displays /etc/passwd to verify
# 5) Demo file provided separately (demo_create_user.sh) to show requested scenarios
#
# ASSUMPTIONS:
# - Run as root (or via sudo) so useradd/chpasswd succeed without prompting.
# - Default password policy allows setting plain text via chpasswd.
# - We'll set an initial temporary password = "<username>123!" and force a change at first login.

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