build {
  sources = ["source.qemu.ubuntu"]

  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbook.yml"
    user          = var.ssh_username
    use_proxy     = false

    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.root}/../ansible/ansible.cfg",
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]

    extra_arguments = [
      "--become",
      "--extra-vars", "@${var.guest_config}",
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }
}
