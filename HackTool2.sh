#!/bin/bash
#
# HackTool2: A totally reworked command line utility which shows the user their system info.
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

# All of the functions
refresh(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

  printf "${GREEN}${bold}[INFO] ${NC}${normal}This script is running as root\n"
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
                         awk -F': ' '/^\ *Partition Type:/ {printf $2 ", "}')"
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
  else
    name=""
  fi

  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
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
  read -p "> " input2
}

help(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo "                                 HackTool Usage"
  echo "                                 --------------"
  echo "                           refresh | Refresh System Info"
  echo "                           exit    | Exit program"
  echo "                           help    | Help page (this page)"
  echo "                           options | Options page"
  echo "                           tweaks  | Tweaks page"
  echo "                           info    | Info page"
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " input3
}

info(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                                  Information"
  echo "                                  -----------"
  echo "                      HackTool is a command line utility"
  echo "                        that shows system information,"
  echo "                       and has many options and tweaks"
  echo "                        to make your macOS experience"
  echo "                                 even better."
  echo ""
  echo "                              Built in Bash 3.2"
  echo ""
  echo "                             Created by Ryan Wong"
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " input4
}

options(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
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
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " input5
}

option1(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo "                                Mount / Unmount EFI"
  echo "                                -------------------"
  echo ""
  echo "                                    1) Mount EFI"
  echo "                                   2) Unmount EFI"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1
}

option1a(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                                    Mount EFI"
  echo "                    ---------------------------------------"
  diskutil list | grep EFI
  echo "                    ---------------------------------------"
  echo ""
  echo "                        disk0s1 is from internal disk"
  echo "                        disk1s1 is from external disk"
  echo ""
  echo "                  Type the disk identifier you want to mount."
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1a
}

option1aa(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                            Mounting EFI on disk0s1"
  echo "                            -----------------------"
  echo ""
  echo ""
  echo ""
  mkdir "/Volumes/efi(internal)"
  sudo mount -t msdos /dev/disk0s1 "/Volumes/efi(internal)"
  open "/Volumes/efi(internal)"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1aa
}

option1ab(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                            Mounting EFI on disk1s1"
  echo "                            -----------------------"
  echo ""
  echo ""
  echo ""
  mkdir "/Volumes/efi(internal)"
  sudo mount -t msdos /dev/disk1s1 "/Volumes/efi(internal)"
  open "/Volumes/efi(internal)"
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1ab
}

option1b(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                                    Unmount EFI"
  echo "                    ---------------------------------------"
  diskutil list | grep EFI
  echo "                    ---------------------------------------"
  echo ""
  echo "                        disk0s1 is from internal disk"
  echo "                        disk1s1 is from external disk"
  echo ""
  echo "                  Type the disk identifier you want to unmount."
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1b
}

option1ba(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                            Unmounting EFI on disk0s1"
  echo "                            -----------------------"
  echo ""
  echo ""
  echo ""
  diskutil unmount /dev/disk0s1
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1ba
}

option1bb(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo "                            Unmounting EFI on disk1s1"
  echo "                            -----------------------"
  echo ""
  echo ""
  echo ""
  diskutil unmount /dev/disk1s1
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo1bb
}

option2(){
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
  echo ""
  printf "${NC}${normal}"
  echo ""
  echo ""
  echo ""
  echo "                            Enable / Disable GateKeeper"
  echo "                            ---------------------------"
  echo ""
  echo "                               1) Enable GateKeeper"
  echo "                               2) Disable GateKeeper"
  echo ""
  echo ""
  echo ""
  echo ""
  echo "press q to go back"
  echo ""
  read -p "> " inputo2
}

option3(){
  echo ""
}

option4(){
  echo ""
}

option5(){
  echo ""
}

# Checks if script is ran in root
if [[ $EUID -ne 0 ]]; then
  printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root\n"
  exit 1
elif [[ $EUID -ne 1 ]]; then
  echo ""
fi

# Clears consoles
/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

printf "${GREEN}${bold}[INFO] ${NC}${normal}This script is running as root\n"
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
                       awk -F': ' '/^\ *Partition Type:/ {printf $2 ", "}')"
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
else
  name=""
fi

/usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'

printf '\033[8;24;80t'

version="2.0-beta"
printf "${YELLOW}${bold}"
echo "                                                                       v$version"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "                     __  __           __  ______            __ "
echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
echo ""
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
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${YELLOW}${bold}"
  echo "                                                                       v$version"
  echo ""
  echo "                     __  __           __  ______            __ "
  echo "                    / / / /___ ______/ /_/_  __/___  ____  / / "
  echo "                   / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
  echo "                  / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
  echo "                 /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
  echo ""
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
  read -p "> " input2
fi

  if [ $input2 = "help" ]; then
    help

    if [ $input3 = "q" ]; then
      refresh
    fi
  fi

  if [ $input2 = "info" ]; then
    info

    if [ $input4 = "q" ]; then
      refresh
    fi
  fi

  if [ $input2 = "options" ]; then
    options

    if [ $input5 = "q" ]; then
      refresh
    elif [ $input5 = 1 ]; then
      option1
        if [ $inputo1 = 1 ]; then
          option1a
            if [ $inputo1a = "disk0s1" ]; then
              option1aa
                if [ $inputo1aa = "q" ]; then
                  option1a
                fi
            elif [ $inputo1a = "disk1s1" ]; then
              option1ab
              if [ $inputo1ab = "q" ]; then
                option1a
              fi
            elif [ $inputo1a = "q" ]; then
              option1a
            fi
        elif [ $inputo1 = 2 ]; then
          option1b
          if [ $inputo1b = "disk0s1" ]; then
            option1ba
              if [ $inputo1ba = "q" ]; then
                option1b
              fi
          elif [ $inputo1b = "disk1s1" ]; then
            option1bb
            if [ $inputo1bb = "q" ]; then
              option1b
            fi
          elif [ $inputo1b = "q" ]; then
            option1b
          fi
        elif [ $inputo1 = "q" ]; then
          options
        fi
    elif [ $input5 = 2 ]; then
      option2
    elif [ $input5 = 3 ]; then
      option3
    elif [ $input5 = 4 ]; then
      option4
    elif [ $input5 = 5 ]; then
      option5
    fi
  fi

  if [ $input2 = "tweaks" ]; then
    tweaks
    if [ $input6 = "q" ]; then
      refresh
    fi
  fi

if [ $input  = "q" ] || [ $input = "Q" ]; then
  exit 0
fi
