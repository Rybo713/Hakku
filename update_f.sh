#
# Hakku3 Update Functions: A totally reworked command line utility which shows
#                            the user their system info and a bunch of useful
#                                           tools and tweaks.
#                               Built using Bash version 3.2.57(1)-release
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

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

update(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
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
  echo ""
  echo ""
  options=("Check for Updates" "Back" "$dl")

  select_option "${options[@]}"
  update1=$?

    if [ $update1 = "0" ]; then
      check
    elif [ $update1 = "1" ]; then
      menus
    elif [ $update1 = "2" ]; then
      download
    fi
  done
}

download(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
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
  echo ""

  options=("Back")

  select_option "${options[@]}"
  update2=$?

    if [ $update2 = "0" ]; then
      menus
    fi
  done
}

check(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                          Checking for new updates"
  echo "                          ------------------------"
  echo ""
  echo ""
  update="$(curl --silent "https://api.github.com/repos/Rybo713/Hakku/tags" | jq -r '.[0].name')"
  echo ""
  if [ $update = "v3.0.0" ]; then
    updating="No new updates"
    printf "${GREEN}${bold}                                 No new updates${NC}${normal}\n"
    noti=""
  elif [ $update = "v2.3.1-beta" ]; then
    updating="No new updates"
    printf "${GREEN}${bold}                                 No new updates${NC}${normal}\n"
    noti=""
  else
    updating="New updates found: ${update}"
    dl="Download Hakku ${update}"
    printf "${RED}${bold}                         New updates found: ${update}${NC}${normal}\n"
    noti="${RED}${bold}[1]${NC}${normal}\n"
  fi
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("$dl" "Back")

  select_option "${options[@]}"
  update3=$?

    if [ $update3 = "1" ]; then
      update
    elif [ $update3 = "0" ]; then
      download
    fi
  done
}
