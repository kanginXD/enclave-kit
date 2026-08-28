enclave_fw_enable() {
  ufw --force enable
}

enclave_fw_default_deny_incoming() {
  ufw default deny incoming
}

enclave_fw_default_allow_outgoing() {
  ufw default allow outgoing
}

enclave_fw_allow_in_on_iface() {
  ufw allow in on "$1"
}

enclave_fw_delete_allow_port() {
  local port=$1
  local proto=${2:-tcp}
  ufw --force delete allow "${port}/${proto}" >/dev/null 2>&1 || true
}

enclave_fw_drop_allows_except_iface() {
  local iface=$1
  local line num
  local changed=1
  while [[ $changed -eq 1 ]]; do
    changed=0
    while IFS= read -r line; do
      [[ $line =~ ^\[([[:space:]]*[0-9]+)\] ]] || continue
      num=${BASH_REMATCH[1]// /}
      [[ $line == *ALLOW* || $line == *LIMIT* ]] || continue
      [[ $line == *" on ${iface}"* ]] && continue
      ufw --force delete "$num"
      changed=1
      break
    done < <(LC_ALL=C ufw status numbered)
  done
}

enclave_fw_reload() {
  ufw reload
}
