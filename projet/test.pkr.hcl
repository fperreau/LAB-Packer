packer {
  required_plugins {
    hyperv = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hyperv"
    }
  }
}

variable "http_port" {
  type    = number
  default = 8080
}

source "hyperv-iso" "debian13" {
  iso_url            = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
  iso_checksum       = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
  communicator       = "ssh"
  ssh_username       = "packer"
  ssh_password       = "packer"
  ssh_timeout        = "20m"
  shutdown_command   = "shutdown -P now"
  boot_wait          = "10s"
  http_directory     = "http"
  vm_name            = "debian13-packer"
  guest_additions_mode = "disable"

  boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "hostname=debian ",
    "fb=false debconf/frontend=noninteractive ",
    "initrd=/install/initrd.gz --- <enter>"
  ]
}

build {
  sources = ["source.hyperv-iso.debian13"]

  provisioner "shell" {
    inline = [
      "echo 'Provisioning complete!'"
    ]
  }
}