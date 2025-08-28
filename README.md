## System Admin Scripting – Run Book (A–G)

### Environment
- **Typical Linux** (bash, sudo available)
- **Scripts Folder:** `~/scripts` (unless noted)
- **Exec Bits:** Ensure each script is executable

**Windows users:**
```bash
wsl --unregister Ubuntu # clear out current image
wsl --install -d Ubuntu # install fresh image
```

---

### Quick Setup (once)
```bash
mkdir -p ~/scripts && cd ~/scripts
# Place all scripts here, then:
chmod +x create_user.sh demo_create_user.sh delete_user.sh demo_delete_user.sh \
           install_vim.sh update_all.sh \
           check_google.sh check_dns_ip.sh check_nslookup.sh \
           cleanup_space.sh archive_etc.sh
```

---

### Contents & Mapping

| Section | Requirement Summary | Script(s) |
|---------|---------------------|-----------|
| A | Create user, set password, force change, show `/etc/passwd`; demo no-args/with-args/switch | `create_user.sh`|
| B | Delete user (confirm, remove home), show `/etc/passwd`; demo no-args/with-args/failed su | `delete_user.sh` |
| C | Customize prompt $, aliases, PATH add `~/bin`, run scripts from outside bin | (shell commands below) |
| D | Install vim if missing; update all packages to `update.log` | `install_vim.sh`, `update_all.sh` |
| E | Network checks: ping google.com, ping 8.8.8.8, nslookup example.com; flowchart | `check_google.sh`, `check_dns_ip.sh`, `check_nslookup.sh` |
| F | Disk cleanup: measure before/after; clean directories; report | `cleanup_space.sh` |
| G | Archive `/etc` with gzip & bzip2; compare sizes | `archive_etc.sh` |

---

  ## Section Details

  ### A) Create a New User

  **Demo Steps:**
  1. Run without args (expect error):  
    `./create_user.sh`
  2. Run with valid username:  
    `./create_user.sh devopsdemo`
  3. Verify entry in `/etc/passwd` (script prints automatically)
  4. Switch to new user & show password policy:  
    ```
    sudo su - devopsdemo -c 'echo "User: $(whoami)"; id'
    sudo chage -l devopsdemo | sed -n '1,6p'
    ```
  5. (Optional) Change password interactively:  
    `su - devopsdemo`
  6. One-button demo:  
    `./demo_create_user.sh`

  ---

  ### B) Delete the User

  **Demo Steps:**
  1. Run without args (expect error):  
    `./delete_user.sh`
  2. Run with valid username (auto-confirm "y"):  
    `printf "y\n" | ./delete_user.sh devopsdemo`
  3. Attempt to switch to deleted user (should fail):  
    `sudo su - devopsdemo -c 'whoami' || echo "Confirmed: devopsdemo is deleted"`
  4. One-button demo:  
    `./demo_delete_user.sh`

  ---

  ### C) Shell Initialization Customization

  **Goals:**
  - Custom colored `$` prompt
  - Aliases in `~/.bash_aliases`
  - Add `~/bin` to `PATH`, move scripts there

  **Commands:**
  - Add colored prompt to `.bashrc`
  - Create aliases in `.bash_aliases`
  - Ensure `.bashrc` loads aliases
  - Add `~/bin` to `PATH` if not present
  - Move scripts to `~/bin`
  - Demonstrate running scripts from outside bin

  ---

  ### D) Package Management

  1. Install Vim (or print “already installed”):  
    `./install_vim.sh`
  2. Update all packages & log output:  
    ```
    ./update_all.sh
    tail -n 20 update.log
    ```

  ---

  ### E) Network Checks

  **Flowchart:**  
  - Ping `google.com` → success/fail  
  - Ping `8.8.8.8` → success/fail  
  - `nslookup example.com` → success/fail

  **Commands:**
  - `./check_google.sh`
  - `./check_dns_ip.sh`
  - `./check_nslookup.sh`

  **If nslookup is missing:**  
  - Ubuntu/Debian: `sudo apt-get install -y dnsutils`  
  - RHEL/Fedora: `sudo dnf install -y bind-utils`

  ---

  ### F) Disk Space Assess & Cleanup

  - Show before/after free space, directories cleaned, delta result:  
    `./cleanup_space.sh`
  - (Optional) Create a large file to test cleanup:  
    `dd if=/dev/zero of=~/.cache/bigfile bs=1M count=50`

  ---

  ### G) Archive `/etc` & Compare Compression

  - Create two archives, compare sizes:  
    ```
    ./archive_etc.sh
    ls -lh etc_*.tar.*
    ```

  **Expected Output:**  
  - gzip size: ... bytes  
  - bzip2 size: ... bytes  
  - Comparison: which is smaller and by how many bytes

  ---

  ## Troubleshooting & Notes

  - **Exec bits:**  
    If a script won’t run: `chmod +x <script>.sh`
  - **Permission denied:**  
    Ensure sudo is configured; scripts call sudo where needed
  - **PATH not updated:**  
    Re-source `.bashrc` or open a new terminal
  - **Missing tools:**  
    - nslookup: install `dnsutils` (Debian/Ubuntu) or `bind-utils` (RHEL/Fedora)
  - **Package manager differences:**  
    Handled in the scripts

  ---

  ## Quick One-Liners (for retakes)

  ```bash
  # A
  cd ~/scripts && ./create_user.sh || true && ./create_user.sh devopsdemo && sudo su - devopsdemo -c 'whoami; id' && sudo chage -l devopsdemo | sed -n '1,6p'

  # B
  ./delete_user.sh || true && printf "y\n" | ./delete_user.sh devopsdemo && sudo su - devopsdemo -c 'whoami' || echo deleted

  # C
  source ~/.bashrc && type ll && cd / && create_user.sh alice && printf "y\n" | delete_user.sh alice

  # D
  ./install_vim.sh && ./update_all.sh && tail -n 10 update.log

  # E
  ./check_google.sh; ./check_dns_ip.sh; ./check_nslookup.sh

  # F
  ./cleanup_space.sh

  # G
  ./archive_etc.sh && ls -lh etc_*.tar.*
  ```
