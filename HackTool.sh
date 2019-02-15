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
batt=$(ioreg -l | awk '$3~/Capacity/{c[$3]=$5}END{OFMT="%.3f";max=c["\"MaxCapacity\""];print(max>0?100*c["\"CurrentCapacity\""]/max:"?")}')
battcon=$(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}')
printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting Disk info\n"
dtype="$(diskutil info / |\
                       awk -F': ' '/^\ *Partition Type:/ {printf $2 ", "}')"
dtype="${dtype//\/ \$}"
dtype="${dtype%,*}"
disk="$(system_profiler SPNVMeDataType |\
                       awk -F': ' '/^\ *Model:/ {printf $2 ", "}')"
disk="${disk//\/ \$}"
disk="${disk%,*}"
printf "${GREEN}${bold}[INFO] ${NC}${normal}Getting MacOS version\n"
OS=$(sw_vers -productVersion)
if [ $OS == "10.14.0" ] || [ $OS == "10.14.1" ] || [ $OS == "10.14.2" ] || [ $OS == "10.14.3" ] || [ $OS == "10.14.4" ]; then
  name="(Mojave)"
else
  name=""
fi

while true; do

printf '\033[8;50;75t'

version="1.0beta"
printf "${YELLOW}${bold}"
echo "                 __  __           __  ______            __ "
echo "                / / / /___ ______/ /_/_  __/___  ____  / / "
echo "               / /_/ / __ \/ ___/ //_// / / __ \/ __ \/ / "
echo "              / __  / /_/ / /__/ ,<  / / / /_/ / /_/ / / "
echo "             /_/ /_/\__,_/\___/_/|_|/_/  \____/\____/_/ "
echo "                                            v$version"
echo "                            Ryan Wong 2019"
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
echo "$kernel"
echo ""
printf "${CYAN}${bold}MacOS Info: ${NC}${normal}"
echo "MacOS $OS $name"
echo ""
printf "${CYAN}${bold}Disk Info: ${NC}${normal}"
echo "$disk"
echo "$dtype"
echo ""
printf "${CYAN}${bold}Battery Info: ${NC}${normal}"
echo "Percentage: $batt%"
echo "              Condition : $battcon"
echo ""
echo ""
printf "${bold}Options${normal}\n"
echo "1) Mount EFI"
echo "2) Disable Gatekeeper"
echo "r) Force Reboot"
echo "s) Force Shutdown"
echo "f) Refresh Info"
echo "i) Info"
echo "q) Exit"
echo	""

read	-p "> " input

