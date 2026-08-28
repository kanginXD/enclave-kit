# enclave-kit

LXQt desktop qcow2 image builder.

## Requires

- macOS (Apple Silicon)
- Packer ≥ 1.14
- QEMU
- Ansible
- arm64 cloud image (`.img`)

## Build

```bash
./scripts/build.sh /path/to/image.img
```

Output: `output/lxqt/lxqt.qcow2`

Env: `EFI_CODE`, `USERNAME`, `USER_PASSWORD` — defaults in `scripts/build.sh`.
