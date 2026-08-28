# enclave-kit

LXQt desktop qcow2 image builder.

## Requires

- macOS (Apple Silicon)
- Packer ≥ 1.14
- QEMU
- Ansible
- arm64 cloud image (`.img`)

## Configure

Copy `config.example.yml` to `config.yml` (or another `*.yml`). Default path:
`config.yml` at the repo root. Override with `-c`.

- `username`, optional `password`, `ssh_authorized_keys`
- `packages`: extra apt package names (empty or omitted installs none)
- `tools`: `cursor`, `claude`, `tailscale` (empty or omitted installs none)
- `desktop`: `lxqt` (empty or omitted installs no desktop)

Empty or omitted `password` creates the account with password auth locked and
passwordless sudo. SDDM autologin does not require a password.

## Build

```bash
./scripts/build.sh /path/to/image.img
./scripts/build.sh -c server.config.yml /path/to/image.img
./scripts/build.sh -f /path/to/image.img
```

Output: `output/enclave.qcow2`. `-f` overwrites that directory.

Env: `EFI_CODE` — default in `scripts/build.sh`.
