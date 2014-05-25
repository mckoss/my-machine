export GOPATH=$HOME/go

PATH="$HOME/src/my-machine/bin:$HOME/bin:$PATH"
if [ -d "/usr/local/git/bin" ]; then
    PATH="$PATH:/usr/local/git/bin"
fi
PATH="$GOPATH/bin:$PATH"
PATH="/Applications/dart/dart-sdk/bin:$PATH"

if [ $SHELL == "/bin/bash" ]; then
    source $HOME/.bashrc
fi
