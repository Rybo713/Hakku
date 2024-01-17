#
# Sets pemissions for the Hakku3 Tool
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
  printf "${RED}${bold}[ERROR] ${NC}${normal}This script must be run as root!\n"
  exit 1
elif [[ $EUID -ne 1 ]]; then
  echo ""
fi

printf "${GREEN}${bold}[INFO] ${NC}${normal}Setting Permissions...\n"
echo '#            (10%)\r\c'
echo '##           (20%)\r\c'
sudo chmod +x ./Hakku3.sh
echo '###          (30%)\r\c'
sudo chmod +x ./load.sh
echo '####         (40%)\r\c'
sudo chmod +x ./settings_f.sh
echo '#####        (50%)\r\c'
sudo chmod +x ./update_f.sh
echo '########     (80%)\r\c'
sudo chmod +x ./tweaks_f.sh
echo '#########    (90%)\r\c'
sudo chmod +x ./functions.sh
echo '##########   (100%)\r\c'
echo '\n'
printf "${GREEN}${bold}[INFO] ${NC}${normal}Finished setting permissions!\n"
