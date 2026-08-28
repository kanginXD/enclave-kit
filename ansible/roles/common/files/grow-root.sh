#!/bin/bash
set -euo pipefail

src=$(findmnt -nvo SOURCE /)
[[ -b $src ]] || exit 0

if [[ $src =~ ^(/dev/nvme[0-9]+n[0-9]+)p([0-9]+)$ ]]; then
  disk=${BASH_REMATCH[1]}
  part=${BASH_REMATCH[2]}
elif [[ $src =~ ^(/dev/[a-z]+)([0-9]+)$ ]]; then
  disk=${BASH_REMATCH[1]}
  part=${BASH_REMATCH[2]}
else
  exit 0
fi

growpart "$disk" "$part" || true

fstype=$(findmnt -nvo FSTYPE /)
if [[ $fstype == ext4 || $fstype == ext3 ]]; then
  resize2fs "$src" || true
elif [[ $fstype == xfs ]]; then
  xfs_growfs / || true
fi
