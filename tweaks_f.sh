#!/bin/bash
#
# Hakku2 TWeaks Functions: A totally reworked command line utility which shows
#                           the user their system info and a bunch of useful
#                                          tools and tweaks.
#                              Built using Bash version 3.2.57(1)-release
#
# The MIT License (MIT)
#
# Copyright (c) 2019 Ryan Wong
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
  echo "                                Ryan Wong 2019"
  echo ""
  printf "${RED}${bold}                 --------------------------------------------\n"
  printf "${RED}${bold}                                 WARNING:\n"
  printf "${RED}${normal}                I am not responsible for any damage that\n"
  printf "${RED}${normal}                   may be caused by using these tweaks\n"
  printf "${RED}${bold}                 --------------------------------------------\n"
  printf "${NC}${normal}                           1) I agree    2) Exit\n"
  say "$vo"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  read -p "> " w
    if [ $w = 1 ]; then
      tweaks
    elif [ $w = 2 ]; then
      mainmenu
    fi
}

tweaks(){
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
  echo "                          1) Chime When Charging"
  echo "                     2) Auto Restart on System Freeze"
  echo "                  3) Force Enable Trim (On non-Apple SSDs)"
  echo "                           4) Rebuild KextCache"
  echo "                           5) Show Hidden Files"
  echo "                            6) Clear DNS Cache"
  echo "                          7) Purge Memory Cache"
  echo "                       8) Enable / Disable Root User"
  echo "                   9) Erase Spotlight Index and Rebuild"
  echo ""
  printf "${RED}${bold}           If you don't know what an option does, don't press it\n"
  echo ""
  printf "${NC}${normal}press q to go back\n"
  echo ""
  read -p "> " www
  if [ $www = "q" ]; then
    mainmenu
  elif [ $www = 1 ]; then
    chime
  elif [ $www = 2 ]; then
    rsf
  elif [ $www = 3 ]; then
    trim
  elif [ $www = 4 ]; then
    kextcache
  elif [ $www = 5 ]; then
    hiddenfiles
  elif [ $www = 6 ]; then
    dnscache
  elif [ $www = 7 ]; then
    memcache
  elif [ $www = 8 ]; then
    rootusr
  elif [ $www = 9 ]; then
    spotlight
  fi

}

# Chime
chime(){
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
  echo "                                 1. Enable"
  echo "                                 2. Disable"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www1
  if [ $www1 = 1 ]; then
    chime1
  elif [ $www1 = 2 ]; then
    chime2
  elif [ $www1 = "q" ]; then
    tweaks
  fi
}

chime1(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www1a
  if [ $www1a = "q" ]; then
    chime
  fi
}

chime2(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www1b
  if [ $www1b = "q" ]; then
    chime
  fi
}

# RSF
rsf(){
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
  echo "                                1. Enable"
  echo "                                2. Disable"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www2
  if [ $www2 = 1 ]; then
    rsf1
  elif [ $www2 = 2 ]; then
    rsf2
  elif [ $www2 = "q" ]; then
    tweaks
  fi
}

rsf1(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www2a
  if [ $www2a = "q" ]; then
    rsf
  fi
}

rsf2(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www2b
  if [ $www2b = "q" ]; then
    rsf
  fi
}

# Trim
trim(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www3
  if [ $www3 = "q" ]; then
    tweaks
  fi
}

# HiddenFiles
hiddenfiles(){
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
  echo "                              1. Enable"
  echo "                              2. Disable"
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www5
  if [ $www5 = 1 ]; then
    hiddenfiles1
  elif [ $www5 = 2 ]; then
    hiddenfiles2
  elif [ $www5 = "q" ]; then
    tweaks
  fi
}

hiddenfiles1(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www5a
  if [ $www5a = "q" ]; then
    hiddenfiles
  fi
}

hiddenfiles2(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www5b
  if [ $www5b = "q" ]; then
    hiddenfiles
  fi
}

# DNSCache
dnscache(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www6
  if [ $www6 = "q" ]; then
    tweaks
  fi
}

# MemCache
memcache(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www7
  if [ $www7 = "q" ]; then
    tweaks
  fi
}

# RootUser
rootusr(){
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
  echo "                                1. Enable"
  echo "                                2. Disable"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www8
  if [ $www8 = 1 ]; then
    rootusr1
  elif [ $www8 = 2 ]; then
    rootusr2
  elif [ $www8 = "q" ]; then
    tweaks
  fi
}

rootusr1(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www8a
  if [ $www8a = "q" ]; then
    rootusr
  fi
}

rootusr2(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www8b
  if [ $www8b = "q" ]; then
    rootusr
  fi
}

# Spotlight
spotlight(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www9
  if [ $www9 = "q" ]; then
    tweaks
  fi
}

# KextCache
kextcache(){
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
  echo "press q to go back"
  echo ""
  read -p "> " www10
  if [ $www10 = "q" ]; then
    tweaks
  fi
}
