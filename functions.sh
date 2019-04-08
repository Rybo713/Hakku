#!/bin/bash
#
# Hakku2 Functions: A totally reworked command line utility which shows the user
#             their system info and a bunch of useful tools and tweaks.
#                   Built using Bash version 3.2.57(1)-release
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

# Refresh
refresh(){
  if [[ $EUID -ne 0 ]]; then
    printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root\n"
    exit 1
  elif [[ $EUID -ne 1 ]]; then
    echo ""
  fi

  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

  printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking if script is running as root\n"
  printf "${GREEN}${bold}[INFO] ${NC}${normal}This script is running as root\n"
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking system if it meets requirements\n"

  if
  command -v brew > /dev/null ; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}HomeBrew package is installed\n"
  else
    printf "${RED}${bold}[ERROR] ${NC}${normal}HomeBrew package is not installed\n"
    exit 0
  fi

  if command -v jq > /dev/null ; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}jq package is installed\n"
  else
    printf "${RED}${bold}[ERROR] ${NC}${normal}jq package is not installed\n"
    echo "Install jq with 'brew install jq'"
    exit 0
  fi

  if command -v wget > /dev/null ; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}wget package is installed\n"
  else
    printf "${RED}${bold}[ERROR] ${NC}${normal}wget package is not installed\n"
    echo "Install wget with 'brew install wget'"
    exit 0
  fi

  if command -v curl > /dev/null ; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}curl package is installed\n"
  else
    printf "${RED}${bold}[ERROR] ${NC}${normal}curl package is not installed\n"
    echo "Curl should be installed with macOS"
    exit 0
  fi

  printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Model info\n"
  if [[ "$(kextstat | grep -F -e "FakeSMC" -e "VirtualSMC")" != "" ]]; then
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
  if [ $OS == "10.14.0" ] || [ $OS == "10.14.1" ] || [ $OS == "10.14.2" ] || [ $OS == "10.14.3" ] || [ $OS == "10.14.4" ]; then
    name="(Mojave)"
  elif [ $OS == "10.13.0" ] || [ $OS == "10.13.1" ] || [ $OS == "10.13.2" ] || [ $OS == "10.13.3" ] || [ $OS == "10.13.4" ] || [ $OS == "10.13.5" ] || [ $OS == "10.13.6" ]; then
    name="(High Sierra)"
  elif [ $OS == "10.12.0" ] || [ $OS == "10.12.1" ] || [ $OS == "10.12.2" ] || [ $OS == "10.12.3" ] || [ $OS == "10.12.4" ] || [ $OS == "10.12.5" ] || [ $OS == "10.12.6" ]; then
    name="(Sierra)"
  else
    name=""
  fi

  check=0
  check1=0

  printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Settings Extension\n"
  if [ -e settings_f.sh ]; then
     printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Settings Extension\n"
  else
    check=1
    printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Settings Extension\n"
  fi

  printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Tweaks Extension\n"
  if [ -e tweaks_f.sh ]; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Tweaks Extension\n"
  else
    check1=1
    printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Tweaks Extension\n"
  fi

  printf "${GREEN}${bold}[INFO] ${NC}${normal}Checking for Update Extension\n"
  if [ -e update_f.sh ]; then
    printf "${GREEN}${bold}[INFO] ${NC}${normal}Found Update Extension\n"
  else
    check1=1
    printf "${RED}${bold}[ERROR] ${NC}${normal}Failed to find Update Extension\n"
  fi
}

# mainmenu
mainmenu(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "? for help                                                            $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  echo "                                 Ryan Wong 2019"
  echo ""
  echo ""
  echo ""
  echo ""
  printf "${NC}${bold}                         1) Start           Q) Exit"
  echo ""
  echo ""
  echo ""
  echo ""
  read -p "> " input

  if [ $input = 1 ]; then
    systeminfo
  elif [ $input = "Q" ] || [ $input = "q" ]; then
    goodbye
  elif [ $input = "?" ]; then
    help
  fi
}

# systeminfo
systeminfo(){
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
 printf "${GREEN}${bold}              $full ${NC}${normal}\n"
 printf "              Condition : $battcon\n"
 echo ""
 read -p "> " in2

 if [ $in2 = "options" ]; then
  options
elif [ $in2 = "?" ]; then
  help
 elif [ $in2 = "info" ]; then
  info
 elif [ $in2 = "tweaks" ]; then
  . ./tweaks_f.sh
  risk
 elif [ $in2 = "exit" ]; then
  goodbye
 elif [ $in2 = "update" ]; then
  . ./update_f.sh
  update
 elif [ $in2 = "refresh" ]; then
  refresh
  systeminfo
 elif [ $in2 = "settings" ]; then
  . ./settings_f.sh
  settings
 fi
}

# exits program
goodbye(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"

  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  printf "${NC}${bold}                                 Are you sure?\n"
  echo "                                     (Y/N) "
  echo ""
  echo ""
  echo ""
  read -p "> " in

  if [ $in = "y" ] || [ $in = "Y" ]; then
    exit 0
  elif [ $in = "n" ] || [ $in = "N" ]; then
    mainmenu
  fi
}

