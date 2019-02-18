#!/bin/bash
#
# An example page/template in HackTool2
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
read -p "> " input.
