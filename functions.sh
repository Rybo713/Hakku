#
# Hakku3 Functions: A totally reworked command line utility which shows the user
#             their system info and a bunch of useful tools and tweaks.
#                   Built using Bash version 3.2.57(1)-release
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

# Clear Console
clear

# Loading Screen
refresh(){

printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking if script is running as root"

if [[ $EUID -ne 0 ]]; then
  printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root!\n"
  exit 1
elif [[ $EUID -ne 1 ]]; then
  echo ""
fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}This script is running as root\n"
printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking system if it meets requirements\n"

if
command -v brew > /dev/null ; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}HomeBrew is installed\n"
else
  printf "${RED}${bold}[ERROR] ${NC}${normal}HomeBrew is not installed\n"
  exit 0
fi

if command -v jq > /dev/null ; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}jq is installed\n"
else

  printf "${RED}${bold}[ERROR] ${NC}${normal}jq is not installed\n"
  echo "Install jq with 'brew install jq'"
  exit 0
fi

if command -v wget > /dev/null ; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}wget is installed\n"
else
  printf "${RED}${bold}[ERROR] ${NC}${normal}wget is not installed\n"
  echo "Install wget with 'brew install wget'"
  exit 0
fi

if command -v curl > /dev/null ; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}curl is installed\n"
else
  printf "${RED}${bold}[ERROR] ${NC}${normal}curl is not installed\n"
  echo "Curl should be installed with macOS"
  exit 0
fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Bash version\n"
bashv=$BASH_VERSION

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Model info\n"
if [[ "$(kmutil showloaded --variant-suffix release | grep -F -e "FakeSMC" -e "VirtualSMC")" != "" ]]; then
                model="Hackintosh ($(sysctl -n hw.model))"
                printf "${GREEN}${bold}[INFO] ${NC}${normal}System is a Hackintosh\n"
              else
                model="$(sysctl -n hw.model)"
                printf "${GREEN}${bold}[INFO] ${NC}${normal}System is a real Mac\n"
              fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting CPU info\n"
cpu=$(sysctl -n machdep.cpu.brand_string)

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting GPU info\n"
gpu="$(system_profiler SPDisplaysDataType |\
                       awk -F': ' '/^\ *Chipset Model:/ {printf $2 ", "}')"
gpu="${gpu//\/ \$}"
gpu="${gpu%,*}"

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting RAM info\n"
ram="$(system_profiler SPHardwareDataType |\
                       awk -F': ' '/^\ *Memory:/ {printf $2 ", "}')"
ram="${ram//\/ \$}"
ram="${ram%,*}"

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Kernel info\n"
kernel=$(uname -r)

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Battery info\n"
batt=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
if [ "$batt" -le "20" ]; then
  low="Low Battery"
elif [ "$batt" -ge "100" ]; then
  full="Fully Charged"
else
  printf ""
fi
battcon=$(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}')

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Disk info\n"
dtype="$(diskutil info / |\
                       awk -F': ' '/^\ *File System Personality:/ {printf $2 ", "}')"
dtype="${dtype//\/ \$}"
dtype="${dtype%,*}"

nvme="$(system_profiler SPNVMeDataType |\
                       awk -F': ' '/^\ *Model:/ {printf $2 ", "}')"
nvme="${nvme//\/ \$}"
nvme="${nvme%,*}"
sata="$(system_profiler SPSerialATADataType |\
                       awk -F': ' '/^\ *Model:/ {printf $2 ", "}')"
sata="${sata//\/ \$}"
sata="${sata%,*}"

printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting MacOS version\n"
OS=$(sw_vers -productVersion)
if [ $OS == "10.14.0" ] || [ $OS == "10.14.1" ] || [ $OS == "10.14.2" ] || [ $OS == "10.14.3" ] || [ $OS == "10.14.4" ] || [ $OS == "10.14.5" ]; then
  name="(Mojave)"
elif [ $OS == "10.13.0" ] || [ $OS == "10.13.1" ] || [ $OS == "10.13.2" ] || [ $OS == "10.13.3" ] || [ $OS == "10.13.4" ] || [ $OS == "10.13.5" ] || [ $OS == "10.13.6" ]; then
  name="(High Sierra)"
