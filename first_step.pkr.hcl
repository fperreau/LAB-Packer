packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:noble"
  commit = true
}

build {
  name    = "learn-packer"
  sources = ["source.docker.ubuntu"]
  post-processor "docker-save" {
    path = "foo.tar"
  }
}
