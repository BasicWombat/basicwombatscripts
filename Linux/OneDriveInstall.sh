#!/bin/bash

# Color Vaiables
RED='\033[0;31m'
BLUE='\033[0;34m'
RED_ON_WHITE='\033[0;31;47m'
RESET='\033[0m'

# Other Variables
oddir="$HOME/OneDriveClient"
odgui="$HOME/OneDriveClient/OneDriveGUI-1.3.0-x86_64.AppImage"

Install-OneDrive () {
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

    Start-Menu

}

Uninstall-OneDrive () {
    if [ -f "$oddir" ]; then
        echo "Directory exists. No action required."
    else
        mkdir $oddir
    fi
    cd $oddir

    echo -e "=== ${RED}Cloning OneDrive Client Git${RESET} ==="
    git clone https://github.com/abraunegg/onedrive.git
    cd onedrive/

    echo -e "=== ${RED}Activating dlang${RESET} ==="
    source ~/dlang/dmd-2.112.0/activate

    echo -e "=== ${RED}Uninstalling OneDrive${RESET} ==="
    sudo make uninstall

    echo -e "=== ${RED}Deactivating DLang${RESET} ==="
    deactivate

    if command -v onedrive >/dev/null 2>&1; then
        echo "Uninstall Failed!"
    else
        echo "Install Completed."
    fi

    read -n 1 -r -s -p $'Press enter to continue...\n'

    Start-Menu

}


Install-ODGUI () {

    echo -e "=== ${RED}Downloading OneDrive Client GUI${RESET} ==="

    if [ -f "$odgui" ]; then
        whiptail --title "OneDrive GUI" --msgbox "OneDrive GUI Client exists. No action required." 8 78
    else
        echo "OneDrive GUI Client does not exist. Downloading."
        wget -nd -P "$oddir" --show-progress \
        https://github.com/bpozdena/OneDriveGUI/releases/download/v1.3.0/OneDriveGUI-1.3.0-x86_64.AppImage

        chmod +x $odgui
        echo -e "=== ${RED}Launching OneDrive Client GUI${RESET} ==="
        whiptail --title "Starting OneDrive GUI" --msgbox "OneDrive GUI will now be launch. Press OK to continue." 8 78
        $odgui > /dev/null 2>&1 & disown
    fi

    Start-Menu

}

# This will come later where it can update the GUI.

# Update-ODGUI () {
#     echo -e "=== ${RED}Updating OneDrive Client GUI${RESET} ==="

#     echo "Stopping running processes."
#     pgrep -f "OneDriveGUI" | xargs -r kill

#     echo "OneDrive GUI Client does not exist. Downloading."
#         wget -nd -P "$oddir" --show-progress \
#         https://github.com/bpozdena/OneDriveGUI/releases/download/v1.3.0/OneDriveGUI-1.3.0-x86_64.AppImage

#         chmod +x $odgui
#         echo -e "=== ${RED}Launching OneDrive Client GUI${RESET} ==="
#         whiptail --title "Starting OneDrive GUI" --msgbox "OneDrive GUI will now be launch. Press OK to continue." 8 78
#         $odgui > /dev/null 2>&1 & disown

#     Start-Menu

# }

Start-Menu () {
    # Reference: https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
    CHOICE=$(whiptail --title "OneDrive Linux Client Install Script" --menu "Choose an option" 15 60 4 \
    "1" "Install OneDrive Client" \
    "2" "Install OneDrive Client GUI" \
    "3" "Uninstall OneDrive" \
    "4" "Exit" 3>&1 1>&2 2>&3)

    case $CHOICE in
        1) 
            Install-OneDrive
            ;;
        2) 
            Install-ODGUI
            ;;
        3)
            Uninstall-OneDrive
            ;;
        *) 
            exit 
            ;;
    esac
}

###
# Main body of script starts here
###

Start-Menu