# Source, then enclave_firewall_load. Backends define enclave_fw_*.

enclave_firewall_backend() {
  if command -v ufw >/dev/null 2>&1; then
    printf '%s\n' ufw
  elif command -v firewall-cmd >/dev/null 2>&1; then
    printf '%s\n' firewalld
  else
    printf '%s\n' none
  fi
}

enclave_firewall_load() {
  local backend
  backend=$(enclave_firewall_backend)
  case $backend in
    ufw)
      # shellcheck source=/usr/local/lib/enclave/firewall-ufw.sh
      . "${ENCLAVE_LIB}/firewall-ufw.sh"
      ;;
    firewalld)
      echo "enclave: firewalld backend is not implemented" >&2
      return 1
      ;;
    *)
      echo "enclave: no supported host firewall" >&2
      return 1
      ;;
  esac
}