if [ $input = "" ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
fi

if [ $input = 1 ]; then
  echo "Mounting EFI..."
  if [ "$(id -u)" != "0" ]; then
      if [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
        echo "Run as root"
      fi
      sudo $0 $@
      exit 0
  fi

  # Note: Based on CloverPackage MountESP script.

  if [[ "$1" == "" ]]; then
      DestVolume=/
  else
      DestVolume="$1"
  fi

  # find whole disk for the destination volume
  DiskDevice=$(LC_ALL=C diskutil info "$DestVolume" 2>/dev/null | sed -n 's/.*Part [oO]f Whole: *//p')
  if [[ -z "$DiskDevice" ]]; then
      echo "Error: Not able to find volume with the name \"$DestVolume\""
      exit 1
  fi

  # check if target volume is a logical Volume instead of physical
  if [[ "$(echo $(LC_ALL=C diskutil list | grep -i 'Logical Volume' | awk '{print tolower($0)}'))" == *"logical volume"* ]]; then
      # ok, we have a logical volume somewhere.. so that can assume that we can use "diskutil cs"
      LC_ALL=C diskutil cs info $DiskDevice > /dev/null 2>&1
      if [[ $? -eq 0 ]] ; then
          # logical volumes does not have an EFI partition (or not suitable for us?)
          # find the partition uuid
          UUID=$(LC_ALL=C diskutil info "${DiskDevice}" 2>/dev/null | sed -n 's/.*artition UUID: *//p')
          # with the partition uuid we can find the real disk in in diskutil list output
          if [[ -n "$UUID" ]]; then
              realDisk=$(LC_ALL=C diskutil list | grep -B 1 "$UUID" | grep -i 'logical volume' | awk '{print $4}' | sed -e 's/,//g' | sed -e 's/ //g')
              if [[ -n "$realDisk" ]]; then
                  DiskDevice=$(LC_ALL=C diskutil info "${realDisk}" 2>/dev/null | sed -n 's/.*Part [oO]f Whole: *//p')
              fi
          fi
      fi
  fi

  # check if target volume is APFS, and therefore part of an APFS container
  if [[ "$(echo $(LC_ALL=C diskutil list "$DiskDevice" | grep -i 'APFS Container Scheme' | awk '{print tolower($0)}'))" == *"apfs container scheme"* ]]; then
      # ok, this disk is an APFS partition, extract physical store device
      realDisk=$(LC_ALL=C diskutil list "$DiskDevice" 2>/dev/null | sed -n 's/.*Physical Store *//p')
      DiskDevice=$(LC_ALL=C diskutil info "$realDisk" 2>/dev/null | sed -n 's/.*Part [oO]f Whole: *//p')
  fi

  PartitionScheme=$(LC_ALL=C diskutil info "$DiskDevice" 2>/dev/null | sed -nE 's/.*(Partition Type|Content \(IOContent\)): *//p')
  # Check if the disk is an MBR disk
  if [[ "$PartitionScheme" == "FDisk_partition_scheme" ]]; then
      echo "Error: Volume \"$DestVolume\" is part of an MBR disk"
      exit 1
  fi
  # Check if not GPT
  if [[ "$PartitionScheme" != "GUID_partition_scheme" ]]; then
      echo "Error: Volume \"$DestVolume\" is not on GPT disk or APFS container"
      exit 1
  fi

  # Find the associated EFI partition on DiskDevice
  diskutil list -plist "/dev/$DiskDevice" 2>/dev/null >/tmp/org_rehabman_diskutil.plist
  for ((part=0; 1; part++)); do
      content=`/usr/libexec/PlistBuddy -c "Print :AllDisksAndPartitions:0:Partitions:$part:Content" /tmp/org_rehabman_diskutil.plist 2>&1`
      if [[ "$content" == *"Does Not Exist"* ]]; then
          echo "Error: cannot locate EFI partition for $DestVolume"
          exit 1
      fi
      if [[ "$content" == "EFI" ]]; then
          EFIDevice=`/usr/libexec/PlistBuddy -c "Print :AllDisksAndPartitions:0:Partitions:$part:DeviceIdentifier" /tmp/org_rehabman_diskutil.plist 2>&1`
          break
      fi
  done
  rm /tmp/org_rehabman_diskutil.plist

  # should not happen
  if [[ -z "$EFIDevice" ]]; then
      echo "Error: unable to determine EFIDevice from $DiskDevice"
      exit 1
  fi

  # Get the EFI mount point if the partition is currently mounted
  code=0
  EFIMountPoint=$(LC_ALL=C diskutil info "$EFIDevice" 2>/dev/null | sed -n 's/.*Mount Point: *//p')
  if [[ -z "$EFIMountPoint" ]]; then
      # try to mount the EFI partition
      EFIMountPoint="/Volumes/EFI"
      [ ! -d "$EFIMountPoint" ] && mkdir -p "$EFIMountPoint"
      diskutil mount -mountPoint "$EFIMountPoint" /dev/$EFIDevice >/dev/null 2>&1
      code=$?
  fi
  echo "${EFIMountPoint// /\\ }"
  exit $code

open /Volumes/EFI
fi

if [ $input = 2 ]; then
  echo "Disabling GateKeeper..."
  if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
      sudo $0 $@
      exit 0
  fi

  sudo spctl --master-disable
  echo 'GateKeeper disabled'
fi

if [ $input = "i" ]; then
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  printf "${GREEN}${bold}[INFO] ${NC}${normal}HackTool v$version by Ryan Wong\n"
fi

if [ $input = "r" ]; then
  echo "Are you sure you want to Force Restart? (Any unsaved progress will be gone) (y/n)"
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
   printf "${GREEN}${bold}[INFO] ${NC}${normal}Refreshed info"
   echo ""
fi

if [ $input = "s" ]; then
  echo "Are you sure you want to Force Shutdown? (Any unsaved progress will be gone) (y/n)"
  read	-p "> " answ

  if [ $answ = "y" ]; then
    sudo shutdown now
  elif [ $answ = "n" ]; then
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  else
    /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  fi
fi

if [ $input = "q" ]; then
  echo "Goodbye!"
  exit 0
fi

done
