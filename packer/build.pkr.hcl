variable "aws_region" {
  default = "us-east-1"
}

variable "ami_name_base" {
  default = "terratest-packer-docker-example"
}

variable "instance_type" {
  default = "t2.micro"
}

source "amazon-ebs" "ubuntu-ami" {
  ami_name        = "${var.ami_name_base}-{{timestamp}}"
  instance_type   = var.instance_type
  region          = var.aws_region
  ssh_username    = "ubuntu"
  source_ami_filter {
    filters = {
      virtualization-type                = "hvm"
      architecture                       = "x86_64"
      name                               = "*ubuntu-jammy-22.04-amd64-server-*"
      "block-device-mapping.volume-type" = "gp2"
      "root-device-type"                 = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu-ami"]

  post-processor "docker-tag" {
    repository = "gruntwork/packer-docker-example"
    tag        = ["latest"]
    only       = ["ubuntu-docker"]
  }
}

builder "docker" {
  name    = "ubuntu-docker"
  type    = "docker"
  image   = "gruntwork/ubuntu-test:22.04"
  commit  = true
  changes = ["ENTRYPOINT [\"\"]"]
}

provisioner "shell" {
  type    = "shell"
  inline  = ["echo 'Sleeping for a few seconds to give Ubuntu time to boot up'", "sleep 30"]
  only    = ["source.amazon-ebs.ubuntu-ami"]
}

provisioner "file" {
  type        = "file"
  source      = "{{template_dir}}"
  destination = "/tmp/packer-docker-example"
}

provisioner "shell" {
  type   = "shell"
  inline = ["/tmp/packer-docker-example/configure-sinatra-app.sh"]
}
