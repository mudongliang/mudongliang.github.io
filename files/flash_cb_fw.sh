#!/bin/bash
#
# Script to flash custom firmware to Intel chipset based Chromebooks
#

readonly URL_PREFIX=https://johnlewis.ie/Chromebook-ROMs
readonly MAINTENANCE=no
declare FLASHROM_CMD MODEL AREA R_OR_W LEGACY_FILE
readonly OPTION_1="
1. Modify my Chromebook's RW_LEGACY slot.
"
readonly OPTION_2="
2. Modify my Chromebook's BOOT_STUB slot.
"
readonly OPTION_3="
3. Restore my Chromebook's BOOT_STUB slot back to stock.
"
readonly OPTION_4="
4. Backup RO_VPD and GBB slots to $HOME/Downloads (you should do this 
     before flashing a full ROM, then copy the files to a *SAFE* place).
"
readonly OPTION_5="
5. Flash a full ROM to my Chromebook.
"
readonly OPTION_6="
6. Flash a full shellball ROM to my Chromebook (remember alternative OS will 
     no longer boot and RO_VPD + GBB slots will need to be restored to go 
     completely back to stock).
"
readonly OPTION_7="
7. Restore RO_VPD and GBB slots. (you should do this after flashing a shellball
     ROM. The script expects rovpd.bin and gbb.bin are in $HOME/Downloads).
"

download () {
  curl -# -O "$URL_PREFIX"/"$1" || err "
ERROR: $1 could not be downloaded. Please try again later.
"
}

rm_files () {
  rm -rf /tmp/flash.crbk.rom
}

disable_wp () {
  sudo "$FLASHROM_CMD" --wp-disable || err "
ERROR: Software write-protect could not be disabled. This usually means hardware
write-protect is still enabled. Please check, and try again.
"
}

write_boot_stub () {
  download shellballs/"$2"/"$1".tar.bz2
  download shellballs/"$2"/"$2".md5
  check_md5 "$1".tar.bz2 "$2".md5
  tar -xjf "$1".tar.bz2
  disable_wp
  acceptance
  sudo "$FLASHROM_CMD" -w -i BOOT_STUB:"$1" || err "
ERROR: BOOT_STUB could not be written. This is usually because a custom firmware
without flashmap has previously been written to the device. You may need to 
flash a shellball ROM and restore your product/GBB data
"
}

update_legacy_slot () {
  download legacy-slots/"$LEGACY_FILE"-latest.cbfs.tar.bz2
  download legacy-slots/legacy-slots.md5
  check_md5 "$LEGACY_FILE"-latest.cbfs.tar.bz2 legacy-slots.md5
  tar -xjf "$LEGACY_FILE"-latest.cbfs.tar.bz2
  acceptance
  sudo "$FLASHROM_CMD" -w -i RW_LEGACY:"$LEGACY_FILE"-latest.cbfs || err "
ERROR: Failed to write legacy slot. Your slot may be in an inconsistent state. 
If you're relying on the slot for access to a currently installed operating 
system, it probably wouldn't be a good idea to reboot.
"
}

check_md5 () {
  local file
  local md5_file
  local download_md5
  local md5
  file="$(echo $1 | awk -F '/' '{print $NF}')"
  md5_file="$(echo $2 | awk -F '/' '{print $NF}')"
  download_md5="$(md5sum "$file" | awk '{print $1}')"
  md5="$(grep $file $md5_file | awk '{print $1}')"
  md5="$(echo $md5 | awk '{print $1}')"
  if [[ "$download_md5" != "$md5" ]]; then
    err "
ERROR: MD5's for $1 don't match. Please try again later.
"
  fi
}

flash_whole_rom () {
  local STANDARD_ERR
  local file
  file="$(echo $1 | awk -F '/' '{print $NF}')"
  download "$1".tar.bz2
  download $2
  check_md5 "$1".tar.bz2 $2
  tar -xjf "$file".tar.bz2
  disable_wp
  acceptance
  STANDARD_ERR="flashrom@flashrom.org|IRC|Erasing and writing flash chip..."
  STANDARD_ERR+=" spi_block_erase_20 failed during command execution at"
  STANDARD_ERR+=" address 0x0|Verifying flash... VERIFY FAILED at"
  STANDARD_ERR+=" 0x00000062! Expected=0xff, Read=0x0b, failed byte count"
  STANDARD_ERR+=" from 0x00000000-0x007fffff: 0x4|Your flash chip is in an"
  STANDARD_ERR+=" unknown state.|DO NOT REBOOT OR POWEROFF!|FAILED"
  readonly STANDARD_ERR
  sudo "$FLASHROM_CMD" -w "$file" 2>&1 | egrep -v "$STANDARD_ERR"
  echo "
INFO: Assuming you didn't get any errors you may reboot. Otherwise, do not 
reboot under ANY circumstances, and post a comment @
https://johnlewis.ie/custom-chromebook-firmware/rom-download/
" 
  rm_files
  exit 0
}

