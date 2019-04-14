#!/bin/bash
#
# Hakku2 Settings Functions: A totally reworked command line utility which shows
#                             the user their system info and a bunch of useful
#                                            tools and tweaks.
#                                Built using Bash version 3.2.57(1)-release
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

settings(){
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
  echo "                                  Settings "
  echo "                                  --------"
  echo ""
  echo ""
  echo "                                1) VoiceOver"
  echo "                           2) Change Color of Logo"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " op

    if [ $op = 1 ]; then
      voiceover
    elif [ $op = 2 ]; then
      colorlogo
    elif [ $op = "q" ]; then
      mainmenu
    fi
  done
}

voiceover(){
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
  echo "                                  VoiceOver"
  echo "                                  ---------"
  echo ""
  echo ""
  echo "                                 1) Enable"
  echo "                                 2) Disable"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " op1

  if [ $op1 = 1 ]; then
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
    echo ""
    echo "                             Enabling VoiceOver"
    echo "                             ------------------"
    echo ""
    echo ""
    vo="Warning! I am not responsible for any damage that may be caused by using these tweaks."
    echo ""
    echo "                             Enabled VoiceOver"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op11
      if [ $op11 = "q" ]; then
        voiceover
      fi

  elif [ $op1 = 2 ]; then
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
    echo "                              Disabling VoiceOver"
    echo "                              -------------------"
    echo ""
    echo ""
    vo=""
    echo ""
    echo "                               Disabled VoiceOver"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op12
      if [ $op12 = "q" ]; then
        voiceover
      fi
  elif [ $op1 = "q" ]; then
    settings
  fi
  done
}

colorlogo(){
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
  echo "                             Change Color of Logo "
  echo "                             ---------------------"
  echo ""
  echo ""
  echo "                                1) Original"
  echo "                                2) Red"
  echo "                                3) Blue"
  echo "                                4) Green"
  echo "                                5) White"
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " op2

  if [ $op2 = 1 ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${YELLOW}${bold}"
    echo ""
    echo "                         Changed Logo Color to Yellow"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op2a
      if [ $op2a = "q" ]; then
        colorlogo
      fi

  elif [ $op2 = 2 ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${RED}${bold}"
    echo ""
    echo "                           Changed Logo Color to Red"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op2b
      if [ $op2b = "q" ]; then
        colorlogo
      fi

  elif [ $op2 = 3 ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${BLUE}${bold}"
    echo ""
    echo "                          Changed Logo Color to Blue"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op2c
      if [ $op2c = "q" ]; then
        colorlogo
      fi

  elif [ $op2 = 4 ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${GREEN}${bold}"
    echo ""
    echo "                         Changed Logo Color to Green"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op2d
      if [ $op2d = "q" ]; then
        colorlogo
      fi

  elif [ $op2 = 5 ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${NC}${bold}"
    echo ""
    echo "                          Changed Logo Color to White"
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " op2e
      if [ $op2e = "q" ]; then
        colorlogo
      fi

  elif [ $op2 = "q" ]; then
    settings
  fi
 done
}
