# export XDG_DATA_DIRS=$HOME/.nix-profile/share:"${XDG_DATA_DIRS:-/usr/share/}"
# export XDG_DATA_DIRS=$HOME/.nix-profile/share:"${XDG_DATA_DIRS:/usr/share/}"
# export XDG_DATA_DIRS="/home/$USER/.nix-profile/share:$XDG_DATA_DIRS"
if [ -n ${XDG_SESSION_ID} ];then
    xdgpath=$(echo $XDG_DATA_DIRS|sed -e 's#/usr/local/share:##' -e 's#/usr/share:##')
    XDG_DATA_DIRS=/usr/local/share:/usr/share
    if [ -d ~/.nix-profile ];then
        for x in $(find ~/.nix-profile/share/applications/*.desktop);do
            XDG_DATA_DIRS=$(dirname $(dirname $(readlink -f $x))):${XDG_DATA_DIRS}
        done
    fi
    XDG_DATA_DIRS=${HOME}/.local/share:${xdgpath}:${XDG_DATA_DIRS}
    export XDG_DATA_DIRS
fi
