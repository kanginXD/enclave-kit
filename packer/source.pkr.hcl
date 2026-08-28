source "qemu" "ubuntu" {
  iso_url      = var.image
  iso_checksum = "none"
  disk_image   = true

  vm_name          = var.vm_name
  output_directory = "${path.root}/${var.output_directory}"
  format           = "qcow2"
  disk_size        = "40G"
  disk_interface   = "virtio"
  net_device       = "virtio-net"

  qemu_binary  = var.qemu_binary
  accelerator  = "hvf"
  machine_type = "virt"
  cpu_model    = "host"
  cpus         = 4
  memory       = 4096
  headless     = true

  efi_boot          = true
  efi_firmware_code = var.efi_firmware_code
  efi_firmware_vars = var.efi_firmware_vars
  efi_drop_efivars  = false

  # NoCloud over HTTP (SMBIOS serial ds=nocloud). cidata CD + cd_content fails on aarch64 UEFI.
  # https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html
  http_content = {
    "/user-data" = templatefile("${path.root}/cloud-init/user-data.yml.tftpl", {
      ssh_username   = var.ssh_username
      ssh_public_key = var.ssh_public_key
    })
    "/meta-data" = <<-EOT
      instance-id: lxqt
      local-hostname: dev-lxqt
    EOT
  }

  qemuargs = [
    ["-smbios", "type=1,serial=ds=nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"],
  ]

  ssh_username              = var.ssh_username
  ssh_private_key_file      = var.ssh_private_key_file
  ssh_timeout               = "30m"
  ssh_handshake_attempts    = 100
  ssh_clear_authorized_keys = true
  boot_wait                 = "15s"

  # cloud-init clean, remove packer user (-f: SSH session active), power off.
  shutdown_command = "sudo sh -c 'cloud-init clean --logs --seed || true; rm -rf /var/lib/cloud/instances /var/lib/cloud/instance /home/${var.ssh_username}/.ssh; userdel -rf ${var.ssh_username}; shutdown -P now'"
}
