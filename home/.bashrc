PATH="$HOME/src/my-machine/bin:$HOME/bin:$PATH"

if [ -d "/usr/local/git/bin" ]; then
    PATH="$PATH:/usr/local/git/bin"
fi

# If not running interactively, stop here
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [[ $(uname) == "*W32*" && -f ~/.gitbashrc ]]; then
    . ~/.gitbashrc
fi

if [[ $(uname) == "Darwin" ]]; then
  PATH=/opt/local/bin:/opt/local/sbin:$PATH
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# export PS1="\[\e]2;\u@\h \w\a\]\W $ "
export PS1="\[\e]2;\u@\h \w\a\e[0;31m\]\W $\[\e[m\] "

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/src/camlistore/bin

export GOPATH=$HOME/godev
PATH=$PATH:$GOPATH/bin

PATH=$PATH:/Applications/dart/dart-sdk/bin
