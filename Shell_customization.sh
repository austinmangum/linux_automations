# -------- append to ~/.bashrc ----
# ----- Custom prompt: dollar sign with colors -----
# Non-root: green user@host:cwd $
if [[ $EUID -ne 0 ]]; then
  PS1='\[\e[1;32m\]\u@\h \[\e[0;36m\]\w \[\e[0m\]\$ '
else
  # Root: red user@host:cwd $
  PS1='\[\e[1;31m\]\u@\h \[\e[0;35m\]\w \[\e[0m\]\$ '
fi

# ----- create new file called ~/.bash_aliases -----

# ~/.bash_aliases

# Shortcuts
alias ll='ls -lrt'      # ls lrt
alias la='ls -a'        # ls -a
alias c='clear'         # clear

# Quick nav: (ASSUMPTION: standard XDG dirs under $HOME; adjust as needed)
alias desk='cd "$HOME/Desktop"'
alias down='cd "$HOME/Downloads"'
alias docs='cd "$HOME/Documents"'
alias rootd='cd /'      # any directory in root filesystem quickly
