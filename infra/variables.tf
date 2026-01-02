variable "aws_region" {
  description = "The AWS region."
  type        = string
  default     = "us-east-1"
}

variable "managed_by" {
  description = "The deployment manager."
  type        = string
  default     = "Terraform"
}

variable "environment" {
  description = "The deployment environment (prd, qa, dev)."
  type        = string
}

variable "ec2_ami_id" {
  description = "The EC2 AMI ID."
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "ec2_key_pair_name" {
  description = "The EC2 key pair name."
  type        = string
  default     = "demo-ec2-keypair"
}

variable "ec2_instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "github_repo_name" {
  description = "The GitHub repository name."
  type        = string
}

variable "github_repo_pat" {
  description = "The GitHub repository Personal Access Token (PAT)."
  type        = string
}

variable "github_runner_name" {
  description = "The Self-Hosted Runner name."
  type        = string
}

variable "github_runner_labels" {
  description = "The GitHub Runner labels."
  type        = list(string)
}
