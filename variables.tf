# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami_id" {
  description = "The ID of the AMI to run on each EC2 Instance. Should be an AMI built from the Packer templates in examples/packer-docker-example (build.json or build.pkr.hcl)."
  type        = string
  default = "ami-00a5b6ddc7a83f6e1"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "The Name tag to set for the EC2 Instance."
  type        = string
  default     = "terratest-example"
}

variable "instance_port" {
  description = "The port the EC2 Instance should listen on for HTTP requests."
  type        = number
  default     = 8080
}

variable "instance_text" {
  description = "The text the EC2 Instance should return when it gets an HTTP request."
  type        = string
  default     = "Hello, World!"
}

variable "instance_type" {
  description = "The EC2 instance type to run."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The EC2 instance type to run."
  type        = string
  default     = "cloudsheger"
}