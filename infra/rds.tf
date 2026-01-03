resource "aws_rds_cluster" "demo_micro_master_cluster" {
  cluster_identifier     = "demo-micro-master-cluster"
  vpc_security_group_ids = [aws_security_group.demo_rds_to_ec2_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.demo_rds_subnet_group.name

  engine                      = "aurora-postgresql"
  engine_mode                 = "provisioned"
  engine_version              = 17.4
  database_name               = "demo_master"
  master_username             = "postgres_master"
  manage_master_user_password = true

  skip_final_snapshot = true

  storage_encrypted   = true
  deletion_protection = false

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 128
  }

  tags = {
    Name      = "demo-micro-master-cluster"
    ManagedBy = var.managed_by
  }
}

resource "aws_rds_cluster_instance" "demo_micro_master_instance" {
  identifier = "demo-micro-master-instance-1"

  cluster_identifier = aws_rds_cluster.demo_micro_master_cluster.id
  engine             = aws_rds_cluster.demo_micro_master_cluster.engine
  engine_version     = aws_rds_cluster.demo_micro_master_cluster.engine_version
  instance_class     = "db.serverless"

  tags = {
    Name      = "demo-micro-master-instance-1"
    ManagedBy = var.managed_by
  }
}
