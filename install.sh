#!/bin/bash
reset

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "\(${_display_id}\)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

function apt-update() {
     apt-get -y install -f
     dpkg --configure -a
     apt-get -y install -f
     apt-get -y clean
     apt-get -y autoclean
     apt-get -y update
}

# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-ulyssa.xml'"

#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"

# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"

# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adwaita-dark'"

#Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"

#Update All User Settings
run-in-user-session dconf update

apt-add-repository -y ppa:fengestad/stable
apt-get -y update
apt-get -y install fs-uae
apt-get -y install fs-uae-launcher
apt-get -y install fs-uae-arcade
apt-get -y install gedit

mkdir -p -v /home/$(users)/Documents/FS-UAE/Configurations
cp -v -f Configurations/*.fs-uae /home/$(users)/Documents/FS-UAE/Configurations/

mkdir -p -v /home/$(users)/Documents/FS-UAE/Hard\ Drives/Work
cp -v -f hdf/* /home/$(users)/Documents/FS-UAE/Hard\ Drives/Work

mkdir -p -v /home/$(users)/Documents/FS-UAE/Kickstarts
cp -v -f rom/* /home/$(users)/Documents/FS-UAE/Kickstarts/

mkdir -p -v /home/$(users)/Documents/FS-UAE/Floppies
cp -v -f adf/*.adf /home/$(users)/Documents/FS-UAE/Floppies/

mkdir -p -v /home/$(users)/.config/autostart
cp -v -f files/*.desktop /home/$(users)/.config/autostart/

chmod 0777 -R /home/$(users)

sleep 5
shutdown -r now
