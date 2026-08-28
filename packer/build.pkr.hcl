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
      # Path only. @file extra-vars beat set_fact and keep YAML null as null.
      "--extra-vars", "guest_config=${var.guest_config}",
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }
}
