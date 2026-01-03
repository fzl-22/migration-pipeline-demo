# PARAMETER STORES

# Writer Endpoint
resource "aws_ssm_parameter" "db_demo_master_host_write" {
  name  = "/demo/rds/DB_DEMO_MASTER_HOST_WRITE"
  type  = "SecureString"
  value = aws_rds_cluster.demo_micro_master_cluster.endpoint

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_HOST_WRITE"
    ManagedBy = var.managed_by
  }
}

# Reader Endpoint
resource "aws_ssm_parameter" "db_demo_master_host_read" {
  name  = "/demo/rds/DB_DEMO_MASTER_HOST_READ"
  type  = "SecureString"
  value = aws_rds_cluster.demo_micro_master_cluster.reader_endpoint

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_HOST_READ"
    ManagedBy = var.managed_by
  }
}

resource "aws_ssm_parameter" "db_demo_master_credentials_id_arn" {
  name  = "/demo/rds/DB_DEMO_MASTER_CREDENTIALS_ID_ARN"
  type  = "SecureString"
  value = aws_rds_cluster.demo_micro_master_cluster.master_user_secret[0].secret_arn

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_CREDENTIALS_ID_ARN"
    ManagedBy = var.managed_by
  }
}

# Database Name
resource "aws_ssm_parameter" "db_demo_master_name" {
  name  = "/demo/rds/DB_DEMO_MASTER_NAME"
  type  = "String"
  value = aws_rds_cluster.demo_micro_master_cluster.database_name

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_NAME"
    ManagedBy = var.managed_by
  }
}

# Database Port
resource "aws_ssm_parameter" "db_demo_master_port" {
  name  = "/demo/rds/DB_DEMO_MASTER_PORT"
  type  = "String"
  value = aws_rds_cluster.demo_micro_master_cluster.port

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_PORT"
    ManagedBy = var.managed_by
  }
}

# Database Connection SSL Mode
resource "aws_ssm_parameter" "db_demo_master_sslmode" {
  name  = "/demo/rds/DB_DEMO_MASTER_SSLMODE"
  type  = "String"
  value = "require"

  tags = {
    Name      = "/demo/rds/DB_DEMO_MASTER_SSLMODE"
    ManagedBy = var.managed_by
  }
}
