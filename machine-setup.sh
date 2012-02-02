DOWN_DIR=$HOME/Downloads
ROOT_DIR="$(cd `dirname $0` && pwd)"

if [ `uname` == "Darwin" ]; then
    platform="Mac"
elif [[ `uname` == *W32* ]]; then
    platform="Windows"
else
    platform="Linux"
fi

echo "I think your machine is running $platform ..."

function check_prog {
    type $1 > /dev/null 2>&1
}

function get() {
    for pkg in $* ; do
        echo '==================================='
        if [ $platform != "Linux" ]; then
            if ! check_prog $pkg; then
                echo "You should install $pkg."
            fi
            continue
        fi

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

if [ $platform == "Linux" ]; then
    read -p "Update package database? (y/N): "
    if [ $REPLY == "y" ]; then
        sudo apt-get update
    fi
fi

get aptitude curl fping emacs23-nox
get google-chrome-stable

get git

if [ "$(git config --global user.name)" == "" ]; then
    read -p "Git Fullname: "
    git config --global user.name "$REPLY"
    read -p "Git Email: "
    git config --global user.email "$REPLY"
fi

get s3cmd

if [ ! -f "$HOME/.s3cfg" ]; then
    s3cmd --configure
fi

for config in $ROOT_DIR/home/.* ; do
    [ -d $config ] && continue
    base=$(basename $config)
    if [ -e $HOME/$base ]; then
        echo Skipping $base config file - file exists.
    else
        echo Adding $base config file.
        ln -s $config $HOME/$base
    fi
done
