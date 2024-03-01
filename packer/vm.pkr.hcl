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

variable "aws_source_ami_filter_centos8stream_hvm" {
  description = "Object with source AMI filters for CentOS Stream 8 HVM builds"
  type = object({
    name   = string
    owners = list(string)
  })
  default = {
    name = "CentOS Stream 8 x86_64 *,spel-bootstrap-centos-8stream-hvm-*.x86_64-gp*"
    owners = [
      "125523088429", # CentOS Commercial, https://wiki.centos.org/Cloud/AWS
      "701759196663", # SPEL Commercial, https://github.com/plus3it/spel
      "039368651566", # SPEL GovCloud, https://github.com/plus3it/spel
      "174003430611", # SPEL Commercial, https://github.com/plus3it/spel
      "216406534498", # SPEL GovCloud, https://github.com/plus3it/spel
    ]
  }
}
variable "aws_ami_groups" {
  description = "List of groups that have access to launch the resulting AMIs. Keyword `all` will make the AMIs publicly accessible"
  type        = list(string)
  default     = []
}

variable "aws_ami_regions" {
  description = "List of regions to copy the AMIs to. Tags and attributes are copied along with the AMIs"
  type        = list(string)
  default     = []
}

variable "aws_ami_users" {
  description = "List of account IDs that have access to launch the resulting AMIs"
  type        = list(string)
  default     = []
}

variable "aws_instance_type" {
  description = "EC2 instance type to use while building the AMIs"
  type        = string
  default     = "t2.micro"
}

variable "aws_force_deregister" {
  description = "Force deregister an existing AMI if one with the same name already exists"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "Name of the AWS region in which to launch the EC2 instance to create the AMIs"
  type        = string
  default     = "us-east-1"
}
variable "spel_identifier" {
  description = "Namespace that prefixes the name of the built images"
  type        = string
  default = "T12-project-id-test"
}

variable "spel_root_volume_size" {
  description = "Size in GB of the root volume"
  type        = number
  default     = 20
}

variable "spel_ssh_username" {
  description = "Name of the user for the ssh connection to the instance. Defaults to `spel`, which is set by cloud-config userdata. If your starting image does not have `cloud-init` installed, override the default user name"
  type        = string
  default     = "maintuser"
}

variable "spel_version" {
  description = "Version appended to the name of the built images"
  type        = string
  default = "dev001"
}
variable "aws_ssh_interface" {
  description = "Specifies method used to select the value for the host in the SSH connection"
  type        = string
  default     = "public_ip"

  validation {
    condition     = contains(["public_ip", "private_ip", "public_dns", "private_dns", "session_manager"], var.aws_ssh_interface)
    error_message = "Variable `aws_ssh_interface` must be one of: public_ip, private_ip, public_dns, private_dns, or session_manager."
  }
}

variable "aws_subnet_id" {
  description = "ID of the subnet where Packer will launch the EC2 instance. Required if using an non-default VPC"
  type        = string
  default     = null
}
variable "aws_security_groups" {
  description = "List of security groups by name to add to this instance"
  type        = list(string)
  //default     = []
  default       = null
}



locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "aws" {
  ami_groups                  = var.aws_ami_groups
  ami_name                    = "linux-centos8-stream-${regex_replace(timestamp(), "[- TZ:]", "")}"
  ami_regions                 = var.aws_ami_regions
  ami_users                   = var.aws_ami_users
  associate_public_ip_address = true
  force_deregister            = var.aws_force_deregister
  instance_type               = var.aws_instance_type
  
  # provisioning connection parameters
  communicator                = "ssh"
  ssh_interface                = "session_manager"
  iam_instance_profile         = "session_manager_packer"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = var.spel_root_volume_size
    volume_type           = "gp3"
  }
  max_retries                           = 20
  region                                = var.aws_region
  //sriov_support                         = true
  //ssh_interface                         = var.aws_ssh_interface
  //ssh_port                                = 22
  ssh_pty                                 = true
  #ssh_timeout                             = "6m"
  ssh_username                          = var.spel_ssh_username
  subnet_id                             = var.aws_subnet_id
  //security_group_id                     = var.aws_security_groups
  tags = {
    Environment     = "prod"
    Name            = "linux-centos8-stream-${regex_replace(timestamp(), "[- TZ:]", "")}"
    PackerBuilt     = "true"
    PackerTimestamp = regex_replace(timestamp(), "[- TZ:]", "")
    Service         = "deployer"
  }

  user_data_file    = "${path.root}/userdata/userdata.cloud"

  source_ami_filter {
      filters = {
        virtualization-type = "hvm"
        name                = var.aws_source_ami_filter_centos8stream_hvm.name
        root-device-type    = "ebs"
      }
      owners      = var.aws_source_ami_filter_centos8stream_hvm.owners
      most_recent = true
    }
}
build {
  sources = ["source.amazon-ebs.aws"]

  provisioner "ansible" {
    user            = var.spel_ssh_username
    playbook_file           = "../app.yml"
    ansible_env_vars        = ["ANSIBLE_PIPELINING=true", "ANSIBLE_SSH_PIPELINING=true"]
    use_proxy               = false
    extra_arguments         = ["--become", "--become-method=sudo"
    ] 
  }

  
}
//"039368651566", # SPEL GovCloud, https://github.com/plus3it/spel