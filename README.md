# enclave-kit

Headless VM image builder. Run AI in an isolated guest so the host stays untouched. YOLO mode: give the agent full scope inside the enclave, not on your machine.

## Requires

- macOS (Apple Silicon)
- Packer ≥ 1.14
- QEMU
- Ansible
- arm64 cloud image (`.img`)

## Configure

Copy `config.example.yml` to `config.yml`. Add at least one `ssh_authorized_keys` entry. `password` defaults to `changeme`. Pass another file with `-c`.

## Build

```bash
./scripts/build.sh /path/to/image.img
./scripts/build.sh -c path/to/config.yml /path/to/image.img
./scripts/build.sh -f /path/to/image.img
```

Writes `output/enclave.qcow2`. `-f` replaces that directory.

`EFI_CODE` selects the aarch64 UEFI firmware blob. Default is in `scripts/build.sh`.

## Connect

**Recommended:** put `tailscale` in `tools`, join the guest to a Tailnet, and reach RDP from anywhere on that network.

Forward guest TCP 3389 to the host. Connect with an RDP client (FreeRDP, Microsoft Remote Desktop) as `username` / `password` from the guest config.
