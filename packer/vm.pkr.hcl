packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.2.8"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1.1"
    }
  }
}

variable "ami_image" {
  type    = string
  default = "CentOS Stream 8 x86_64 *,spel-bootstrap-centos-8stream-hvm-*.x86_64-gp*"
}

variable "ami_owner" {
  type    = string
  default = "125523088429"
}

variable "image_name" {
  type    = string
  default = "cloudsheger-workstation"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "region" {
  type    = string
  default = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "aws" {
  ami_description = "${var.image_name} image by jemal"
  ami_name        = "${var.image_name}-${local.timestamp}-app"
  instance_type   = "${var.instance_type}"
  region           = "${var.region}"

  source_ami_filter {
   filters = {
     architecture                       = "x86_64"
     "block-device-mapping.volume-type" = "gp2"
     name                               = "${var.ami_image}"
     root-device-type                   = "ebs"
     virtualization-type                = "hvm"
    }
  most_recent = true
  owners      = ["${var.ami_owner}"]
}
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    encrypted             = false
    iops                  = 120
    volume_size           = 160
    volume_type           = "gp2"
  }
  ssh_username = "maintuser"
  tags = {
    Generator = "Packer ${packer.version}"
    Name      = "${var.image_name}-${local.timestamp}-app"
    Parent    = "${var.ami_image}"
  }
  user_data_file = "./userdata/userdata.cloud"
}

build {
  sources = ["source.amazon-ebs.aws"]

  /*provisioner "ansible" {
    //playbook_file = "../../ansible/app.yml"
    use_proxy     = false
  }*/

}
//"039368651566", # SPEL GovCloud, https://github.com/plus3it/spel