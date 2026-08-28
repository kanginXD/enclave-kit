source "qemu" "ubuntu" {
  iso_url      = var.image
  iso_checksum = "none"
  disk_image   = true

  vm_name          = var.vm_name
  output_directory = "${path.root}/${var.output_directory}"
  format           = "qcow2"
  skip_resize_disk = !local.resize_disk
  disk_size        = local.resize_disk ? tostring(local.disk_size) : null
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

  # NoCloud via HTTP. Packer cd_content is not usable on aarch64 UEFI.
  http_content = {
    "/user-data" = templatefile("${path.root}/cloud-init/user-data.yml.tftpl", {
      ssh_username   = var.ssh_username
      ssh_public_key = var.ssh_public_key
    })
    "/meta-data" = <<-EOT
      instance-id: enclave
      local-hostname: enclave
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

  # userdel -f: Packer SSH session is still open.
  shutdown_command = "sudo sh -c 'cloud-init clean --logs --seed || true; rm -rf /var/lib/cloud/instances /var/lib/cloud/instance /home/${var.ssh_username}/.ssh; userdel -rf ${var.ssh_username}; shutdown -P now'"
}
