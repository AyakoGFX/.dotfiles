gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

# Super + Right Mouse Click for resizing windows
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button "true"

# Full-screen with title/navigation bar
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

# Use 9 fixed workspaces instead of dynamic mode
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 9

# Use alt for pinned apps
# gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt><Shift>F1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt><Shift>F2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt><Shift>F3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt><Shift>F4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt><Shift>F5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt><Shift>F6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt><Shift>F7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt><Shift>F8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt><Shift>F9']"

# Use super for workspaces super + 1-9
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
# move to workspace super + shift + 1-9
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
