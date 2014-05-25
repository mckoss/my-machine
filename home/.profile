export GOPATH=$HOME/go
export DOCKER_HOST=tcp://127.0.0.1:4243

PATH="$HOME/src/my-machine/bin:$HOME/bin:$PATH"
if [ -d "/usr/local/git/bin" ]; then
    PATH="$PATH:/usr/local/git/bin"
fi
PATH="$GOPATH/bin:$PATH"
PATH="/Applications/dart/dart-sdk/bin:$PATH"

if [ $SHELL == "/bin/bash" ]; then
    source $HOME/.bashrc
fi
