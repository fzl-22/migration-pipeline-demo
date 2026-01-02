resource "aws_instance" "demo_ec2_bastion_host" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type

  subnet_id                   = aws_subnet.demo_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo_ec2_launch_sg.id, aws_security_group.demo_ec2_to_rds_sg.id]
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair_name

  user_data = templatefile("${path.module}/scripts/bootstrap_ec2_bastion_host.sh", {
    github_repo_name     = var.github_repo_name,
    github_repo_pat      = var.github_repo_pat,
    github_runner_name   = "${var.environment}-demo-bastion-host-runner",
    github_runner_labels = join(",", ["${var.environment}-demo-bastion-host"]),
  })

  user_data_replace_on_change = true

  iam_instance_profile = aws_iam_instance_profile.demo_ec2_instance_profile.name

  tags = {
    Name        = "${var.environment}-demo-ec2-bastion-host"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

# SECURITY GROUPS
resource "aws_security_group" "demo_ec2_launch_sg" {
  name        = "${var.environment}-demo-ec2-launch-sg"
  description = "Allow SSH inbound traffic and all outbound traffic for EC2 instance."
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic."
  }

  tags = {
    Name        = "${var.environment}-demo-ec2-sg"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

resource "aws_security_group" "demo_ec2_to_rds_sg" {
  name        = "${var.environment}-demo-ec2-to-rds-sg"
  description = "Rule to allow connections RDS from any instances this security group is attached to."
  vpc_id      = aws_vpc.demo_vpc.id

  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.demo_rds_to_ec2_sg.id]
  }

  tags = {
    Name        = "${var.environment}-demo-ec2-to-rds-sg"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

resource "aws_security_group" "demo_rds_to_ec2_sg" {
  name        = "${var.environment}-demo-rds-to-ec2-sg"
  description = "Rule to allow connections RDS from any instances this security group is attached to."
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.demo_ec2_launch_sg.id]
  }

  tags = {
    Name        = "${var.environment}-demo-rds-to-ec2-sg"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}
