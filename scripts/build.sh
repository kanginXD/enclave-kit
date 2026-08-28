#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "usage: ./scripts/build.sh [-f] [-c config.yml] /path/to/image.img" >&2
  exit 1
}

FORCE=()
CONFIG=
IMAGE=

while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--force)
      FORCE=(-force)
      shift
      ;;
    -c|--config)
      if [[ $# -lt 2 ]]; then
        echo "missing config path" >&2
        usage
      fi
      CONFIG=$2
      shift 2
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage
      ;;
    *)
      if [[ -n $IMAGE ]]; then
        usage
      fi
      IMAGE=$1
      shift
      ;;
  esac
done

if [[ -z $IMAGE ]]; then
  usage
fi

if [[ ! -f $IMAGE ]]; then
  echo "image not found: $IMAGE" >&2
  exit 1
fi

IMAGE_ABS="$(cd "$(dirname "$IMAGE")" && pwd)/$(basename "$IMAGE")"

if [[ -z $CONFIG ]]; then
  CONFIG="$ROOT/config.yml"
fi
if [[ ! -f $CONFIG ]]; then
  if [[ $CONFIG == "$ROOT/config.yml" ]]; then
    echo "missing config.yml; copy config.example.yml to config.yml" >&2
  else
    echo "config not found: $CONFIG" >&2
  fi
  exit 1
fi
CONFIG="$(cd "$(dirname "$CONFIG")" && pwd)/$(basename "$CONFIG")"

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

cd "$ROOT/packer"
packer init .
packer build \
  "${FORCE[@]}" \
  -var "image=${IMAGE_ABS}" \
  -var "efi_firmware_code=${EFI_CODE}" \
  -var "efi_firmware_vars=${EFI_VARS}" \
  -var "ssh_private_key_file=${SSH_KEY}" \
  -var "ssh_public_key=${SSH_PUB}" \
  -var "guest_config=${CONFIG}" \
  .
