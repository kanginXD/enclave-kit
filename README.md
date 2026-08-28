# enclave-kit

LXQt desktop qcow2 image builder.

## Requires

- macOS (Apple Silicon)
- Packer ≥ 1.14
- QEMU
- Ansible
- arm64 cloud image (`.img`)

## Configure

Copy `config.example.yml` to `config.yml`. Set `username`, optional `password`,
and `ssh_authorized_keys` (OpenSSH public keys for the guest user).

Empty or omitted `password` creates the account with password auth locked and
passwordless sudo. SDDM autologin does not require a password.

## Build

```bash
./scripts/build.sh /path/to/image.img
./scripts/build.sh -f /path/to/image.img
```

Output: `output/lxqt/lxqt.qcow2`. `-f` overwrites that directory.

Env: `EFI_CODE` — default in `scripts/build.sh`.
