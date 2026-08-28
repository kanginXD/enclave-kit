# enclave-kit

Headless VM image builder. Isolate the environment, unleash the agent.

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

Put `tailscale` in `tools`. On the guest, `sudo tailscale up`, then SSH or RDP to the Tailscale address.

To reach RDP from the host, forward guest TCP 3389 and connect as `username` / `password` from the guest config.

## Utilities

Guest commands in `/usr/local/bin`.

### tailscale-lock-down

```bash
sudo tailscale-lock-down
```

Requires Tailscale to be connected. Allows inbound traffic only on the Tailscale interface. SSH listen ports come from `sshd`. `--force` skips the SSH-client tailnet check.