elif [ $OS == "10.12.0" ] || [ $OS == "10.12.1" ] || [ $OS == "10.12.2" ] || [ $OS == "10.12.3" ] || [ $OS == "10.12.4" ] || [ $OS == "10.12.5" ] || [ $OS == "10.12.6" ]; then
  name="(Sierra)"
elif [ $OS == "10.15" ] || [ $OS == "10.15.1" ] || [ $OS == "10.15.2" ] || [ $OS == "10.15.3" ] || [ $OS == "10.15.4" ] || [ $OS == "10.15.5" ] || [ $OS == "10.15.6" ] || [ $OS == "10.15.7" ]; then
  name="(Catalina)"
elif [ $OS == "11.0" ] || [ $OS == "11.0.1" ] || [ $OS == "11.1" ] || [ $OS == "11.2" ] || [ $OS == "11.2.1" ] || [ $OS == "11.2.2" ] || [ $OS == "11.2.3" ]; then
  name="(Big Sur)"
elif [ $OS == "11.3" ]; then
  name="(Big Sur Beta)"
else
  name="(Unknown)"
fi

check=0
check1=0
check2=0

printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Settings Extension\n"
if [ -e settings_f.sh ]; then
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Settings Extension\n"
else
  check=1
  printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Settings Extension\n"
  exit 0
fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Tweaks Extension\n"
if [ -e tweaks_f.sh ]; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Tweaks Extension\n"
else
  check1=1
  printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Tweaks Extension\n"
  exit 0
fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Update Extension\n"
if [ -e update_f.sh ]; then
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Update Extension\n"
else
  check2=1
  printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Update Extension\n"
  exit 0
fi

echo ""
echo "                               Loading..."
sleep 1
mainmenu
}

# mainmenu
mainmenu(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "$build                                                        $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  echo "                                 Ryan Wong 2021"
  echo ""
  echo ""
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo ""
  options=("Start" "Exit" "Help")

  select_option "${options[@]}"
  choice=$?

  if [ $choice = "0" ]; then
   systeminfo
 elif [ $choice = "1" ]; then
   goodbye
 elif [ $choice = "2" ]; then
   help
 fi

done
}

# systeminfo
systeminfo(){
  while true; do
 /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
 printf "$color"
 echo "                                                                      $version"
 echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
 echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
 echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
 echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
 echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
 echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
 printf "${NC}${normal}"
 printf "${CYAN}${bold}Bash Version: ${NC}${normal}"
 echo "$bashv"
 printf "${CYAN}${bold}CPU Info: ${NC}${normal}"
 echo "$cpu"
 printf "${CYAN}${bold}GPU Info: ${NC}${normal}"
 echo "$gpu"
 printf "${CYAN}${bold}RAM Info: ${NC}${normal}"
 echo "$ram"
 printf "${CYAN}${bold}Model Info: ${NC}${normal}"
 echo "$model"
 printf "${CYAN}${bold}Kernel Info: ${NC}${normal}"
 echo "Darwin $kernel"
 printf "${CYAN}${bold}MacOS Info: ${NC}${normal}"
 echo "MacOS $OS $name"
 printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
 printf "${LGREEN}${bold}NVME:${NC}${normal} $nvme\n"
 printf "           ${LGREEN}${bold}SATA:${NC}${normal} $sata\n"
 echo "$dtype on / partition"
 printf "${CYAN}${bold}Battery Info: ${NC}${normal}"
 echo "Percentage: $batt%"
 printf "${RED}${bold}              $low ${NC}${normal}\n"
 printf "              Condition : $battcon\n"

 options=("Menu" "Exit" "Help")

 select_option "${options[@]}"
 choice1=$?

 if [ $choice1 = "0" ]; then
   menus
 elif [ $choice1 = "1" ]; then
   goodbye
 elif [ $choice2 = "2" ]; then
   help
 fi
done
}

# New Menu
menus(){
  while true; do
 /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
 printf "$color"
 echo "                                                                      $version"
 echo ""
 echo ""
 echo ""
 echo ""
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
 options=("Options" "Help" "Info" "Tweaks" "Update $noti" "System Info" "Settings" "Exit")

 select_option "${options[@]}"
 choice2=$?

 if [ $choice2 = "0" ]; then
  options
 elif [ $choice2 = "1" ]; then
  help
 elif [ $choice2 = "2" ]; then
  info
 elif [ $choice2 = "3" ]; then
  . ./tweaks_f.sh
  risk
 elif [ $choice2 = "7" ]; then
  goodbye
 elif [ $choice2 = "4" ]; then
  . ./update_f.sh
  update
 elif [ $choice2 = "5" ]; then
  $start
 elif [ $choice2 = "6" ]; then
  . ./settings_f.sh
  settings
 fi
done
}

