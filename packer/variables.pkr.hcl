variable "image" {
  type        = string
  description = "Absolute path to the user-supplied cloud image (.img)."
}

variable "qemu_binary" {
  type        = string
  default     = "qemu-system-aarch64"
  description = "QEMU system emulator binary."
}

variable "efi_firmware_code" {
  type        = string
  default     = "/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
  description = "UEFI firmware code blob for aarch64 guests."
}

variable "efi_firmware_vars" {
  type        = string
  description = "Writable UEFI variable store for the build VM."
}

# Pre-generated key required: ephemeral SSHPublicKey is injected after cd_content render.
# https://github.com/hashicorp/packer-plugin-qemu/issues/182
variable "ssh_private_key_file" {
  type        = string
  description = "Private key matching ssh_public_key for the cloud-init bootstrap user."
}

variable "ssh_public_key" {
  type        = string
  description = "Public key embedded in cloud-init for the bootstrap user."
}

variable "ssh_username" {
  type        = string
  default     = "packer"
  description = "Temporary SSH user created by cloud-init; removed at shutdown."
}

variable "username" {
  type        = string
  default     = "dev"
  description = "Primary user provisioned by Ansible."
}

variable "user_password" {
  type        = string
  default     = "password"
  sensitive   = true
  description = "Login password for the primary user."
}

variable "output_directory" {
  type        = string
  default     = "../output/lxqt"
  description = "Directory for the output qcow2 image."
}

variable "vm_name" {
  type        = string
  default     = "lxqt.qcow2"
  description = "Filename of the output disk image."
}
