System Admin Scripting – Run Book (A–G)

Environment: Typical Linux, bash, sudo available.
Scripts Folder: ~/scripts (unless noted).
Exec Bits: Ensure each script is executable.

Quick Setup (once)
mkdir -p ~/scripts && cd ~/scripts

# Place all scripts here, then:
chmod +x create_user.sh demo_create_user.sh delete_user.sh demo_delete_user.sh \
           install_vim.sh update_all.sh \
           check_google.sh check_dns_ip.sh check_nslookup.sh \
           cleanup_space.sh archive_etc.sh

Contents & Mapping
Section	Requirement Summary	Script(s)
A	Create user, set password, force change, show /etc/passwd; demo no-args/with-args/switch	create_user.sh, demo_create_user.sh
B	Delete user (confirm, remove home), show /etc/passwd; demo no-args/with-args/failed su	delete_user.sh, demo_delete_user.sh
C	Customize prompt $, aliases, PATH add ~/bin, run scripts from outside bin	(shell commands below)
D	Install vim if missing; update all packages to update.log	install_vim.sh, update_all.sh
E	Network checks: ping google.com, ping 8.8.8.8, nslookup example.com; flowchart	check_google.sh, check_dns_ip.sh, check_nslookup.sh
F	Disk cleanup: measure before/after; clean directories; report	cleanup_space.sh
G	Archive /etc with gzip & bzip2; compare sizes	archive_etc.sh
A) Create a New User

What you’ll show:

Run without args (expect error)

Run with valid arg

Switch to new user; show forced password change state

Commands
cd ~/scripts

# A1. No args (shows usage error)
./create_user.sh

# A2. With valid username
./create_user.sh devopsdemo

# Verify entry in /etc/passwd is printed by the script automatically.
# A3. Switch to user (non-interactive check) + show password policy
sudo su - devopsdemo -c 'echo "User: $(whoami)"; id'
sudo chage -l devopsdemo | sed -n '1,6p'


Tip (optional on camera): Actually change the password interactively:
su - devopsdemo → follow prompts to set a new password.

Alt (one-button demo):

./demo_create_user.sh

B) Delete the User

What you’ll show:

Run without args (expect error)

Run with valid arg + confirm prompt

Attempt to switch to deleted user (should fail)

Commands
cd ~/scripts

# B1. No args (shows usage error)
./delete_user.sh

# B2. With valid username (auto-confirm "y")
printf "y\n" | ./delete_user.sh devopsdemo

# B3. su should fail now
sudo su - devopsdemo -c 'whoami' || echo "Confirmed: devopsdemo is deleted"


Alt (one-button demo):

./demo_delete_user.sh

C) Shell Initialization Customization

Goal:

Prompt uses $ and color

Aliases in ~/.bash_aliases

Add ~/bin to PATH, move user scripts there, run from outside bin

C1. Colored $ Prompt
cat >> ~/.bashrc <<'EOF'

# Custom $ prompt with colors (user vs. root differ)
if [[ $EUID -ne 0 ]]; then
  PS1='\[\e[1;32m\]\u@\h \[\e[0;36m\]\w \[\e[0m\]\$ '
else
  PS1='\[\e[1;31m\]\u@\h \[\e[0;35m\]\w \[\e[0m\]\$ '
fi
EOF

C2. Aliases File
cat > ~/.bash_aliases <<'EOF'
alias ll='ls -lrt'
alias la='ls -a'
alias c='clear'

alias desk='cd "$HOME/Desktop"'
alias down='cd "$HOME/Downloads"'
alias docs='cd "$HOME/Documents"'
alias rootd='cd /'
EOF

# Ensure ~/.bashrc loads aliases
grep -q 'bash_aliases' ~/.bashrc || cat >> ~/.bashrc <<'EOF'

# Load personal aliases if present
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
EOF

C3. Apply & Verify
source ~/.bashrc
type ll la c desk down docs rootd

C4. Add ~/bin to PATH & Move Scripts
mkdir -p ~/bin
mv ~/scripts/create_user.sh ~/scripts/delete_user.sh ~/bin/

# Add ~/bin to PATH if not present
grep -q 'export PATH="$HOME/bin' ~/.bashrc || cat >> ~/.bashrc <<'EOF'

# Add ~/bin to PATH
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
EOF

source ~/.bashrc

C5. Demonstrate Running from Outside bin
cd /
create_user.sh alice
printf "y\n" | delete_user.sh alice

D) Package Management
D1. Install Vim (or print “already installed”)
cd ~/scripts
./install_vim.sh

D2. Update All Packages & Log Output
./update_all.sh
tail -n 20 update.log

E) Network Checks

Flowchart (narrate on camera):

Start -> [Which check?]
  - google.com ping -> check exit -> success: "Network is up." / fail
  - 8.8.8.8 ping -> check exit -> success/fail
  - nslookup example.com -> check exit -> success/fail
End

E2. Ping google.com
./check_google.sh
echo "Exit code: $?"   # Expect 0

E3. Ping 8.8.8.8 (Google DNS)
./check_dns_ip.sh
echo "Exit code: $?"

E4. DNS Lookup example.com
./check_nslookup.sh
echo "Exit code: $?"


If nslookup is missing:
Ubuntu/Debian → sudo apt-get install -y dnsutils
RHEL/Fedora → sudo dnf install -y bind-utils

F) Disk Space Assess & Cleanup

What you’ll show: Before/after free space (KB), directories cleaned, delta result.

./cleanup_space.sh


Optional to make the change visible:
dd if=/dev/zero of=~/.cache/bigfile bs=1M count=50 (creates ~50MB), then rerun cleanup.

G) Archive /etc & Compare Compression

What you’ll show: Two archives created, sizes in bytes, which is smaller.

./archive_etc.sh
ls -lh etc_*.tar.*


Expected output lines include:

gzip size : ... bytes (etc_YYYYMMDD_HHMMSS.tar.gz)

bzip2 size: ... bytes (etc_YYYYMMDD_HHMMSS.tar.bz2)

Comparison: which one is smaller and by how many bytes.

Troubleshooting & Notes

Exec bits: If a script won’t run: chmod +x <script>.sh

Permission denied on user mgmt/archiving: Ensure sudo is configured; these scripts already call sudo where needed.

PATH not updated: Re-source ~/.bashrc or open a new terminal.

Missing tools:

nslookup: install dnsutils (Debian/Ubuntu) or bind-utils (RHEL/Fedora)

Package manager differences are handled in the scripts.

Optional: “One-liner” Per Section (for quick retakes)
# A
cd ~/scripts && ./create_user.sh || true && ./create_user.sh devopsdemo && sudo su - devopsdemo -c 'whoami; id' && sudo chage -l devopsdemo | sed -n '1,6p'

# B
./delete_user.sh || true && printf "y\n" | ./delete_user.sh devopsdemo && sudo su - devopsdemo -c 'whoami' || echo deleted

# C (after editing .bashrc/.bash_aliases)
source ~/.bashrc && type ll && cd / && create_user.sh alice && printf "y\n" | delete_user.sh alice

# D
./install_vim.sh && ./update_all.sh && tail -n 10 update.log

# E
./check_google.sh; ./check_dns_ip.sh; ./check_nslookup.sh

# F
./cleanup_space.sh

# G
./archive_etc.sh && ls -lh etc_*.tar.*
