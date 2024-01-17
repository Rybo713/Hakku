#
# Hakku3 Tweaks Functions: A totally reworked command line utility which shows
#                           the user their system info and a bunch of useful
#                                          tools and tweaks.
#                              Built using Bash version 3.2.57(1)-release
#
# The MIT License (MIT)
#
# Copyright (c) 2024 Ryan Wong
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

risk(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  echo "                                Ryan Wong 2024"
  echo ""
  printf "${RED}${bold}                 --------------------------------------------\n"
  printf "${RED}${bold}                                 WARNING:\n"
  printf "${RED}${normal}                    I am not responsible for any damage that\n"
  printf "${RED}${normal}                      may be caused by using these tweaks\n"
  printf "${RED}${bold}                 --------------------------------------------\n"
  printf "${NC}${normal}\n"
  say "$vo"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("I Agree" "Exit")

  select_option "${options[@]}"
  t1=$?

    if [ $t1 = "0" ]; then
      tweaks
    elif [ $t1 = "1" ]; then
      menus
    fi
  done
}

tweaks(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${RED}${bold}              If you don't know what an option does, don't press it\n"
  printf "${NC}${normal}\n"
  echo ""
  echo ""
  echo ""

  echo ""
  options=("Chime When Charging" "Auto Restart on System Freeze" "Rebuild KextCache"
  "Show Hidden Files" "Clear DNS Cache" "Purge Memory Cache" "Enable / Disable Root User"
  "Erase Spotlight Index and Rebuild" "Back")

  select_option "${options[@]}"
  www=$?

  if [ $www = "8" ]; then
    menus
  elif [ $www = "0" ]; then
    chime
  elif [ $www = "1" ]; then
    rsf
  elif [ $www = "2" ]; then
    trim
  elif [ $www = "3" ]; then
    kextcache
  elif [ $www = "4" ]; then
    hiddenfiles
  elif [ $www = "5" ]; then
    dnscache
  elif [ $www = "6" ]; then
    memcache
  elif [ $www = "7" ]; then
    rootusr
  elif [ $www = "8" ]; then
    spotlight
  fi
  done
}

# Chime
chime(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                     Enable / Disable Chime when Charging"
  echo "                     ------------------------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Enable" "Disable" "Back")

  select_option "${options[@]}"
  www1=$?

  if [ $www1 = "0" ]; then
    chime1
  elif [ $www1 = "1" ]; then
    chime2
  elif [ $www1 = "2" ]; then
    tweaks
  fi
  done
}

chime1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                          Enabling Chime when Charging"
  echo "                          ----------------------------"
  echo ""
  defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && \
  open /System/Library/CoreServices/PowerChime.app
  echo ""
  echo ""
  echo ""
  echo "                        Chime when Charging is Enabled"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www1a=$?

  if [ $www1a = "0" ]; then
    chime
  fi
  done
}

chime2(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                          Disabling Chime when Charging"
  echo "                          -----------------------------"
  echo ""
  defaults write com.apple.PowerChime ChimeOnAllHardware -bool false && \
  killall PowerChime
  echo ""
  echo ""
  echo ""
  echo "                         Chime when Charging is Disabled"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www1b=$?

  if [ $www1b = "0" ]; then
    chime
  fi
  done
}

# RSF
rsf(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                        Auto Restart on System Freeze"
  echo "                        -----------------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Enable" "Disable" "Back")

  select_option "${options[@]}"
  www2=$?

  if [ $www2 = "0" ]; then
    rsf1
  elif [ $www2 = "1" ]; then
    rsf2
  elif [ $www2 = "2" ]; then
    tweaks
  fi
  done
}

rsf1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                        Enabling Auto Restart on System Freeze"
  echo "                        --------------------------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  sudo systemsetup -setrestartfreeze on
  echo "                        Enabled Auto Restart on System Freeze"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www2a=$?

  if [ $www2a = "0" ]; then
    rsf
  fi
  done
}

