DOWN_DIR=$HOME/Downloads
 
function check_prog {
    type $1 > /dev/null 2>&1
}

function get() {
    for pkg in $* ; do
        echo '==================================='
        if ! $(dpkg -s $pkg > /dev/null 2>&1) ; then
            echo Installing $pkg
            sudo apt-get install $pkg
        else
            echo $pkg already installed.
        fi
        echo '==================================='
    done
}

function download {
    FILE_PATH="$1"
    FILE="$( basename "$FILE_PATH" )"

    mkdir -p "$DOWN_DIR"
    if [ ! -f "$DOWN_DIR/$FILE" ]; then
        echo "Downloading $1"
        if ! curl "$FILE_PATH" --output "$DOWN_DIR/$FILE"; then
            echo "Failed to download $FILE_PATH"
            exit 1
        fi
    fi
}

read -p "Desired hostname? ($(hostname)): "
if [ "$REPLY" != "" ]; then
    sudo hostname $REPLY
    sudo echo $(hostname) > /etc/hostname
fi

# Read prompt will not send stderr back to ssh remove command line - so don't use read -p."
read -p "Update package database? (y/N): "
if [ "$REPLY" == "y" ]; then
    sudo apt-get update
fi

get aptitude curl emacs-nox git

if ! git config --global user.name; then
    git config --global user.name "Mike Koss"
    git config --global user.email mckoss@startpad.org
fi

if [ ! -d "$HOME/src/my-machine" ]; then
    mkdir -p $HOME/src
    git clone git@github.com:mckoss/my-machine.git $HOME/src/my-machine
fi
