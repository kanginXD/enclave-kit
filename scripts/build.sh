#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ $# -ne 1 ]]; then
  echo "usage: ./scripts/build.sh /path/to/image.img" >&2
  exit 1
fi

IMAGE=$1

if [[ ! -f $IMAGE ]]; then
  echo "image not found: $IMAGE" >&2
  exit 1
fi

IMAGE_ABS="$(cd "$(dirname "$IMAGE")" && pwd)/$(basename "$IMAGE")"

EFI_CODE="${EFI_CODE:-/opt/homebrew/share/qemu/edk2-aarch64-code.fd}"
if [[ ! -f $EFI_CODE ]]; then
  echo "UEFI firmware not found: $EFI_CODE" >&2
  echo "set EFI_CODE to edk2-aarch64-code.fd from your QEMU install" >&2
  exit 1
fi

CACHE="$ROOT/packer/.cache"
mkdir -p "$CACHE"

EFI_VARS="$CACHE/edk2-aarch64-vars.fd"
if [[ ! -f $EFI_VARS ]]; then
  dd if=/dev/zero of="$EFI_VARS" bs=1048576 count=64 status=none
fi

# Pre-generated keypair; see packer/variables.pkr.hcl (ssh_private_key_file).
SSH_DIR="$(mktemp -d "${TMPDIR:-/tmp}/packer-ssh.XXXXXX")"
cleanup() {
  rm -rf "$SSH_DIR"
}
trap cleanup EXIT

SSH_KEY="$SSH_DIR/packer_ed25519"
ssh-keygen -t ed25519 -N "" -f "$SSH_KEY" -C "packer-build" >/dev/null
SSH_PUB="$(tr -d '\n' <"${SSH_KEY}.pub")"

USERNAME="${USERNAME:-dev}"
USER_PASSWORD="${USER_PASSWORD:-password}"

cd "$ROOT/packer"
packer init .
packer build \
  -var "image=${IMAGE_ABS}" \
  -var "efi_firmware_code=${EFI_CODE}" \
  -var "efi_firmware_vars=${EFI_VARS}" \
  -var "ssh_private_key_file=${SSH_KEY}" \
  -var "ssh_public_key=${SSH_PUB}" \
  -var "username=${USERNAME}" \
  -var "user_password=${USER_PASSWORD}" \
  .
