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
  default = "debian-hyperv"
}

packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}

locals {
  version = formatdate("YYYY.MM.DD", timestamp())
}

source "hyperv-iso" "debian-trixie" {
  iso_url               = var.iso_url
  iso_checksum          = var.iso_checksum
  iso_target_path       = "../iso"
  output_directory      = "../out"
  boot_wait             = "10s"
  vm_name               = var.vm_name
  switch_name           = "Default Switch"
  disk_block_size       = 1
  disk_size             = var.disk_size
  cpus                  = var.vm_cpu
  memory                = var.vm_memory
  enable_dynamic_memory = true
  generation            = 2
  enable_secure_boot    = false
  http_directory        = "http"
  boot_command = [
    "<esc><wait>",
    "auto<wait>",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " linux /install/vmlinuz",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]
  shutdown_command      = "echo 'packer' | sudo -S -E shutdown -P now"
  communicator          = "ssh"
  ssh_username          = "packer"
  ssh_password          = "packer"
  ssh_timeout           = "60m"
}

build {
  name = var.vm_name
  sources = ["source.hyperv-iso.debian-trixie"]
}
