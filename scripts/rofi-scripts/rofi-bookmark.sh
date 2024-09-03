#!/usr/bin/env bash
#
# Script name: dm-bookman
# Description: Search your qutebrowswer bookmarks and quickmarks.
# Dependencies: dmenu, fzf, rofi, qutebrowser
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor
#               Simon Ingelsson

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

# shellcheck disable=SC1091
source ./_dm-helper.sh 2>/dev/null || source _dm-helper.sh 2>/dev/null

source_dmscripts_configs

if configs_are_different; then
    echo "$(date): configs are different" >>"$DM_CONFIG_DIFF_LOGFILE"
    sleep 1
fi

_cache_dir="${HOME}/.cache/dm-bookman"
_cache_file="${_cache_dir}/cache"
mkdir -p "${_cache_dir}"
# A separator that will appear in between quickmarks, bookmarks and history URLs.
_bookman_separator="----------"
# Defining location of bookmarks file
_bookmark_file="$HOME/.config/qutebrowser/bookmarks/urls"
# Defining location of quickmarks file
_quickmarks_file="$HOME/.config/qutebrowser/quickmarks"

# Do query against sqlite3 database expecting three columns (browsername, title, url)
# ARGS: "browsername" "file" "query"
function cache_history() {
    local _file=${1}
    local _query=${2}
    # shellcheck disable=SC2154
    [[ ${bookman_show_source} -eq 1 ]] && browser=${3-} || browser=""
    [[ -f "${_file}" ]] || return
    sqlite3 -separator ' | ' "${_file}" "${_query}" >"${_cache_dir}/${browser}.data"
}

# Wrap getting history so we can call it only if the cache is old
generate_history() {
    if [[ -f "${_cache_file}" ]]; then
        if [ $(($(date +%s) - $(date +%s -r "${_cache_file}"))) -lt 180 ]; then
            return 0
        fi
    fi
    # Make sure cache is empty and exists
    echo -n "" >"${_cache_file}"
    echo -n "" >"${_cache_file}.sorted"

    _chromium_history="${HOME}/.config/chromium/Default/History"
    if [[ -f ${_chromium_history} ]]; then
        SQL="SELECT 'Chromium', title, url FROM urls where url like 'http%';"
        cache_history "${_chromium_history}" "${SQL}" "chromium"
    fi

    _brave_history="${HOME}/.config/BraveSoftware/Brave-Browser/Default/History"
    if [[ -f ${_brave_history} ]]; then
        SQL="SELECT 'Brave', title, url FROM urls where url like 'http%';"
        cache_history "${_brave_history}" "${SQL}" "brave"
    fi

    _qutebrowser_history="${HOME}/.local/share/qutebrowser/history.sqlite"
    if [[ -f ${_qutebrowser_history} ]]; then
        SQL="SELECT 'Qutebrowser', title, url FROM history where url like 'http%';"
        cache_history "${_qutebrowser_history}" "${SQL}" "qutebrowser"
    fi

    if [[ -d "${HOME}/.mozilla/firefox" ]]; then
        SQL="PRAGMA encoding='UTF-8'; select 'Firefox', p.title,p.url from moz_historyvisits as h, moz_places as p where p.id == h.place_id order by url"
        cd "${HOME}/.mozilla/firefox"
        for db in */places.sqlite; do
            DB=$(realpath "${db}")
            cache_history "${DB}" "${SQL}" "firefox"
        done
    fi

    # Merge .data-files
    find "${_cache_dir}" -iname "*.data" -print0 | xargs -0 cat >"${_cache_file}"

    # reverse each line and then sorting on url making sure they are unique then restoring the lines
    rev "${_cache_file}" | sort -u -t' ' -r -k1,1 | rev | sort >"${_cache_file}.sorted"
}

main() {
    local list=""
    # History list is formed by using grep "http" from the history table.
    generate_history
    histlist=$(cat "${_cache_file}.sorted")

    if [[ -f ${_quickmarks_file} ]]; then
        local qmlist=''
        qmlist=$(awk '{print "["$1"] - "$NF}' "${_quickmarks_file}" | sort)
        [[ -n "${qmlist}" ]] && list="$(printf '%s\n' "${list}" "${qmlist}" "${_bookman_separator}")"
    fi

    if [[ -f ${_bookmark_file} ]]; then
        local bmlist=''
        bmlist=$(awk '{print $2" - "$1}' "${_bookmark_file}")
        [[ -n "${bmlist}" ]] && list="$(printf '%s\n' "${list}" "${bmlist}" "${_bookman_separator}")"
    fi

    # Piping the lists into dmenu.
    # We use "printf '%s\n'" to format the array one item to a line.
    # The URLs are listed quickmarks, bookmarks and lastly history
    local choice=
    choice=$(printf '%s\n' "${list}" "${histlist}" | sed '/^[[:space:]]*$/d' | rofi -dmenu -p "${DMBROWSER} open:")

    # What to do if the separator is chosen from the list.
    # We simply launch qutebrowser without any URL arguments.
    if [ -n "$choice" ]; then
        [[ "$choice" == "$_bookman_separator" ]] && exit 1
        # What to do when/if we choose a URL to view.
        # url=$(echo "${choice}" | awk '{print $NF}') || exit 1
        nohup "${DMBROWSER}" "${choice##* }" >/dev/null 2>&1 &
    else
        # What to do if we just escape without choosing anything.
        echo "Program terminated." && exit 1
    fi
}

MENU="$(get_menu_program "$@")"
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
