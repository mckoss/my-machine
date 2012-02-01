read -p "Update package database? (y/N): "
if [ $REPLY == "y" ]; then
    sudo apt-get update
fi

function get() {
    pkg=$1

    echo '==================================='
    echo Installing $pkg
    echo '==================================='
    sudo apt-get install $pkg
}

get emacs23-nox
get aptitude
get git
