data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "demo_ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "demo_ec2_parameter_store_policy" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
    ]
    resources = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

data "aws_iam_policy_document" "demo_ec2_secrets_manager_policy" {
  statement {
    sid    = 1
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:*"]
  }
}

resource "aws_iam_role" "demo_ec2_role" {
  name               = "${var.environment}-demo-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.demo_ec2_assume_role_policy.json

  tags = {
    Name        = "${var.environment}-demo-ec2-role"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

# IAM POLICIES
resource "aws_iam_policy" "demo_ec2_parameter_store_policy" {
  name   = "${var.environment}-demo-ec2-parameter-store-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.demo_ec2_parameter_store_policy.json

  tags = {
    Name        = "${var.environment}-demo-ec2-parameter-store-policy"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

resource "aws_iam_policy" "demo_ec2_secrets_manager_policy" {
  name   = "${var.environment}-demo-ec2-secrets-manager-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.demo_ec2_secrets_manager_policy.json

  tags = {
    Name        = "${var.environment}-demo-ec2-secrets-manager-policy"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

# IAM ROLE POLICY ATTACHMENTS
resource "aws_iam_role_policy_attachment" "demo_ec2_parameter_store_policy_attachment" {
  role       = aws_iam_role.demo_ec2_role.name
  policy_arn = aws_iam_policy.demo_ec2_parameter_store_policy.arn
}

resource "aws_iam_role_policy_attachment" "demo_ec2_secrets_manager_policy_attachment" {
  role       = aws_iam_role.demo_ec2_role.name
  policy_arn = aws_iam_policy.demo_ec2_secrets_manager_policy.arn
}

# IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "demo_ec2_instance_profile" {
  name = "${var.environment}-demo-ec2-instance-profile"
  role = aws_iam_role.demo_ec2_role.name

  tags = {
    Name        = "${var.environment}-demo-ec2-instance-profile"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}
