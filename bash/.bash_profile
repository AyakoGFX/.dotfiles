# export XDG_DATA_DIRS=$HOME/.nix-profile/share:"${XDG_DATA_DIRS:/usr/share/}"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:${XDG_DATA_DIRS:-/usr/share/}"


