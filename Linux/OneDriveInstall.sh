#!/bin/bash

# Color Vaiables
RED='\033[0;31m'
BLUE='\033[0;34m'
RED_ON_WHITE='\033[0;31;47m'
RESET='\033[0m'

# Other Variables
oddir="~/OneDriveClient"
odgui="~/OneDriveClient/OneDriveGUI-1.3.0-x86_64.AppImage"

# Starting Script
echo "OneDrive Client Install Script"
echo -e "=== ${RED}OneDrive Client Install Script${RESET} ==="

echo -e "=== ${RED}Updating APT${RESET} ==="
apt update

echo -e "=== ${RED}Installing Prerequisites${RESET} ==="
sudo apt install build-essential -y
sudo apt install libcurl4-openssl-dev libsqlite3-dev pkg-config git curl systemd-dev libdbus-1-dev -y

echo -e "=== ${RED}Installing DLang${RESET} ==="
curl -fsS https://dlang.org/install.sh | bash -s dmd

mkdir $oddir
cd $oddir

echo -e "=== ${RED}Cloning OneDrive Client Git${RESET} ==="
git clone https://github.com/abraunegg/onedrive.git
cd onedrive/

echo -e "=== ${RED}Activating dlang${RESET} ==="
source ~/dlang/dmd-2.112.0/activate

echo -e "=== ${RED}Configuring Source${RESET} ==="
./configure

echo -e "=== ${RED}Compiling Source${RESET} ==="
make clean; make;

echo -e "=== ${RED}Installing OneDrive${RESET} ==="
sudo make install

echo -e "=== ${RED}Deactivating DLang${RESET} ==="
deactivate

if command -v onedrive >/dev/null 2>&1; then
  echo "Install Completed!"
else
  echo "Install Failed, OneDrive Command does not exist."
fi

echo -e "=== ${RED}Downloading OneDrive Client GUI${RESET} ==="

if [ -f "$odgui" ]; then
    echo "OneDrive GUI Client exists. No action required."
else
    echo "OneDrive GUI Client does not exist. Downloading."
    wget -P "$oddir" https://github.com/bpozdena/OneDriveGUI/releases/download/v1.3.0/OneDriveGUI-1.3.0-x86_64.AppImage

    chmod +x $odgui
    echo -e "=== ${RED}Launching OneDrive Client GUI${RESET} ==="
    $odgui > /dev/null 2>&1 & disown
fi