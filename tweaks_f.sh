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
  echo "                          4) Scrollbar Visibility"
  echo "                           5) Show Hidden Files"
  echo "                            6) Clear DNS Cache"
  echo "                          7) Purge Memory Cache"
  echo "                       8) Enable / Disable Root User"
  echo "                   9) Erase Spotlight Index and Rebuild"
  echo "                          10) Rebuild KextCache"
  echo ""
  echo ""
  echo "press q to go back"
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
    scrollbar
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
  elif [ $www = 10 ]; then
    kextcache
  fi

}

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
  if [ $wwww1a = "q" ];
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
  if [ $wwww1b = "q" ];
    chime
  fi
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www2
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www3
}

scrollbar(){
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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www4
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www5
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www6
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www7
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www8
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www9
}

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
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " www10
}