acceptance () {
  local accept
  read -p "
INPUT REQUIRED: About to flash your $MODEL's $AREA, repeat 
'If this bricks my $MODEL, on my head be it!' observing exact case 
and punctuation: " accept
  echo ""
  if [[ "$accept" != "If this bricks my $MODEL, on my head be it!" ]]; then
    err "
ERROR: You have failed to enter the phrase correctly, and your $MODEL 
will not be flashed. Please rerun the script using the previous command if 
this was not your intention.
" 
  fi
}

unsupported_message () {
  err "
ERROR: $MODEL is not currently supported at all using this script. 
If you feel this should not be the case please post a comment @ 
https://johnlewis.ie/custom-chromebook-firmware/rom-download/
"
}

backup_prod_data () {
  if [[ ! -e $HOME/Downloads/$1 ]]; then
    sudo "$FLASHROM_CMD" -r -i "$2":"$HOME"/Downloads/"$1" || err "
ERROR: Something went wrong. Perhaps you're running a custom ROM without RO_VPD 
and GBB areas in?
"
  else
    err "
ERROR: $HOME/Downloads/$1 already exists, NOT overwriting.
"
  fi
}

restore_prod_data () {
  if [[ -e "$HOME"/Downloads/"$1" ]]; then
    sudo "$FLASHROM_CMD" -w -i "$2":"$HOME"/Downloads/"$1" || err "
ERROR: Something went wrong. Perhaps you're running a custom ROM without RO_VPD
and GBB areas in?
"
  else
    err "
ERROR: $HOME/Downloads/$1 does not exist. Perhaps you need to copy it here.
"
  fi
}

err() {
  echo "$@" >&2
  rm_files
  exit 1
}

ctrl_c() {
  echo "

INFO: Script cancelled by user, exiting ...
"
  rm_files
  exit 0
}

get_flashrom() {
  FLASHROM_CMD="/tmp/flash.crbk.rom/flashrom"
  download utils/flashrom.tar.bz2
  download utils/utils.md5
  check_md5 flashrom.tar.bz2 utils.md5
  tar -xjf flashrom.tar.bz2
  chmod +x flashrom
}

main() {
trap ctrl_c INT

if [[ "$MAINTENANCE" = "yes" ]]; then
  err "
ERROR: This script is currently in maintenance mode. Please be patient whilst 
things are being updated.

Go tell someone significant that you love them, perhaps make yourself a nice 
meal, or otherwise occupy yourself with something constructive, and normal
service will be resumed in the coming hours.
"
fi

which sudo 2>/dev/null || err "
ERROR: This script requires that sudo is installed, please install it using
your distro's package manager.
"  

sudo which dmidecode 2>/dev/null || err "
ERROR: This script requires that dmidecode is installed, please install it 
using your distro's package manager.
"

which tar 2>/dev/null || err "
ERROR: This script requires that tar is installed, please install it using 
your distro's package manager.
"

which bzip2 2>/dev/null || err "
ERROR: This script requires that tar is installed, please install it using 
your distro's package manager.
"


MODEL="$(sudo dmidecode \
  |grep -m1 "Product Name:" \
  | awk '{print $3}' \
  | tr '[:upper:]' '[:lower:]')"
readonly MODEL

clear
echo "
Greetings weary traveller!

As well as the costs of infrastructure for building and serving ROM’s, I would 
also like donation toward an example of each chipset of Chromebook. If you have 
benefited from my work, or want to see an Intel Chromebook supported by the 
script/firmware which isn’t currently (no guarantee that a particular type of 
mod will be supported, but I endeavour to get something that works), please 
consider making a donation using one of the buttons in the sidebar.

Please note: regardless of donation, I do not provide support for putting 
Windows on Chromebooks, as a matter of choice.
" 
read -p "Thank you, press [Enter] to continue: "
clear

echo "
What would you like to do? (note: options will be hidden based on model)"

case $MODEL in
parrot|stout|butterfly)
  echo "$OPTION_3""$OPTION_4""$OPTION_5""$OPTION_6""$OPTION_7"
  ;;
