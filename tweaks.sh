#!/bin/bash
#
# Hakku Extension: Tweaks is a command line utility that lets users tweak
#                           the macOS system with the tweaks provided
#                           Built using Bash version 3.2.57(1)-release
#
# The MIT License (MIT)
#
# Copyright (c) 2021 Ryan Wong
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

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
LYELLOW='\033[1;33m'
bold=$(tput bold)
normal=$(tput sgr0)

/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

printf "$color"
echo ""
echo "         ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
echo "         ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
echo "            ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
echo "            ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
echo "            ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
echo "            ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
echo "                                            $version"
echo ""
echo "                            Ryan Wong 2019"
echo ""
printf "${RED}${bold}             --------------------------------------------\n"
printf "${RED}${bold}                              WARNING:\n"
printf "${RED}${normal}               I am not responsible for any damage that\n"
printf "${RED}${normal}                 may be caused by using these tweaks\n"
printf "${RED}${bold}             --------------------------------------------\n"
printf "${NC}${normal}                        1) I agree    2) Exit\n"
say "$vo"

read -p "> " ioo

/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

if [ $ioo = 1 ]; then
  while true; do

  printf "$color"
  echo ""
  echo "         ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗";
  echo "         ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝";
  echo "            ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗";
  echo "            ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║";
  echo "            ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║";
  echo "            ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝";
  echo "                                            $version"
  echo ""
  echo "                            Ryan Wong 2019"
  echo ""
  printf "${CYAN}${bold}                              T W E A K S"
  echo ""
  printf "${NC}${normal}"
  echo "1) Chime When Charging"
  echo "2) Auto Restart on System Freeze"
  echo "3) Force Enable Trim (On non-Apple SSDs)"
  echo "4) Scrollbar Visibility"
  echo "5) Show Hidden Files"
  echo "6) Clear DNS Cache"
  echo "7) Purge Memory Cache"
  echo "8) Enable / Disable Root User"
  echo "9) Erase Spotlight Index and Rebuild"
  echo "q) Exit Tweaks"
  echo ""
  read -p "> " ioo2

  if [ $ioo2 = 1 ]; then
    echo ""
    printf "${bold}Chime when Charging\n${normal}"
    echo "1) Enable"
    echo "2) Disable (Default)"
    echo "b) Back to Tweaks"
    read -p "> " ioo3

      if [ $ioo3 = 1 ]; then
        defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && \
        open /System/Library/CoreServices/PowerChime.app
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Chime when Charging is Enabled\n"
      elif [ $ioo3 = 2 ]; then
        defaults write com.apple.PowerChime ChimeOnAllHardware -bool false && \
        killall PowerChime
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Chime when Charging is Disabled\n"
      elif [ $ioo3 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 2 ]; then
    echo ""
    printf "${bold}Auto Restart on System Freeze\n${normal}"
    echo "1) Enable"
    echo "2) Disable (Default)"
    echo "b) Back to Tweaks"
    read -p "> " ioo4

      if [ $ioo4 = 1 ]; then
        sudo systemsetup -setrestartfreeze on
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Auto Restart on System Freeze is Enabled\n"
      elif [ $ioo4 = 2 ]; then
        sudo systemsetup -setrestartfreeze off
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Auto restart on System Freeze is Disabled\n"
      elif [ $ioo4 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 3 ]; then
    echo ""
    printf "${bold}Force Enable Trim on non-Apple SSDs\n${normal}"
    echo "1) Force Enable"
    echo "2) Back to Tweaks"
    read -p "> " ioo5

    if [ $ioo5 = 1 ]; then
      forcetrim
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      printf "${GREEN}${bold}[INFO] ${NC}${normal}Force Enable Trim is Enabled\n"
    elif [ $ioo5 = 2 ]; then
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    fi
  fi

  if [ $ioo2 = 4 ]; then
    echo ""
    printf "${bold}Scrollbar Visibility\n${normal}"
    echo "1) Always"
    echo "2) When Scrolling"
    echo "3) Automatic (Default)"
    echo "b) Back to Tweaks"
    read -p "> " ioo6

      if [ $ioo6 = 1 ]; then
        defaults write -g AppleShowScrollBars -string "Always"
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Scrollbar Visibility is set to Always\n"
      elif [ $ioo6 = 2 ]; then
        defaults write -g AppleShowScrollBars -string "WhenScrolling"
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Scrollbar Visibility is set to When Scrolling\n"
      elif [ $ioo6 = 3 ]; then
        defaults write -g AppleShowScrollBars -string "Automatic"
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Scrollbar Visibility is set to Automatic\n"
      elif [ $ioo6 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 5 ]; then
    echo ""
    printf "${bold}Show Hidden Files\n${normal}"
    echo "1) Enable"
    echo "2) Disable (Default)"
    echo "b) Back to Tweaks"
    read -p "> " ioo7

      if [ $ioo7 = 1 ]; then
        defaults write com.apple.finder AppleShowAllFiles true
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Show Hidden Files is Enabled\n"
      elif [ $ioo7 = 2 ]; then
        defaults write com.apple.finder AppleShowAllFiles false
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Show Hidden Files is Disabled\n"
      elif [ $ioo7 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 6 ]; then
    echo ""
    printf "${bold}Clear DNS Cache\n${normal}"
    echo "1) Clear"
    echo "b) Back to Tweaks"
    read -p "> " ioo8

      if [ $ioo8 = 1 ]; then
        sudo dscacheutil -flushcache && \
        sudo killall -HUP mDNSResponder
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Cleared DNS Cache\n"
      elif [ $ioo8 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 7 ]; then
    echo ""
    printf "${bold}Purge Memory Cache\n${normal}"
    echo "1) Purge"
    echo "b) Back to Tweaks"
    read -p "> " ioo9

      if [ $ioo9 = 1 ]; then
        sudo purge
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Purged Memory Cache\n"
      elif [ $ioo9 = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 8 ]; then
    echo ""
    printf "${bold}Enable / Disable Root User\n${normal}"
    echo "1) Enable"
    echo "2) Disable (Default)"
    echo "b) Back to Tweaks"
    read -p "> " iooa

      if [ $iooa = 1 ]; then
        dsenableroot
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Root User is Enabled\n"
      elif [ $iooa = 2 ]; then
        dsenableroot -d
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Root User is Disabled\n"
      elif [ $iooa = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = 9 ]; then
    echo ""
    printf "${bold}Erase Spotlight Index and Rebuild\n${normal}"
    echo "1) Erase and Rebuild"
    echo "b) Back to Tweaks"
    read -p "> " ioob

      if [ $ioob = 1 ]; then
        mdutil -E /dev/disk0s2
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
        printf "${GREEN}${bold}[INFO] ${NC}${normal}Erasing and Rebuilding Spotlight Index\n"
      elif [ $ioob = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi
  fi

  if [ $ioo2 = "q" ]; then
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    false
    . ./Hakku.sh
    exit 0
  fi

done
fi

if [ $ioo = 2 ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  . ./Hakku.sh
  exit 0
fi
