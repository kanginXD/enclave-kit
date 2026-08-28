ENCLAVE_TAILSCALE_IFACE=${ENCLAVE_TAILSCALE_IFACE:-tailscale0}

enclave_tailscale_iface_present() {
  ip link show "$ENCLAVE_TAILSCALE_IFACE" >/dev/null 2>&1
}

enclave_tailscale_connected() {
  command -v tailscale >/dev/null 2>&1 || return 1
  tailscale status --json 2>/dev/null | python3 -c '
import json, sys

try:
    status = json.load(sys.stdin)
except Exception:
    print("enclave: could not parse tailscale status --json", file=sys.stderr)
    sys.exit(1)

if status.get("BackendState") != "Running":
    print("enclave: Tailscale is not Running", file=sys.stderr)
    sys.exit(1)
if not status.get("CurrentTailnet"):
    print("enclave: not connected to a tailnet", file=sys.stderr)
    sys.exit(1)
if not status.get("TUN"):
    print("enclave: Tailscale is not using a kernel TUN interface", file=sys.stderr)
    sys.exit(1)
if not status.get("TailscaleIPs"):
    print("enclave: no Tailscale IP assigned", file=sys.stderr)
    sys.exit(1)
'
}

enclave_ip_on_tailnet() {
  local ip
  ip=$(
    python3 - "$1" <<'PY'
import ipaddress, sys

addr = ipaddress.ip_address(sys.argv[1])
mapped = getattr(addr, "ipv4_mapped", None)
print(mapped if mapped is not None else addr)
PY
  )
  tailscale whois "$ip" >/dev/null 2>&1
}