# help page
help(){
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
  echo "                                  Hakku Usage"
  echo "                                  -----------"
  echo "                           refresh | Refresh System Info"
  echo "                           exit    | Exit Program"
  echo "                              ?    | Help Page (This Page)"
  echo "                           options | Options Page"
  echo "                           tweaks  | Tweaks Page"
  echo "                           info    | Info Page"
  echo "                           settings| Settings Page"
  echo "                           update  | Check and Update Hakku"
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " input3

   if [ $input3 = "options" ]; then
    options
  elif [ $input3 = "?" ]; then
    help
  elif [ $input3 = "info" ]; then
    info
  elif [ $input3 = "tweaks" ]; then
    . ./tweaks_f.sh
    risk
  elif [ $input3 = "exit" ]; then
    goodbye
  elif [ $input3 = "refresh" ]; then
    refresh
    systeminfo
  elif [ $input3 = "settings" ]; then
    . ./settings_f.sh
    settings
  elif [ $input3 = "update" ]; then
    . ./update_f.sh
    update
  elif [ $input3 = "q" ]; then
    mainmenu
  fi
}

# info page
info(){
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
  echo "press q to go back"
  echo ""
  read -p "> " input4

  if [ $input4 = "q" ]; then
   mainmenu
  fi
}

# options
options(){
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
  echo "                                    Options"
  echo "                                    -------"
  echo "                            1) Mount / Unmount EFI"
  echo "                         2) Enable / Disable Gatekeeper"
  echo "                            3) Disable Hibernation"
  echo "                                4) Force Reboot"
  echo "                               5) Force Shutdown"
  echo "                    6) Delete iMessage related files/folders"
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " input5

  if [ $input5 = "q" ]; then
   mainmenu
 elif [ $input5 = 1 ]; then
   efi
 elif [ $input5 = 2 ]; then
   gatekeeper
 elif [ $input5 = 3 ]; then
   hibernation
 elif [ $input5 = 4 ]; then
   reboot1
 elif [ $input5 = 5 ]; then
   shutdown1
 elif [ $input5 = 6 ]; then
   imessage
  fi

}

efi(){
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
  echo "                             Mount / Unmount EFI"
  echo "                             -------------------"
  echo ""
  echo ""
  echo "                                1) Mount EFI"
  echo "                               2) Unmount EFI"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " in3

  if [ $in3 = 1 ]; then
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
        echo "                                  Mounting EFI"
        echo "                                  ------------"
        echo ""
        echo ""
        mkdir "/Volumes/EFI"
        sudo mount -t msdos /dev/disk0s1 "/Volumes/EFI"
        open "/Volumes/EFI"
        echo ""
        echo ""
        echo ""
        echo "press q to go back"
        echo ""
        read -p "> " in5
          if [ $in5 = "q" ]; then
            efi
          fi

      elif [ $in4 = "disk1s1" ]; then
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
        echo "                                  Mounting EFI"
        echo "                                  ------------"
        echo ""
        echo ""
        mkdir "/Volumes/EFI2"
        sudo mount -t msdos /dev/disk1s1 "/Volumes/EFI2"
        open "/Volumes/EFI2"
        echo ""
        echo ""
        echo ""
        echo "press q to go back"
        echo ""
        read -p "> " in6
          if [ $in6 = "q" ]; then
            efi
          fi
      fi

  elif [ $in3 = 2 ]; then
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
        echo "press q to go back"
        echo ""
        read -p "> " in8
        if [ $in8 = "q" ]; then
          efi
        fi

      elif [ $in7 = "disk1s1" ]; then
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
        echo "press q to go back"
        echo ""
        read -p "> " in9
          if [ $in9 = "q" ]; then
            efi
          fi
      fi

  elif [ $in3 = "q" ]; then
    options
  fi
}

gatekeeper(){
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
  echo "press q to go back"
  echo ""
  read -p "> " i
    if [ $i = 1 ]; then
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
      echo "press q to go back"
      echo ""
      read -p "> " ii
        if [ $ii = "q" ]; then
          gatekeeper
        fi
    elif [ $i = 2 ]; then
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
      echo "press q to go back"
      echo ""
      read -p "> " iii
        if [ $iii = "q" ]; then
          gatekeeper
        fi
    elif [ $i = "q" ]; then
      options
    fi
}

hibernation(){
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
  echo "press q to go back"
  echo ""
  read -p "> " ii
    if [ $ii = "q" ]; then
      options
    fi
}

reboot1(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  echo ""
  printf "${NC}${normal}\n"
  echo "                                 Force Reboot"
  echo "                     (Any unsaved progress will be lost)"
  echo ""
  printf "                                Are you sure?\n"
  echo "                                     (Y/N) "
  echo ""
  echo ""
  echo ""
  read -p "> " in

  if [ $in = "y" ] || [ $in = "Y" ]; then
    sudo shutdown -r now
  elif [ $in = "n" ] || [ $in = "N" ]; then
    options
  fi
}

shutdown1(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "$color"
  echo "                                                                      $version"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "                  ██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗██╗   ██╗";
  echo "                  ██║  ██║██╔══██╗██║ ██╔╝██║ ██╔╝██║   ██║";
  echo "                  ███████║███████║█████╔╝ █████╔╝ ██║   ██║";
  echo "                  ██╔══██║██╔══██║██╔═██╗ ██╔═██╗ ██║   ██║";
  echo "                  ██║  ██║██║  ██║██║  ██╗██║  ██╗╚██████╔╝";
  echo "                  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ";
  echo ""
  echo ""
  printf "${NC}${normal}\n
  "
  echo "                                 Force Shutdown"
  echo "                     (Any unsaved progress will be lost)"
  echo ""
  printf "                                Are you sure?\n"
  echo "                                     (Y/N) "
  echo ""
  echo ""
  echo ""
  read -p "> " in

  if [ $in = "y" ] || [ $in = "Y" ]; then
    sudo shutdown now
  elif [ $in = "n" ] || [ $in = "N" ]; then
    options
  fi
}

imessage(){
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
  echo "press q to go back"
  echo ""
  read -p "> " ii
    if [ $ii = "q" ]; then
      options
    fi
}
