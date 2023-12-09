variable "ami_id" {
  type    = string
  default = "ami-01e78c5619c5e68b4"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_name" {
  type    = string
  default = "httpd"
}

locals {
  app_name = var.app_name
}

source "amazon-ebs" "httpd" {
  ami_name      = "PACKER-DEMO-${local.app_name}"
  instance_type = var.instance_type
  region        = var.region
  source_ami    = var.ami_id
  ssh_username  = "ec2-user"
  tags = {
    Env  = "DEMO"
    Name = "PACKER-DEMO-${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.httpd"]

  provisioner "shell" {
    script = "script/app-init.sh"
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}
