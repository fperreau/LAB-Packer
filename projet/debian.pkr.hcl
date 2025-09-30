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
  default = "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-13.1.0-amd64-standard.iso"
# default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type = string
  default = "sha256:74D637FC3C368733B1529270A7FDFD382CB711FA02F709BB7DE26D4FCED80104"
#  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
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

locals {
  version = formatdate("YYYY.MM.DD", timestamp())
}

source "hyperv-iso" "debian-trixie" {

  boot_command = [
    "<down><down><enter><wait>",
    "<down><down><down><down><down><enter><wait30>",
    "http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<enter>"
  ]

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
  shutdown_command      = "echo 'packer' | sudo -S -E shutdown -P now"
  communicator          = "ssh"
  ssh_username          = "root"
  ssh_password          = "debianrootpassword"
  ssh_timeout           = "60m"
}

build {
  sources = ["source.hyperv-iso.debian-trixie"]
}
