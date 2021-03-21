#!/bin/bash
#
# Hakku Settings: Settings configuration for HackTool
#                    Built using Bash version 3.2.57(1)-release
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

while true; do

/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

printf "$color"
echo ""
echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
echo "                                           $version"
echo ""
echo "                            Ryan Wong 2019"
echo ""
echo ""
printf "${NC}${bold}Settings${normal}"
echo ""
echo ""
echo "1) VoiceOver"
echo "2) Change Colour of Logo"
echo "b) Back"
echo ""
read -p "> " ii

if [ $ii = 1 ]; then
  echo ""
  echo "1) Enable VoiceOver"
  echo "2) Disable VoiceOver (Default)"
  echo "b) Back"
  echo ""
  read -p "> " iii

    if [ $iii = 1 ]; then
      vo="Warning! I am not responsible for any damage that may be caused by using these tweaks."
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      printf "${GREEN}${bold}[INFO] ${NC}${normal}Enabled VoiceOver\n"
    elif [ $iii = 2 ]; then
      vo=""
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      printf "${GREEN}${bold}[INFO] ${NC}${normal}Disabled VoiceOver\n"
    elif [ $iii = "b" ]; then
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    fi
elif [ $ii = "2" ]; then
  export color=1
  echo ""
  echo "What colour do you want to change the logo to?"
  echo ""
  echo "1) Original"
  echo "2) Red"
  echo "3) Green"
  echo "4) Blue"
  echo "5) White (Default)"
  echo "b) Back"
  echo ""
  read -p "> " colorop

    if [ $colorop = 1 ]; then
      color="${YELLOW}${bold}"
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    elif [ $colorop = 2 ]; then
      color="${RED}${bold}"
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    elif [ $colorop = 3 ]; then
      color="${GREEN}${bold}"
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    elif [ $colorop = 4 ]; then
      color="${BLUE}${bold}"
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    elif [ $colorop = 5 ]; then
      color="${NC}${bold}"
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    elif [ $colorop = "b" ]; then
      /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
    fi

elif [ $ii = "b" ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  false
  . ./Hakku.sh
  exit 0
fi

done
