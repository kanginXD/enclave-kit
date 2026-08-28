enclave_ssh_listen_ports() {
  local sshd ports
  if command -v sshd >/dev/null 2>&1; then
    sshd=$(command -v sshd)
  elif [[ -x /usr/sbin/sshd ]]; then
    sshd=/usr/sbin/sshd
  else
    echo "enclave: sshd not found" >&2
    return 1
  fi
  ports=$(
    "$sshd" -T | awk '
      tolower($1) == "port" { print $2; next }
      tolower($1) == "listenaddress" {
        a = $2
        if (a ~ /^\[.*\]:[0-9]+$/) {
          sub(/.*\]:/, "", a)
          print a
        } else if (a ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$/) {
          sub(/.*:/, "", a)
          print a
        }
      }
    ' | sort -nu
  )
  if [[ -z $ports ]]; then
    echo "enclave: sshd reported no listen ports" >&2
    return 1
  fi
  printf '%s\n' "$ports"
}