rsf2(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                        Disabling Auto Restart on System Freeze"
  echo "                        ---------------------------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  sudo systemsetup -setrestartfreeze off
  echo "                        Disabled Auto Restart on System Freeze"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www2b=$?

  if [ $www2b = "0" ]; then
    rsf
  fi
  done
}

# Trim
trim(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                    Force Enable Trim on non-Apple SSDs"
  echo "                    -----------------------------------"
  echo ""
  echo ""
  forcetrim
  echo "                               Enabled Trim"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www3=$?

  if [ $www3 = "0" ]; then
    tweaks
  fi
  done
}

# HiddenFiles
hiddenfiles(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                         Show / Hide Hidden Files"
  echo "                         ------------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Enable" "Disable" "Back")

  select_option "${options[@]}"
  www5=$?

  if [ $www5 = "0" ]; then
    hiddenfiles1
  elif [ $www5 = "1" ]; then
    hiddenfiles2
  elif [ $www5 = "2" ]; then
    tweaks
  fi
  done
}

hiddenfiles1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                             Show Hidden Files"
  echo "                             -----------------"
  echo ""
  echo ""
  defaults write com.apple.finder AppleShowAllFiles true
  echo "                        Finished showing Hidden Files"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www5a=$?

  if [ $www5a = "q" ]; then
    hiddenfiles
  fi
  done
}

hiddenfiles2(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                             Hide Hidden Files"
  echo "                             -----------------"
  echo ""
  echo ""
  defaults write com.apple.finder AppleShowAllFiles false
  echo "                        Finished hiding Hidden Files"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www5b=$?

  if [ $www5b = "0" ]; then
    hiddenfiles
  fi
  done
}

# DNSCache
dnscache(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                              Clearing DNS Cache"
  echo "                              ------------------"
  echo ""
  echo ""
  sudo dscacheutil -flushcache && \
  sudo killall -HUP mDNSResponder
  echo "                              Cleared DNS Cache"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www6=$?

  if [ $www6 = "0" ]; then
    tweaks
  fi
  done
}

# MemCache
memcache(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                             Purging Memory Cache"
  echo "                             --------------------"
  echo ""
  echo ""
  sudo purge
  echo "                             Memory Cache Purged"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www7=$?

  if [ $www7 = "0" ]; then
    tweaks
  fi
  done
}

# RootUser
rootusr(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                         Enable / Disable Root User"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Enable" "Disable" "Back")

  select_option "${options[@]}"
  www8=$?

  if [ $www8 = "0" ]; then
    rootusr1
  elif [ $www8 = "1" ]; then
    rootusr2
  elif [ $www8 = "2" ]; then
    tweaks
  fi
  done
}

rootusr1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                             Enabling Root User"
  echo "                             ------------------"
  echo ""
  echo ""
  dsenableroot
  echo "                             Enabled Root User"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www8a=$?

  if [ $www8a = "0" ]; then
    rootusr
  fi
  done
}

rootusr2(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                             Disabling Root User"
  echo "                             -------------------"
  echo ""
  echo ""
  dsenableroot -d
  echo "                             Disabled Root User"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www8b=$?

  if [ $www8b = "0" ]; then
    rootusr
  fi
  done
}

# Spotlight
spotlight(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                     Erasing and Rebuilding Spotlight"
  echo "                     --------------------------------"
  echo ""
  echo ""
  mdutil -E /dev/disk0s2
  echo "                  Finsihed Erasing and Rebuilding Spotlight"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  www9=$?

  if [ $www9 = "0" ]; then
    tweaks
  fi
  done
}

# KextCache
kextcache(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo "            ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "            ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "               ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "               ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "               ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "               ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                          Rebuilding Kext Cache"
  echo "                          ---------------------"
  echo ""
  echo ""
  sudo kextcache -i /
  echo "                      Finished Rebuilding Kext Cache"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  options=("Back")

  select_option "${options[@]}"
  www10=$?

  if [ $www10 = "0" ]; then
    tweaks
  fi
  done
}
