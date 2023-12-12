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