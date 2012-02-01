DOWN_DIR = $HOME/Downloads

read -p "Update package database? (y/N): "
if [ $REPLY == "y" ]; then
    sudo apt-get update
fi

function get() {
    pkg=$1

    echo '==================================='
    if ! $(dpkg -s $pkg > /dev/null 2>&1) ; then
	echo Installing $pkg
	sudo apt-get install $pkg
    else
	echo $pkg already installed.
    fi
    echo '==================================='
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

get aptitude
get curl
get emacs23-nox
get git
get google-chrome-stable
