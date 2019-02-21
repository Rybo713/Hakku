#!/bin/bash
#
# HackTool: A command line utility which shows the user their system info and
#           tools to make it easier to mount EFI and disable GateKeeper.
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

if [[ $EUID -ne 0 ]]; then
  printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root\n"
  exit 1
elif [[ $EUID -ne 1 ]]; then
  echo ""
fi

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

while true; do

printf '\033[8;57;75t'

version="1.5-beta"
printf "${YELLOW}${bold}"
echo ""
echo "                 __  __           __  ______            __ "
echo "                / / / /___ ______/ /_/_  __/___  ____  / / "
echo "               / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
echo "              / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
echo "             /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
echo "                                           v$version"
echo ""
echo "                            Ryan Wong 2019"
echo ""
echo ""
printf "${CYAN}${bold}CPU Info: ${NC}${normal}"
echo "$cpu"
echo ""
printf "${CYAN}${bold}GPU Info: ${NC}${normal}"
echo "$gpu"
echo ""
printf "${CYAN}${bold}RAM Info: ${NC}${normal}"
echo "$ram"
echo ""
printf "${CYAN}${bold}Model Info: ${NC}${normal}"
echo "$model"
echo ""
printf "${CYAN}${bold}Kernel Info: ${NC}${normal}"
echo "Darwin $kernel"
echo ""
printf "${CYAN}${bold}MacOS Info: ${NC}${normal}"
echo "MacOS $OS $name"
echo ""
printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
printf "${LGREEN}${bold}NVME:${NC}${normal} $nvme\n"
printf "           ${LGREEN}${bold}SATA:${NC}${normal} $sata\n"
echo "$dtype on / partition"
echo ""
printf "${CYAN}${bold}Battery Info: ${NC}${normal}"
echo "Percentage: $batt%"
printf "${RED}${bold}              $low ${NC}${normal}\n"
printf "${GREEN}${bold}              $full ${NC}${normal}\n"
echo "              Condition : $battcon"
echo ""
echo ""
printf "${bold}Options:${normal}\n"
echo "1) Mount / Unmount EFI"
echo "2) Enable / Disable Gatekeeper"
echo "3) Tweaks for macOS"
echo "4) Disable Hibernation"
echo "5) Delete iMessage related files/folders (Use with extra caution!)"
echo "r) Force Reboot"
echo "s) Force Shutdown"
echo "f) Refresh Info"
echo "t) Settings"
echo "i) Info"
echo "q) Exit"
echo	""

read	-p "> " input

if [ $input = "" ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
fi

if [ $input = 0 ]; then
  echo "Deleting iMessage related files/folders..."
  cd ~/Library/Caches/
  rm -R com.apple.Messages*
  rm -R com.apple.imfoundation*
  cd ~/Library/Preferences/
  rm com.apple.iChat*
  rm com.apple.imagent*
  rm com.apple.imessage*
  rm com.apple.imservice*
  rm -R ~/Library/Messages/
  echo "Done, Reboot"
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Deleted iMessage related files/folders, Please Reboot\n"
fi

if [ $input = 1 ]; then
  echo "1) Mount EFI"
  echo "2) Unmount EFI"
  echo ""
  read -p "> " answe

  if [ $answe = 1 ]; then
    diskutil list | grep EFI
    echo ""
    echo "disk0s1 is from internal disk"
    echo "disk1s1 is from external disk"
    echo ""
    echo "Type the disk identifier you want to mount."
    echo ""
    read -p "> " answer

      if [ $answer = "disk0s1" ]; then
        echo "Mounting EFI from internal disk..."
        mkdir "/Volumes/efi(internal)"
        sudo mount -t msdos /dev/disk0s1 "/Volumes/efi(internal)"
        open "/Volumes/efi(internal)"
      elif [ $answer = "disk1s1" ]; then
        echo "Mounting EFI from external disk..."
        mkdir "/Volumes/efi(external)"
        sudo mount -t msdos /dev/disk1s1 "/Volumes/efi(external)"
        open "/Volumes/efi(external)"
      fi
  fi

  if [ $answe = 2 ]; then
    diskutil list | grep EFI
    echo ""
    echo "disk0s1 is from internal disk"
    echo "disk1s1 is from external disk"
    echo ""
    echo "Type the disk identifier you want to unmount."
    echo ""
    read -p "> " answers

    if [ $answers = "disk0s1" ]; then
      echo "Unmounting EFI from internal disk..."
      diskutil unmount /dev/disk0s1
    elif [ $answers = "disk1s1" ]; then
      echo "Unmounting EFI from external disk..."
      diskutil unmount /dev/disk1s1
    fi
  fi
fi

if [ $input = 2 ]; then
  echo "1) Enable GateKeeper"
  echo "2) Disable GateKeeper"
  read -p "> " in

  if [ $in = "1" ]; then
    echo "Enabling GateKeeper..."
    sudo spctl --master-enable
    echo "GateKeeper enabled"
  elif [ $in = "2" ]; then
    echo "Disabling GateKeeper..."
    sudo spctl --master-disable
    echo "GateKeeper disabled"
  fi
fi

if [ $input = 3 ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  /bin/bash tweaks.sh
fi

if [ $input = 4 ]; then
  echo "Disabling Hibernation"
  echo ""
  sudo pmset -a hibernatemode 0
  sudo rm /var/vm/sleepimage
  sudo mkdir /var/vm/sleepimage
  sudo pmset -a standby 0
  sudo pmset -a autopoweroff 0
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${GREEN}${bold}[INFO] ${NC}${normal}Disabled Hibernation\n"
fi

if [ $input = "i" ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${GREEN}${bold}[INFO] ${NC}${normal}HackTool v$version by Ryan Wong\n"
fi

if [ $input = "r" ]; then
  echo "Are you sure you want to Force Restart? (Any unsaved progress will be lost) (y/n)"
  read	-p "> " ans

  if [ $ans = "y" ]; then
    sudo shutdown -r now
  elif [ $ans = "n" ]; then
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  else
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  fi

fi

if [ $input = "f" ]; then
   /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Refreshing info\n"
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
   echo ""
fi

if [ $input = "s" ]; then
  echo "Are you sure you want to Force Shutdown? (Any unsaved progress will be lost) (y/n)"
  read	-p "> " answ

  if [ $answ = "y" ]; then
    sudo shutdown now
  elif [ $answ = "n" ]; then
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  else
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  fi
fi

if [ $input = "t" ]; then
  echo ""
  printf "${bold}Settings${normal}"
  echo ""
  echo ""
  echo "1) VoiceOver"
  echo "b) Back"
  echo ""
  read -p "> " ii

  if [ $ii = 1 ]; then
    echo ""
    echo "1) Enable VoiceOver"
    echo "2) Disable VoiceOver"
    echo "b) Back"
    echo ""
    read -p "> " iii

      if [ $iii = 1 ]; then
        source tweaks.sh
        $vo="1"
        /bin/bash HackTool.sh
      elif [ $iii = 2 ]; then
        source tweaks.sh
        $vo="2"
        /bin/bash HackTool.sh
      elif [ $iii = "b" ]; then
        /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
      fi

  elif [ $ii = "b" ]; then
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  fi

fi

if [ $input = "q" ] || [ $input = "exit" ]; then
  echo "Goodbye!"
  false
  exit 0
fi

done
