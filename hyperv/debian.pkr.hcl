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
<<<<<<< HEAD
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
=======
#  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
  default = "file://home/perreau/iso/FredericPerreau/Downloads/debian-13.1.0-amd64-netinst.iso"
>>>>>>> aaebaf93e251d46c54efff75fc195b15d6ad2d88
}

variable "iso_checksum" {
  type = string
  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
}

variable "vm_name" {
  type = string
  default = "debian"
}

variable "vm_domain" {
  type = string
  default = "local"
}

variable "vm_switch" {
  type = string
  default = "Default Switch"
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
     "<esc>c<wait>",
     "linux /install.amd/vmlinuz auto=true priority=critical ",
     "vga=1024 locale=en_US country=FR keymap=fr ",
     "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
     "hostname={{ .Name }} --- quiet<enter>",
     "initrd /install.amd/initrd.gz<enter>",
     "boot<enter><wait>"
   ]
  iso_url               = var.iso_url
  iso_checksum          = var.iso_checksum
  output_directory      = "build"
  boot_wait             = "10s"
  vm_name               = var.vm_name
  switch_name           = var.vm_switch
  disk_block_size       = 1
  disk_size             = var.disk_size
  cpus                  = var.vm_cpu
  memory                = var.vm_memory
  enable_dynamic_memory = true
  generation            = 2
  enable_secure_boot    = false
  http_directory        = "http"
#  shutdown_command      = "echo 'cendar' | sudo -S -E shutdown -P now"
  shutdown_command      = "shutdown -P now"
  communicator          = "ssh"
  ssh_username          = "root"
  ssh_password          = "cendar"
  ssh_timeout           = "60m"
}

build {
  sources = ["source.hyperv-iso.debian-trixie"]

#  provisioner "ansible" {
#    playbook_file = "./playbook.yml"
#   extra_arguments = [
#     "--extra-vars", "ansible_become_method=su"
#   ]
#  }

}