# exits program
goodbye(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  printf "${NC}${normal}                                 Are you sure?\n"
  echo ""
  echo ""

  options=("Yes" "No")

  select_option "${options[@]}"
  choice3=$?

  if [ $choice3 = "0" ]; then
    clear
    exit 0
  elif [ $choice3 = "1" ]; then
    menus
  fi
 done
}

# help page
help(){
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
  echo "                                  Hakku Usage"
  echo "                                  -----------"
  echo "                       system info | System Info"
  echo "                           exit    | Exit Program"
  echo "                              ?    | Help Page (This Page)"
  echo "                           options | Options Page"
  echo "                           tweaks  | Tweaks Page"
  echo "                           info    | Info Page"
  echo "                           settings| Settings Page"
  printf "                           update  | Check and Update Hakku$noti\n"
  echo ""
  echo ""

  options=("Menu")

  select_option "${options[@]}"
  choice4=$?

  if [ $choice4 = "0" ]; then
    menus
  fi
 done
}

# info page
info(){
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
  echo "                                  Information"
  echo "                                  -----------"
  echo "                        Hakku is a command line utility"
  echo "                        that shows system information,"
  echo "                       and has many options and tweaks"
  echo "                        to make your macOS experience"
  echo "                                 even better."
  echo ""
  echo "                             Built in Bash 3.2.57"
  echo ""
  echo "                             Created by Ryan Wong"
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  choice5=$?

  if [ $choice5 = "0" ]; then
   menus
  fi
 done
}

# options
options(){
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
  echo ""
  echo "                                    Options (1/2)"
  echo "                                    -------"
  echo ""

  options=("Mount / Unmount EFI" "Enable / Disable Gatekeeper" "Disable Hibernation"
  "Force Reboot" "Force Shutdown" "Delete iMessage related files/folders" "CPU Stress Test" "Next Page" "Back")

  select_option "${options[@]}"
  input5=$?

  if [ $input5 = "8" ]; then
   menus
 elif [ $input5 = "7" ]; then
   options2
 elif [ $input5 = "0" ]; then
   efi
 elif [ $input5 = "1" ]; then
   gatekeeper
 elif [ $input5 = "2" ]; then
   hibernation
 elif [ $input5 = "3" ]; then
   reboot1
 elif [ $input5 = "4" ]; then
   shutdown1
 elif [ $input5 = "5" ]; then
   imessage
 elif [ $input5 = "6" ]; then
   stress
  fi
 done
}

options2(){
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
  echo ""
  echo "                                    Options (2/2)"
  echo "                                    -------"
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

  options=("Undervolt" "Previous Page" "Back")

  select_option "${options[@]}"
  input51=$?

  if [ $input51 = "2" ]; then
   menus
 elif [ $input51 = "1" ]; then
   options
 elif [ $input51 = "0" ]; then
   undervolt
 fi
 done
}

undervolt(){
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
  echo ""
  echo "                                  Undervolt"
  echo "                                  ---------"
  echo ""
  echo ""
  printf "${RED}${bold}"
  echo " NOTE: THIS TOOL IS FOR ADVANCED USERS AND MAY DAMAGE YOUR COMPUTER PERMANENTLY"
  printf "${NC}${normal}"
  echo ""
  echo ""

  options=("Load VoltageShift.kext v1.25" "Voltage Info" "Undervolt Settings" "Back")

  select_option "${options[@]}"
  input5a=$?

  if [ $input5a = "3" ]; then
   options2
 elif [ $input5a = "0" ]; then
   undervolt1
 elif [ $input5a = "1" ]; then
   undervolt2
 elif [ $input5a = "2" ]; then
   undervolt3
 fi
 done
}

