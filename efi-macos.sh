#!/usr/bin/env bash
set -e

printf "\nEFI Unlocker 2.0.0 for VMware Fusion\n"
printf "======================================\n"
printf "(c) Dave Parsons 2018\n\n"
printf "(c) conzurstuff.fyi 2024\n\n"

# Ensure we only use unmodified commands
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

version=`defaults read /Applications/VMware\ Fusion.app/Contents/Info.plist CFBundleShortVersionString`
build=`defaults read /Applications/VMware\ Fusion.app/Contents/Info.plist CFBundleVersion`
IFS='.' read -a product <<< "$version"

printf "VMware product version: ${version}.${build}\n\n"
#printf "Major:    ${product[0]}\n"
#printf "Minor:    ${product[1]}\n"
#printf "Revision: ${product[2]}\n"
#printf "Build:    ${build}\n"

# Check version is 10+
if [[ ${product[0]} -lt 13 ]]; then
   printf "VMware Fusion version 13 or greater required!\n"
   printf "Use the older efi-unlocker for older fusion versions."
   exit 1
fi

printf "Patching 32-bit ROM...\n"
cp -v /Applications/VMware\ Fusion.app/Contents/Library/roms/x86_x64/EFI32.ROM .
./macos/UEFIPatch EFI32.ROM patches.txt -o EFI32-MACOS.ROM
rm -fv EFI32.ROM

printf "\nPatching 64-bit ROM...\n"
cp -v /Applications/VMware\ Fusion.app/Contents/Library/roms/x86_x84/EFI64.ROM .
./macos/UEFIPatch EFI64.ROM patches.txt -o EFI64-MACOS.ROM
rm -fv EFI64.ROM

printf "\nFinished!\n"
