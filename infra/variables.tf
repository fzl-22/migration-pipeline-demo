variable "aws_region" {
  description = "The AWS region."
  type        = string
  default     = "us-east-1"
}

# variable "aws_access_key" {
#   description = "The AWS access key."
#   type        = string
#   default     = null
# }

# variable "aws_secret_key" {
#   description = "The AWS secret key."
#   type        = string
#   default     = null
# }

variable "managed_by" {
  description = "The deployment manager."
  type        = string
  default     = "Terraform"
}

variable "ec2_ami_id" {
  description = "The EC2 AMI ID."
  type        = string
}

variable "ec2_key_pair_name" {
  description = "The EC2 key pair name."
  type        = string
}

variable "ec2_instance_type" {
  description = "The EC2 instance type."
  type        = string
}

variable "github_repo_name" {
  description = "The GitHub repository name."
  type        = string
  default     = null
}

variable "github_repo_pat" {
  description = "The GitHub repository Personal Access Token (PAT)."
  type        = string
  default     = null
}
