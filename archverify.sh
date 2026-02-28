#!/bin/sh
# Arch Linux verification script

# Aria2 check
if ! command -v aria2c >/dev/null 2>&1; then
	echo -e "You will need to install aria2c to run this script. \n"
	exit 1
fi

# Create "archlinux" directory
echo "Downloading Arch Linux (2026-02-01)"
mkdir -p archlinux
cd archlinux || exit 1
sleep 1
printf "\n"

# Checksum
echo "Downloading sha256sums.txt (if missing)"
sleep 1
wget -nc https://archlinux.org/iso/2026.02.01/sha256sums.txt
printf "\n"

# ISO signature
echo "Downloading archlinux-2026.02.01-x86_64.iso.sig (if missing)"
sleep 1
wget -nc https://archlinux.org/iso/2026.02.01/archlinux-2026.02.01-x86_64.iso.sig
printf "\n"

# Arch Linux ISO
echo "Torrenting Arch Linux ISO..."
aria2c --seed-time=0 --seed-ratio=0 --allow-overwrite=true https://archlinux.org/releng/releases/2026.02.01/torrent/
printf "\n"

# Verification
echo "Verifying..."
sha256sum -c sha256sums.txt
gpg --recv-keys 0x54449A5C
gpg --fingerprint 0x54449A5C
gpg --auto-key-locate clear,wkd -v --locate-external-key pierre@archlinux.org

# Integrity and authenticity of ISO
sha256sum archlinux-*.iso
gpg --verify archlinux-*.iso.sig archlinux-*.iso
printf "\n"
echo "Verification finished!"

# Expected checksum and primary key
echo "Writing to output.txt..."
{
	echo "ISO Verification Summary:"
	echo "Arch Linux (2026.02.01-x86_64.iso)"
	echo "SHA256 checksum: c0ee0dab0a181c1d6e3d290a81ae9bc41c329ecaa00816ca7d62a685aeb8d972"
	echo "Primary key fingerprint: 3E80 CA1A 8B89 F69C BA57  D98A 76A5 EF90 5444 9A5C"
	printf "\n"
} >output.txt
printf "\n"
sleep 1.5

# End
cat output.txt
sleep 2
read -p "Press Enter to quit..."
printf "\n"
exit 0
