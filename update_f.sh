#!/bin/bash
#
# Hakku2 Update Functions: A totally reworked command line utility which shows
#                            the user their system info and a bunch of useful
#                                           tools and tweaks.
#                               Built using Bash version 3.2.57(1)-release
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

update(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  printf "${NC}${normal}"
  echo ""
  printf "                                   Updates$noti\n"
  echo "                                   -------"
  echo ""
  echo ""
  echo "                           $updating"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "$dl"
  echo "press c to check for updates"
  echo "press q to go back"
  echo ""
  read -p "> " p
    if [ $p = "q" ]; then
      mainmenu
    elif [ $p = "c" ]; then
      check
    fi
  done
}

download(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                             Downloading Hakku ${update}"
  echo "                             ---------------------------"
  echo ""
  echo ""
  wget --no-check-certificate --content-disposition https://github.com/Rybo713/Hakku/tarball/$update
  curl -LJO https://github.com/Rybo713/Hakku/tarball/$update
  echo ""
  echo "                                   Extracting files"
  echo ""
  tar xvzf *.tar.gz && rm *.tar.gz
  echo ""
  echo "          To install move contents from the new folder to the old folder."
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " pp
    if [ $pp = "q" ]; then
      mainmenu
    fi
  done
}

check(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                          Checking for new updates"
  echo "                          ------------------------"
  echo ""
  echo ""
  update="$(curl --silent "https://api.github.com/repos/Rybo713/Hakku/tags" | jq -r '.[0].name')"
  echo ""
  if [ $update = "v2.0.1-beta" ]; then
    updating="No new updates"
    printf "${GREEN}${bold}                             No new updates${NC}${normal}\n"
    noti=""
  else
    updating="New updates found: ${update}"
    dl="press d to download Hakku ${update}"
    printf "${RED}${bold}                         New updates found: ${update}${NC}${normal}\n"
    noti="${RED}${bold}[1]${NC}${normal}\n"
  fi
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press d to download Hakku ${update}"
  echo "press q to go back"
  echo ""
  read -p "> " ppp
    if [ $ppp = "q" ]; then
      update
    elif [ $ppp = "d" ]; then
      download
    fi
  done
}
