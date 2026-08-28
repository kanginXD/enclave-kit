locals {
  guest       = yamldecode(file(var.guest_config))
  disk_size   = try(local.guest.disk_size, null)
  resize_disk = local.disk_size != null && local.disk_size != ""
}
