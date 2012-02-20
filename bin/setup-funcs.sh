#!/bin/bash

PYTHON_CMD=python2.7

# download <url> - do nothing if already downloaded
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

# download_zip <url> <destination directory>
# download and unzip directory to destination
function download_zip {
    DEST_PATH="$2"

    download "$1"

    rm -rf "$DEST_PATH"
    mkdir "$DEST_PATH"
    unzip -q "$DOWN_DIR/$FILE" -d "$DEST_PATH"
}

function check_prog {
    type $1 > /dev/null 2>&1
}

case $PLATFORM in
Linux)
    PSEARCH='aptitude search'
    PINSTALL='sudo apt-get install'
    ;;
Mac)
    PSEARCH='port search'
    PINSTALL='sudo port install'
    ;;
*)
    PSEARCH='echo'
    PINSTALL='echo'
    ;;
esac

function ensure_prog {
    PROG=$1
    PROG_NAME=$2
    echo '==================================='
    if [ "$PROG_NAME" == "" ]; then
        PROG_NAME=$PROG
    fi
    if ! check_prog $PROG ; then
        $PSEARCH $PROG_NAME
        read -p "Do you want to install $PROG_NAME? (y/N): "
        if [ "$REPLY" == "y" ]; then
            $PINSTALL $PROG_NAME
        fi
    else
        echo $PROG_NAME is already installed.
    fi
    echo '==================================='
}

function check_py {
    if $(python -c "import $1" > /dev/null 2>&1) ; then
        VERSION=$(python -c "import $1;print $1.version" 2> /dev/null)
        echo $1 version $VERSION is installed.
        return 0
    fi
    return 1
}

function ensure_py {
    if ! check_py $1 ; then
        pip install $1
    fi
}

function get_pkgs() {
    for pkg in $* ; do
        echo '==================================='
        if [ $PLATFORM != "Linux" ]; then
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
