alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if ! type ack > /dev/null 2>&1; then
   alias ack='ack-grep'
fi
