resource "tls_private_key" "demo_ec2_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo_ec2_key_pair" {
  key_name   = var.ec2_keypair_name
  public_key = tls_private_key.demo_ec2_key_pair.public_key_openssh

  tags = {
    Name      = "demo-ec2-key-pair"
    ManagedBy = var.managed_by
  }
}

resource "local_file" "private_key" {
  content  = tls_private_key.demo_ec2_key_pair.private_key_pem
  filename = "${var.ec2_keypair_name}.pem"
}
