HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PS1="\[\e]2;\u@\h \w\a\e[0;31m\]\W $\[\e[m\] "
PATH="$HOME/bin:$HOME/src/my-machine/bin:$PATH"

export DOCKER_HOST=tcp://127.0.0.1:4243

PATH="/usr/local/bin:$PATH"

PATH="$HOME/src/my-machine/bin:$HOME/bin:$PATH"

export GOPATH=$HOME/go
PATH="$GOPATH/bin:$PATH"

PATH="/Applications/dart/dart-sdk/bin:$PATH"
if [ -d ~/.rbenv ]; then
    PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi
