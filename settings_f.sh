#
# Hakku3 Settings Functions: A totally reworked command line utility which shows
#                             the user their system info and a bunch of useful
#                                            tools and tweaks.
#                                Built using Bash version 3.2.57(1)-release
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

settings(){
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
  echo "                                  Settings "
  echo "                                  --------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("VoiceOver" "Change Color of Logo" "Verbose Mode" "Back")

  select_option "${options[@]}"
  set1=$?

    if [ $set1 = "0" ]; then
      voiceover
    elif [ $set1 = "1" ]; then
      colorlogo
    elif [ $set1 = "2" ]; then
      verbose
    elif [ $set1 = "3" ]; then
      menus
    fi
  done
}

voiceover(){
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
  options=("Enable" "Disable" "Back")

  select_option "${options[@]}"
  set2=$?

  if [ $set2 = "0" ]; then
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
    echo ""
    options=("Back")

    select_option "${options[@]}"
    set4=$?

      if [ $set4 = "0" ]; then
        voiceover
      fi

  elif [ $set2 = "1" ]; then
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
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set5=$?

      if [ $set5 = "0" ]; then
        voiceover
      fi
  elif [ $set2 = "2" ]; then
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
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                             Change Color of Logo "
  echo "                             ---------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Original" "Red" "Violet" "Green" "White" "Back")

  select_option "${options[@]}"
  set6=$?

  if [ $set6 = "0" ]; then
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
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set7=$?
      if [ $set7 = "0" ]; then
        colorlogo
      fi

  elif [ $set6 = "1" ]; then
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
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set8=$?
      if [ $set8 = "0" ]; then
        colorlogo
      fi

  elif [ $set6 = "2" ]; then
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
    echo ""
    echo "                              Changing Logo Color"
    echo "                              -------------------"
    echo ""
    echo ""
    color="${BLUE}${bold}"
    echo ""
    echo "                          Changed Logo Color to Violet"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set9=$?
      if [ $set9 = "0" ]; then
        colorlogo
      fi

  elif [ $set6 = "3" ]; then
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
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set0=$?
      if [ $set0 = "0" ]; then
        colorlogo
      fi

  elif [ $set6 = "4" ]; then
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
    echo ""

    options=("Back")

    select_option "${options[@]}"
    set10=$?
      if [ $set10 = "0" ]; then
        colorlogo
      fi

  elif [ $set6 = "5" ]; then
    settings
  fi
 done
}

verbose(){
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
  echo "                                   Verbose"
  echo "                                  ---------"
  echo ""
  echo ""
  echo "                                 1) Enable"
  echo "                                 2) Disable"
  echo ""
  echo ""
  echo ""
  echo ""
  options=("Enable" "Disable" "Back")
  select_option "${options[@]}"
  set12=$?

  if [ $set12 = "0" ]; then
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
    echo "                                   Verbose"
    echo "                                  ---------"
    echo ""
    start=refresh
    echo "                             Enabled Verbose Mode"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    options=("Back")
    select_option "${options[@]}"
    set121=$?

    if [ $set121 = "0" ]; then
      verbose
    fi

  elif [ $set12 = "1" ]; then
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
    echo "                                   Verbose"
    echo "                                  ---------"
    echo ""
    start=loading
    echo "                             Disabled Verbose Mode"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    options=("Back")
    select_option "${options[@]}"
    set122=$?

    if [ $set122= "0" ]; then
      verbose
    fi

  elif [ $set12 = "2" ]; then
    settings
  fi


  done
}
