#!/bin/zsh

# --- Style Variables ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo "${GREEN}*** Linux Bootable USB Helper (dd-boot.sh) ***${RESET}"
echo ""

# 1. Prompt for the full path of the ISO file
while true; do
    echo -n "${YELLOW}1. Enter the full path of the .iso file (e.g., ~/Downloads/ubuntu.iso): ${RESET}"
    read ISO_PATH

    if [ -f "$ISO_PATH" ]; then
        echo "${GREEN}ISO file found.${RESET}"
        break
    else
        echo "${RED}ERROR: The file '$ISO_PATH' was not found. Please try again.${RESET}"
    fi
done

# 2. List all disks (internal and external)
echo ""
echo "${YELLOW}2. Current Disk List (Internal and External):${RESET}"
diskutil list

echo ""
echo "${RED}!!! WARNING: THE NEXT STEP WILL ERASE ALL DATA ON THE SELECTED DISK. !!!${RESET}"
echo -n "${YELLOW}3. Enter the DISK IDENTIFIER NUMBER of your USB drive (Only the number, e.g., 4 for /dev/disk4): ${RESET}"
read DISK_NUMBER

# 3. Validate the disk input
if ! [[ "$DISK_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "${RED}ERROR: Invalid input. You must enter only the disk number (e.g., 4).${RESET}"
    exit 1
fi

TARGET_DISK="/dev/disk${DISK_NUMBER}"
TARGET_RDISK="/dev/rdisk${DISK_NUMBER}" # Using rdisk for faster transfer

# 4. Final confirmation
echo ""
echo "${GREEN}SELECTED TARGET DISK: $TARGET_DISK${RESET}"
echo "${RED}Confirm: Are you absolutely sure you want to write '$ISO_PATH' to '$TARGET_DISK'? (y/n)${RESET}"
read -r CONFIRMATION

if [[ "$CONFIRMATION" != "y" ]]; then
    echo "${YELLOW}Operation cancelled by the user. No data has been modified.${RESET}"
    exit 0
fi

# 5. Unmount the disk
echo ""
echo "${YELLOW}4. Unmounting disk $TARGET_DISK...${RESET}"
diskutil unmountDisk "$TARGET_DISK"

if [ $? -ne 0 ]; then
    echo "${RED}ERROR: Failed to unmount the disk. Check if the disk is in use or if you selected the correct identifier.${RESET}"
    exit 1
fi

# 6. Execute the dd command
echo ""
echo "${GREEN}5. STARTING DD WRITE. This may take several minutes without showing progress.${RESET}"
echo "Command: sudo dd if='$ISO_PATH' of='$TARGET_RDISK' bs=1m"
echo "You can press CTRL+T after a few seconds to see the progress (if supported by your system)."
echo ""

# Execute the dd command
sudo dd if="$ISO_PATH" of="$TARGET_RDISK" bs=1m

# 7. Finalization and Ejection
if [ $? -eq 0 ]; then
    echo ""
    echo "${GREEN}WRITING COMPLETE!${RESET}"
    echo "${YELLOW}6. Ejecting disk $TARGET_DISK...${RESET}"
    diskutil eject "$TARGET_DISK"
    echo "${GREEN}Bootable USB drive is ready! You can now safely remove it.${RESET}"
else
    echo ""
    echo "${RED}ERROR: The dd command failed. Check if the ISO path or disk number are correct and try again.${RESET}"
fi

exit 0
