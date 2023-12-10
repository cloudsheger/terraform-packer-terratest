packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
  }
  vagrant = {
        version = ">= 1.1.1"
        source = "github.com/hashicorp/vagrant"
    }
  }
}
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ami_name" {
  type    = string
  default = "ubuntu-packer"
}
variable "ami_prefix" {
  type    = string
  default = "ubuntu-packer"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

source "amazon-ebs" "ubuntu-focal" {
  ami_name      = "${var.ami_prefix}-focal-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu",
    "source.amazon-ebs.ubuntu-focal"
    ]
  provisioner "shell" {
    script = "script/bootstrap.sh"
  }
  post-processors {
  post-processor "vagrant" {}
  post-processor "compress" {}
}
}
