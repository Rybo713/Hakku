#
# Hakku3 Loading Screen: A totally reworked loading screen for Hakku3.
#                   Built using Bash version 3.2.57(1)-release
#
# The MIT License (MIT)
#
# Copyright (c) 2024 Ryan Wong
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

loading() {
if [[ $EUID -ne 0 ]]; then
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
  echo "                                 Ryan Wong 2024"
  printf "${RED}${bold}"
  echo ""
  echo ""
  echo "                                       ⃠"
  printf "${RED}${bold}                   [ERROR] ${NC}${normal}This script must be run as root!\n"
  echo ""
  echo ""
  echo ""
  echo ""
  exit 1
elif [[ $EUID -ne 1 ]]; then
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
  echo "                                 Ryan Wong 2024"
  echo ""
  printf "${NC}${normal}"
  echo '#                         (1%)\r\c'
  if
  command -v brew > /dev/null ; then
    echo '                        #                         (2%)\r\c'
    if command -v jq > /dev/null ; then
      echo '                        #                         (5%)\r\c'
      if command -v wget > /dev/null ; then
        echo '                        ##                        (10%)\r\c'
        if command -v curl > /dev/null ; then
          echo '                        ##                        (15%)\r\c'
          bashv=$BASH_VERSION
          echo '                        ##                        (17%)\r\c'
          if [[ "$(kmutil showloaded --variant-suffix release | grep -F -e "FakeSMC" -e "VirtualSMC")" != "" ]]; then
                          model="Hackintosh ($(sysctl -n hw.model))"
                          echo '                        ###                       (20%)\r\c'
                          cpu=$(sysctl -n machdep.cpu.brand_string)
                          echo '                        ####                      (25%)\r\c'
                          gpu="$(system_profiler SPDisplaysDataType |\
                                                 awk -F': ' '/^\ *Chipset Model:/ {printf $2 ", "}')"
                          gpu="${gpu//\/ \$}"
                          gpu="${gpu%,*}"
                          echo '                        ####                      (30%)\r\c'
                          ram="$(system_profiler SPHardwareDataType |\
                                                 awk -F': ' '/^\ *Memory:/ {printf $2 ", "}')"
                          ram="${ram//\/ \$}"
                          ram="${ram%,*}"
                          echo '                        #####                     (40%)\r\c'
                          kernel=$(uname -r)
                          echo '                        #####                     (45%)\r\c'
                          batt=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
                          if [ "$batt" -le "20" ]; then
                            low="Low Battery"
                          elif [ "$batt" -ge "100" ]; then
                            full="Fully Charged"
                          else
                            printf ""
                          fi
                          battcon=$(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}')
                          echo '                        #######                   (50%)\r\c'
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
                          echo '                        #######                   (55%)\r\c'
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
                          elif [ $OS == "11.3" ] || [ $OS == "11.7.10" ]; then
                            name="(Big Sur)"
                          elif [ $OS == "12.0" ] || [ $OS == "12.7.2" ]; then
                            name="(Monterey)"
                          elif [ $OS == "13.0" ] || [ $OS == "13.6.3" ]; then
                            name="(Ventura)"
                          elif [ $OS == "14.0" ] || [ $OS == "14.1" ] || [ $OS == "14.1.1" ] || [ $OS == "14.1.2" ] || [ $OS == "14.2" ] || [ $OS == "14.2.1" ]; then
                            name="(Sonoma)"
                          elif [ $OS == "14.3" ]; then
                            name="(Sonoma Beta)"
                          else
                            name="(Unknown)"
                          fi
                          echo '                        #########                 (60%)\r\c'

                          check=0
                          check1=0
                          check2=0

                          if [ -e settings_f.sh ]; then
                            echo '                        ###########               (65%)\r\c'
                            if [ -e tweaks_f.sh ]; then
                              echo '                        #############             (70%)\r\c'
                              if [ -e update_f.sh ]; then
                                echo '                        ###############           (80%)\r\c'
                                echo '                        ##################        (100%)\r\c'
                                echo '\n'

                              else
                                check2=1
                                printf "${RED}${bold}"
                                echo ""
                                echo ""
                                echo "                                       ⃠"
                                printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Settings Extension\n"
                                echo ""
                                echo ""
                                echo ""
                                exit 0
                              fi
                            else
                              check1=1
                              printf "${RED}${bold}"
                              echo ""
                              echo ""
                              echo "                                       ⃠"
                              printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Tweaks Extension\n"
                              echo ""
                              echo ""
                              echo ""
                              exit 0
                            fi
                          else
                            check=1
                            printf "${RED}${bold}"
                            echo ""
                            echo ""
                            echo "                                       ⃠"
                            printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Update Extension\n"
                            echo ""
                            echo ""
                            echo ""
                            exit 0
                          fi
                        else
                          model="$(sysctl -n hw.model)"
                          echo '                        ###                        (20%)\r\c'
                          cpu=$(sysctl -n machdep.cpu.brand_string)
                          echo '                        ####                       (25%)\r\c'
                          gpu="$(system_profiler SPDisplaysDataType |\
                                                 awk -F': ' '/^\ *Chipset Model:/ {printf $2 ", "}')"
                          gpu="${gpu//\/ \$}"
                          gpu="${gpu%,*}"
                          echo '                        ####                      (30%)\r\c'
                          ram="$(system_profiler SPHardwareDataType |\
                                                 awk -F': ' '/^\ *Memory:/ {printf $2 ", "}')"
                          ram="${ram//\/ \$}"
                          ram="${ram%,*}"
                          echo '                        #####                     (40%)\r\c'
                          kernel=$(uname -r)
                          echo '                        #####                     (45%)\r\c'
                          batt=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
                          if [ "$batt" -le "20" ]; then
                            low="Low Battery"
                          elif [ "$batt" -ge "100" ]; then
                            full="Fully Charged"
                          else
                            printf ""
                          fi
                          battcon=$(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}')
                          echo '                        #######                   (50%)\r\c'
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
                          echo '                        #######                   (55%)\r\c'
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
                          elif [ $OS == "11.3" ] || [ $OS == "11.7.10" ]; then
                            name="(Big Sur)"
                          elif [ $OS == "12.0" ] || [ $OS == "12.7.2" ]; then
                            name="(Monterey)"
                          elif [ $OS == "13.0" ] || [ $OS == "13.6.3" ]; then
                            name="(Ventura)"
                          elif [ $OS == "14.0" ] || [ $OS == "14.1" ] || [ $OS == "14.1.1" ] || [ $OS == "14.1.2" ] || [ $OS == "14.2" ] || [ $OS == "14.2.1" ]; then
                            name="(Sonoma)"
                          elif [ $OS == "14.3" ]; then
                            name="(Sonoma Beta)"
                          else
                            name="(Unknown)"
                          fi
                          echo '                        #########                 (60%)\r\c'

                          check=0
                          check1=0
                          check2=0

                          if [ -e settings_f.sh ]; then
                            echo '                        ###########               (65%)\r\c'
                            if [ -e tweaks_f.sh ]; then
                              echo '                        #############             (70%)\r\c'
                              if [ -e update_f.sh ]; then
                                echo '                        ###############           (80%)\r\c'
                                echo '                        ##################        (100%)\r\c'
                                echo '\n'
                              else
                                check2=1
                                printf "${RED}${bold}"
                                echo ""
                                echo ""
                                echo "                                       ⃠"
                                printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Settings Extension\n"
                                echo ""
                                echo ""
                                echo ""
                                exit 0
                              fi
                            else
                              check1=1
                              printf "${RED}${bold}"
                              echo ""
                              echo ""
                              echo "                                       ⃠"
                              printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Tweaks Extension\n"
                              echo ""
                              echo ""
                              echo ""
                              exit 0
                            fi
                          else
                            check=1
                            printf "${RED}${bold}"
                            echo ""
                            echo ""
                            echo "                                       ⃠"
                            printf "${RED}${bold}                   [ERROR] ${NC}${normal}Failed to find Update Extension\n"
                            echo ""
                            echo ""
                            echo ""
                            exit 0
                          fi
                        fi
        else
          printf "${RED}${bold}"
          echo ""
          echo ""
          echo "                                       ⃠"
          echo "Curl should be installed with macOS"
          printf "${RED}${bold}                   [ERROR] ${NC}${normal}curl is not installed\n"
          echo ""
          echo ""
          exit 0
        fi
      else
        printf "${RED}${bold}"
        echo ""
        echo ""
        echo "                                       ⃠"
        echo "Install wget with 'brew install wget'"
        printf "${RED}${bold}                   [ERROR] ${NC}${normal}wget is not installed\n"
        echo ""
        echo ""
        exit 0
      fi
    else
      printf "${RED}${bold}"
      echo ""
      echo ""
      echo "                                       ⃠"
      echo "Install jq with 'brew install jq'"
      printf "${RED}${bold}                   [ERROR] ${NC}${normal}jq is not installed\n"
      echo ""
      echo ""
      exit 0
    fi
  else
    printf "${RED}${bold}"
    echo ""
    echo ""
    echo "                                       ⃠"
    printf "${RED}${bold}                   [ERROR] ${NC}${normal}HomeBrew is not installed\n"
    echo ""
    echo ""
    exit 0
  fi

fi
sleep 1
mainmenu
}
