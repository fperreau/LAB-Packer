
variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "21440"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:B23488689E16CAD7A269EB2D3A3BF725D3457EE6B0868E00C8762D3816E25848"
}

variable "iso_url" {
  type    = string
  default = "http://releases.ubuntu.com/16.04/ubuntu-16.04.7-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "vm_name" {
  type    = string
  default = "ubuntu-xenial"
}

source "hyperv-iso" "xenial" {
  boot_command         = [
    "<esc><wait10><esc><esc><enter><wait>",
    "set gfxpayload=1024x768<enter>",
    "linux /install/vmlinuz ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=fr ",
    "hostname={{ .Name }} fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=FR ",
    "keyboard-configuration/variant=FR console-setup/ask_detect=false <enter>",
    "initrd /install/initrd.gz<enter>",
    "boot<enter>"
  ]
  boot_wait            = "5s"
  communicator         = "ssh"
  cpus                 = "${var.cpus}"
  disk_size            = "${var.disk_size}"
  enable_secure_boot   = false
  generation           = 2
  guest_additions_mode = "disable"
  http_directory       = "http"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  shutdown_command     = "echo 'packer' | sudo -S -E shutdown -P now"
  ssh_username         = "packer"
  ssh_password         = "packer"
  ssh_timeout          = "4h"
  switch_name          = "Default Switch"
  vm_name              = "${var.vm_name}"
}

build {
  sources = ["source.hyperv-iso.xenial"]
}
