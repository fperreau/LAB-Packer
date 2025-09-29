variable "disk_size" {
  type = number
  default = 25600
}

variable "vm_memory" {
  type = number
  default = 4096
}

variable "vm_cpu" {
  type = number
  default = 2
}

variable "iso_url" {
  type = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type = string
  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
}

variable "vm_name" {
  type = string
  default = "debian-trixie"
}

packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}

source "hyperv-iso" "debian-trixie" {
  type = "hyperv-iso"
  boot_command = [
    "<esc><wait>",
    "auto<wait>",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed24.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]
  boot_wait            = "5s"
  communicator         = "ssh"
  cpus                 = var.vm_cpu
  disk_size            = var.disk_size
  enable_secure_boot   = false
  generation           = 2
  guest_additions_mode = "disable"
  http_directory       = "http"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = var.vm_memory
  shutdown_command     = "echo 'packer' | sudo -S -E shutdown -P now"
  ssh_username         = "packer"
  ssh_password         = "packer"
  ssh_timeout          = "4h"
  switch_name          = "Default Switch"
}

build {
  sources = ["source.hyperv-iso.debian-trixie"]
}