lumpy|stumpy)
  echo "$OPTION_4""$OPTION_5""$OPTION_6""$OPTION_7"
  ;;
link|falco|peppy|panther|zako|wolf|leon|monroe)
  echo "$OPTION_1""$OPTION_3""$OPTION_4""$OPTION_5""$OPTION_6"\
    "$OPTION_7"
  LEGACY_FILE="legacy-seabios"
  ;;
leon)
  echo "$OPTION_1""$OPTION_3""$OPTION_4""$OPTION_7"
  LEGACY_FILE="legacy-seabios"
  ;;
clapper|squawks|quawks|swanky)
  echo "$OPTION_1""$OPTION_3"
  LEGACY_FILE="legacy-seabios-baywell"
  ;;
kip|candy|gnawty|enguarde|glimmer|winky|banjo|orco)
  echo "$OPTION_1""$OPTION_2""$OPTION_3"
  LEGACY_FILE="legacy-seabios-baywell"
  ;;
auron_paine|auron_yuna|samus|guado|rikku|mccloud|lulu|tidus|tricky|gandof|caroline|sentry|cave|eve|nami)
  echo "$OPTION_1"
  LEGACY_FILE="legacy-seabios"
  ;;
cyan|celes|edgar|reks|banon|terra|kefka|relm|setzer|wizpig|ultima)
  echo "$OPTION_1"
  LEGACY_FILE="legacy-seabios-baywell"
  ;;
*)
  unsupported_message
  ;;
esac

read -p "Please choose: " userinput
clear

mkdir /tmp/flash.crbk.rom || err "
ERROR: Could not create /tmp/flash.crbk.rom Quitting.
"

cd /tmp/flash.crbk.rom || err "
ERROR: Could not change directory to /tmp/flash.crbk.rom Quitting.
"

if sudo test -f /usr/bin/crossystem; then
  FLASHROM_CMD="flashrom"
else
  get_flashrom
fi

readonly FLASHROM_CMD

case "$userinput" in
  1)
    AREA="RW_LEGACY slot"
    R_OR_W="was written"
    update_legacy_slot
    ;;
  2)
    AREA="BOOT_STUB slot"
    R_OR_W="was written"
    write_boot_stub bios.cbfs.new "$MODEL"
    ;;
  3)
    AREA="BOOT_STUB slot"
    R_OR_W="was written"
    write_boot_stub bios.cbfs "$MODEL"
    ;;
  4)
    AREA="RO_VPD and GBB slots"
    R_OR_W="were read"
    if [[ -d "$HOME"/Downloads ]]; then
      backup_prod_data rovpd.bin RO_VPD
      backup_prod_data gbb.bin GBB
      echo "
INFO: Ensure you save $HOME/Downloads/rovpd.bin and 
$HOME/Downloads/gbb.bin to removable media before wiping this OS!
"
    else
      err "
ERROR: $HOME/Downloads doesn't exist, please create and try again.
"
    fi
      ;;
  5)
    AREA="entire ROM"
    R_OR_W="was written"
    flash_whole_rom "$MODEL"/coreboot-"$MODEL"-seabios-latest.rom \
    "$MODEL"/"$MODEL".md5
    ;;
  6)
    AREA="entire ROM"
    R_OR_W="was written"
    flash_whole_rom shellballs/"$MODEL"/bios.bin \
    shellballs/"$MODEL"/"$MODEL".md5 
    ;;
  7)
    AREA="RO_VPD and GBB slots"
    R_OR_W="were written"
    restore_prod_data rovpd.bin RO_VPD
    restore_prod_data gbb.bin GBB
    ;;
  *)
    err "ERROR: Invalid option chosen, exiting ...
"
    ;;
esac
readonly AREA
readonly R_OR_W

echo "
INFO: Good, your $MODEL's $AREA $R_OR_W successfully.
You can hopefully, safely reboot!
"
rm_files
exit 0
}

main $@
