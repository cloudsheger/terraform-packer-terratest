# Variables
variable "packer_template_s3_bucket_location" {
  type        = string
  description = "Enter the name of the bucket where the packer templates will be stored. For example, my-packer-bucket"
}

# IAM Role
resource "aws_iam_role" "ssm_automation_packer_role" {
  name               = data.aws_iam_role.example
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = {
        Service = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  ]
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ssm_automation_packer_instance_profile" {
  name = "SSMAutomationPackerInstanceProfile"

  role = aws_iam_role.ssm_automation_packer_role.name
}

# IAM Policy - Inline
resource "aws_iam_policy" "ssm_automation_packer_inline_policy" {
  name        = "SSMAutomationPackerInline"
  description = "Policy for Packer automation using SSM"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:GetInstanceProfile"
        Resource = "arn:aws:iam::*:instance-profile/*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogStream", "logs:DescribeLogGroups"]
        Resource = "arn:aws:logs:*:*:log-group:*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::${var.packer_template_s3_bucket_location}"
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.packer_template_s3_bucket_location}/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ec2:DescribeInstances",
          "ec2:CreateKeyPair",
          "ec2:DescribeRegions",
          "ec2:DescribeVolumes",
          "ec2:DescribeSubnets",
          "ec2:DeleteKeyPair",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      },
    ]
  })
}

# IAM Policy - Passrole
resource "aws_iam_policy" "ssm_automation_packer_passrole_policy" {
  name        = "SSMAutomationPackerPassrole"
  description = "Policy for passing roles for Packer automation"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Sid       = "SSMAutomationPackerPassrolePolicy"
      Effect    = "Allow"
      Action    = "iam:PassRole"
      Resource  = aws_iam_role.ssm_automation_packer_role.arn
    }]
  })
}
