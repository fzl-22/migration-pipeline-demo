output "ec2_ssh_command" {
  value = "ssh -i '${aws_key_pair.demo_ec2_key_pair.key_name}.pem' ec2-user@${aws_instance.demo_ec2_bastion_host.public_dns}"
}

output "rds_cluster_master_endpoint" {
  description = "The endpoint of the RDS cluster."
  value       = aws_rds_cluster.demo_micro_master_cluster.endpoint
}

output "rds_cluster_master_reader_endpoint" {
  description = "The reader endpoint of the RDS cluster."
  value       = aws_rds_cluster.demo_micro_master_cluster.reader_endpoint
}

output "rds_cluster_master_database_name" {
  description = "The database name of the RDS cluster."
  value       = aws_rds_cluster.demo_micro_master_cluster.database_name
}

output "rds_cluster_master_master_user_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret storing the RDS master user password."
  value       = aws_rds_cluster.demo_micro_master_cluster.master_user_secret[0].secret_arn
}

output "rds_cluster_master_port" {
  description = "The port of the RDS cluster."
  value       = aws_rds_cluster.demo_micro_master_cluster.port
}