undervolt1(){
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
  echo ""
  echo "                                  Loading Kext"
  echo "                                  ------------"
  echo ""
  echo ""
  sudo chown -R root:wheel VoltageShift.kext
  echo ""
  echo ""
  echo "                    Successfully loaded VoltageShift.kext"
  echo ""
  echo ""
  echo ""
  echo ""

  options=("Back")

  select_option "${options[@]}"
  input5b=$?

  if [ $input5b = "0" ]; then
   undervolt
  fi
 done
}

undervolt3(){
  cpucoreoffset=0
  cpucacheoffset=0
  gpuoffset=0
  saoffset=0
  aiooffset=0
  diooffset=0
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
  echo "                               Undervolt Settings"
  echo "                               ------------------"
  echo "                             Change voltage offsets"
  echo ""
  echo "                                 1) CPU Core"
  echo "                                 2) CPU Cache"
  echo "                                 3) GPU"
  echo "                                 4) System Agency"
  echo "                                 5) Analog I/O"
  echo "                                 6) Digital I/O"
  echo ""
  echo "press q to go back"
  echo ""

  options=("CPU Core" "CPU Cache" "GPU" "System Agency" "Analog I/O" "Digital I/O" "Back")

  select_option "${options[@]}"
  input5c=$?

  if [ $input5c = "6" ]; then
   undervolt
 elif [ $input5c = "0" ]; then
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
   echo "                               CPU Core Offset"
   echo "                               ---------------"
   echo "                            Change CPU Core offsets"
   echo ""
   echo "                           Input your desired offset"
   echo ""
   echo "                                   ex. -80"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c1
   cpucoreoffset=$input5c1
   if [ $input5c1 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                               CPU Core Offset"
     echo "                               ---------------"
     ./voltageshift offset $cpucoreoffset
     echo ""
     echo "                      CPU Core offset changed to $cpucoreoffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c1a=$?

     if [ $input5c1a = "0" ]; then
       undervolt3
     fi
   fi
   done
 elif [ $input5c = "1" ]; then
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
   echo "                               CPU Cache Offset"
   echo "                               ----------------"
   echo "                            Change CPU Cache offsets"
   echo ""
   echo "                           Input your desired offset"
   echo ""
   echo "                                   ex. -80"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c2
   cpucacheoffset=$input5c2
   if [ $input5c2 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                               CPU Cache Offset"
     echo "                               ---------------"
     ./voltageshift offset - - $cpucacheoffset
     echo ""
     echo "                      CPU Cache offset changed to $cpucacheoffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c2a=$?

     if [ $input5c2a = "0" ]; then
       undervolt3
     fi
   fi
   done
 elif [ $input5c = "2" ]; then
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
   echo "                                 GPU Offset"
   echo "                                 ----------"
   echo "                             Change GPU offsets"
   echo ""
   echo "                          Input your desired offset"
   echo ""
   echo "                                   ex. -80"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c3
   gpuoffset=$input5c3
   if [ $input5c3 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                                 GPU Offset"
     echo "                                 ----------"
     ./voltageshift offset - $gpuoffset
     echo ""
     echo "                     GPU offset changed to $gpuoffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c3a=$?

     if [ $input5c3a = "q" ]; then
       undervolt3
     fi
   fi
   done
 elif [ $input5c = "3" ]; then
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
   echo "                              System Agent Offset"
   echo "                              -------------------"
   echo "                          Change System Agent offsets"
   echo ""
   echo "                          Input your desired offset"
   echo ""
   echo "                                   ex. -20"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c4
   saoffset=$input5c4
   if [ $input5c4 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                                 System Agent Offset"
     echo "                                 -------------------"
     ./voltageshift offset - - - $saoffset
     echo ""
     echo "                     System Agent offset changed to $saoffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c4a=$?

     if [ $input5c4a = "0" ]; then
       undervolt3
     fi
   fi
   done
 elif [ $input5c = "4" ]; then
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
   echo "                              Analog I/O Offset"
   echo "                              -----------------"
   echo "                          Change Analog I/O offsets"
   echo ""
   echo "                          Input your desired offset"
   echo ""
   echo "                                   ex. -20"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c5
   aiooffset=$input5c5
   if [ $input5c5 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                              Analog I/O Offset"
     echo "                              -----------------"
     ./voltageshift offset - - - - $aiooffset
     echo ""
     echo "                   Analog I/O offset changed to $aiooffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c5a=$?

     if [ $input5c5a = "0" ]; then
       undervolt3
     fi
   fi
   done
 elif [ $input5c = "5" ]; then
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
   echo "                              Digital I/O Offset"
   echo "                              ------------------"
   echo "                          Change Digital I/O offsets"
   echo ""
   echo "                          Input your desired offset"
   echo ""
   echo "                                   ex. -20"
   echo ""
   echo ""
   echo ""
   echo ""
   echo "press q to go back"
   echo ""
   read -p "> " input5c6
   diooffset=$input5c6
   if [ $input5c6 = "q" ]; then
     undervolt3
   else
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
     printf "${NC}${normal}"
     echo ""
     echo "                              Digital I/O Offset"
     echo "                              ------------------"
     ./voltageshift offset - - - - - $diooffset
     echo ""
     echo "                   Digital I/O offset changed to $diooffset mV"
     echo ""
     echo ""
     options=("Back")

     select_option "${options[@]}"
     input5c6a=$?

     if [ $input5c6a = "0" ]; then
       undervolt3
     fi
   fi
   done
  fi
 done
}

undervolt2(){
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
  printf "${NC}${normal}"
  ./voltageshift info
  echo ""
  echo ""
  options=("Back")

  select_option "${options[@]}"
  input5d=$?

  if [ $input5d = "0" ]; then
   undervolt
  fi
 done
}

efi(){
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
  echo ""
  echo "                             Mount / Unmount EFI"
  echo "                             -------------------"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  options=("Mount EFI" "Unmount EFI" "Back")

  select_option "${options[@]}"
  in3=$?

  if [ $in3 = "0" ]; then
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
    echo "                                  Mount EFI"
    echo "                                  ---------"
    diskutil list | grep EFI
    echo ""
    echo "                          disk0s1 is from internal disk"
    echo "                          disk1s1 is from external disk"
    echo ""
    echo "                  Type the disk identifier you want to mount."
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " in4
      if [ $in4 = "q" ]; then
        efi
      elif [ $in4 = "disk0s1" ]; then
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
        echo "                                  Mounting EFI"
        echo "                                  ------------"
        echo ""
        echo ""
        sudo diskutil mount disk0s1
        echo ""
        echo ""
        echo ""
        echo ""
        options=("Back")

        select_option "${options[@]}"
        in5=$?

          if [ $in5 = "0" ]; then
            efi
          fi

      elif [ $in4 = "disk1s1" ]; then
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
        echo "                                  Mounting EFI"
        echo "                                  ------------"
        echo ""
        echo ""
        sudo diskutil mount disk1s1
        echo ""
        echo ""
        echo ""
        echo ""
        options=("Back")

        select_option "${options[@]}"
        in6=$?

          if [ $in6 = "q" ]; then
            efi
          fi
      fi

  elif [ $in3 = "1" ]; then
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
    echo "                                  Unmount EFI"
    echo "                                  -----------"
    diskutil list | grep EFI
    echo ""
    echo "                          disk0s1 is from internal disk"
    echo "                          disk1s1 is from external disk"
    echo ""
    echo "                Type the disk identifier you want to unmount."
    echo ""
    echo ""
    echo ""
    echo ""
    echo "press q to go back"
    echo ""
    read -p "> " in7
      if [ $in7 = "q" ]; then
        efi
      elif [ $in7 = "disk0s1" ]; then
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
        echo "                                  Unmounting EFI"
        echo "                                  --------------"
        echo ""
        echo ""
        echo ""
        diskutil unmount /dev/disk0s1
        echo ""
        echo ""
        echo ""
        echo ""
        echo ""
        options=("Back")

        select_option "${options[@]}"
        in8=$?

        if [ $in8 = "0" ]; then
          efi
        fi

      elif [ $in7 = "disk1s1" ]; then
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
        echo "                                  Unmounting EFI"
        echo "                                  --------------"
        echo ""
        echo ""
        echo ""
        diskutil unmount /dev/disk1s1
        echo ""
        echo ""
        echo ""
        echo ""
        echo ""
        options=("Back")

        select_option "${options[@]}"
        in9=$?

          if [ $in9 = "0" ]; then
            efi
          fi
      fi

  elif [ $in3 = "2" ]; then
    options
  fi
 done
}

gatekeeper(){
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
  echo ""
  echo "                         Enable / Disable GateKeeper"
  echo "                         ---------------------------"
  echo ""
  echo ""
  echo "                            1) Enable GateKeeper"
  echo "                            2) Disable GateKeeper"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  options=("Enable GateKeeper" "Disable GateKeeper" "Back")

  select_option "${options[@]}"
  i=$?

    if [ $i = "0" ]; then
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
      echo "                              Enable GateKeeper"
      echo "                              -----------------"
      echo ""
      echo ""
      sudo spctl --master-enable
      echo "                             GateKeeper enabled"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      options=("Back")

      select_option "${options[@]}"
      ii=$?

        if [ $ii = "0" ]; then
          gatekeeper
        fi
    elif [ $i = "1" ]; then
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
      echo "                              Disable GateKeeper"
      echo "                              ------------------"
      echo ""
      echo ""
      sudo spctl --master-disable
      echo "                             GateKeeper disabled"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      options=("Back")

      select_option "${options[@]}"
      iii=$?

        if [ $iii = "0" ]; then
          gatekeeper
        fi
    elif [ $i = "2" ]; then
      options
    fi
  done
}

hibernation(){
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
  printf "${NC}${normal}"
  echo "                           Disabling Hibernation"
  echo "                           ---------------------"
  sudo pmset -a hibernatemode 0
  sudo rm /var/vm/sleepimage
  sudo mkdir /var/vm/sleepimage
  sudo pmset -a standby 0
  sudo pmset -a autopoweroff 0
  echo ""
  echo "                           Hibernation disabled"
  echo ""
  echo ""
  options=("Back")

  select_option "${options[@]}"
  ii=$?

    if [ $ii = "0" ]; then
      options
    fi
  done
}

reboot1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  echo ""
  printf "${NC}${normal}\n"
  echo "                                 Force Reboot"
  echo "                     (Any unsaved progress will be lost)"
  echo ""
  printf "                                Are you sure?\n"
  echo ""
  echo ""
  echo ""
  options=("Yes" "No")

  select_option "${options[@]}"
  in=$?

  if [ $in = "0" ]; then
    sudo shutdown -r now
  elif [ $in = "1" ]; then
    options
  fi
 done
}

shutdown1(){
  while true; do
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "               ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗██████╗ ";
  echo "               ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║╚════██╗";
  echo "               ███████║███████║█████╔╝ █████╔╝ ██║   ██║ █████╔╝";
  echo "               ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║ ╚═══██╗";
  echo "               ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝██████╔╝";
  echo "               ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ";
  echo ""
  echo ""
  printf "${NC}${normal}\n
  "
  echo "                                 Force Shutdown"
  echo "                     (Any unsaved progress will be lost)"
  echo ""
  printf "                                Are you sure?\n"
  echo ""
  echo ""
  echo ""
  options=("Yes" "No")

  select_option "${options[@]}"
  inq=$?

  if [ $inq = "0" ]; then
    sudo shutdown now
  elif [ $inq = "1" ]; then
    options
  fi
 done
}

imessage(){
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
  printf "${NC}${normal}"
  echo ""
  echo "                 Deleting iMessage related files and folders"
  echo "                 -------------------------------------------s"
  cd ~/Library/Caches/
  rm -R com.apple.Messages*
  rm -R com.apple.imfoundation*
  cd ~/Library/Preferences/
  rm com.apple.iChat*
  rm com.apple.imagent*
  rm com.apple.imessage*
  rm com.apple.imservice*
  rm -R ~/Library/Messages/
  echo "                             Done. Please Reboot"
  echo ""
  echo ""
  echo ""
  options=("Back")

  select_option "${options[@]}"
  iia=$?

    if [ $iia = "0" ]; then
      options
    fi
  done
}

stress(){
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
  printf "${NC}${normal}"
  echo ""
  echo "                              CPU Stress Test"
  echo "                              ---------------"
  echo ""
  echo "                          CPU Stress Test Started"
  echo ""
  echo "Use Intel Power Gadget to see if you are throttling, temps, package watts, utilization, etc"
  echo ""
  echo ""
  echo ""
  echo ""
  yes > /dev/null & yes > /dev/null & yes > /dev/null & yes > /dev/null &
  echo ""
  echo ""
  options=("Stop Test")

  select_option "${options[@]}"
  ins=$?

    if [ $iis = "0" ]; then
      killall yes
      options
    fi
  done
}
