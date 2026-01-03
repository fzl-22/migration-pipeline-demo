# RDS Migration Pipeline with GitHub Actions and EC2 Bastion Host

This project demonstrates a Human-in-the-Loop database migration pipeline using GitHub Actions. The infrastructure is provisioned on AWS using Terraform and is managed via HCP Terraform with VCS Trigger (on `master` branch).

The pipeline sets up a secure infrastructure, including a VPC and an EC2 bastion host. A GitHub Actions self-hosted runner is installed on the EC2 instance, which then runs the database migrations. This setup is ideal for scenarios where database migrations need to be executed from a controlled and secure environment with a static IP address, which can be whitelisted to access a production RDS instance.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) (v1.0.0+)
- [AWS CLI](https://aws.amazon.com/cli/) (v2+)
- [make](https://www.gnu.org/software/make/)
- [jq](https://stedolan.github.io/jq/download/)
- An [AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- An [HCP Terraform Account](https://www.hashicorp.com/products/terraform/cloud) (Free tier is sufficient)

## Setup and Deployment

### 1. Configure AWS Credentials Locally

Although the final deployment runs in HCP Terraform, you need to configure your AWS credentials locally for some initial setup steps or if you choose to run Terraform locally.

```bash
aws configure
```

Enter your AWS Access Key ID and Secret Access Key when prompted.

### 2. Initialize Terraform Locally

Although the primary deployment uses HCP Terraform, you may want to initialize Terraform locally for local development or testing.

```bash
cd infra/
terraform init
```

### 3. Set up HCP Terraform Workspace

1.  **Create a New Workspace:** In your HCP Terraform organization, create a new "Version control workflow" workspace.
2.  **Connect to your VCS:** Connect it to your forked version of this repository.
3.  **Set the Terraform Working Directory:** In the workspace settings under "General", set the **Terraform Working Directory** to `infra`.

### 4. Configure Workspace Variables

This is the most critical step. HCP Terraform will not read variables from `.tfvars` files in your repository. You must set them in the workspace UI.

Navigate to your workspace's **Variables** tab and add the following:

| Key                        | Value                   | Type                 | Sensitive | Description                                                            |
| -------------------------- | ----------------------- | -------------------- | --------- | ---------------------------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`        | `AKIA...`               | Environment Variable | Yes       | Your AWS access key.                                                   |
| `AWS_SECRET_ACCESS_KEY`    | `...`                   | Environment Variable | Yes       | Your AWS secret key.                                                   |
| `TF_VAR_aws_region`        | `us-east-1`             | Environment Variable | No        | Your AWS region.                                                       |
| `TF_VAR_ec2_ami_id`        | `ami-068c0051b15cdb816` | Environment Variable | No        | AMI for Amazon Linux 2 in `TF_VAR_aws_region`.                         |
| `TF_VAR_ec2_instance_type` | `t2.micro`              | Environment Variable | No        | AWS EC2 instance type.                                                 |
| `TF_VAR_ec2_key_pair_name` | `demo-ec2-key-pair`     | Environment Variable | No        | Generated key pair for SSH authentication.                             |
| `TF_VAR_github_repo_name`  | `your-repo/name`        | Environment Variable | No        | Your GitHub repository name (e.g., `my-user/migration-pipeline-demo`). |
| `TF_VAR_github_repo_pat`   | `github_pat_...`        | Environment Variable | Yes       | GitHub Personal Access Token with `repo` scope.                        |
| `TF_VAR_managed_by`        | `Terraform`             | Environment Variable | No        | The deployment manager.                                                |

### 4. Deploy the Infrastructure

Once your variables are set, queue a new plan in your HCP Terraform workspace.

1.  Go to the "Runs" tab.
2.  Click "New run".
3.  Review the plan and click "Confirm & apply" to provision the infrastructure.

Terraform will create the VPC, EC2 instance, and all related security groups and IAM roles. It will also generate a private key (`demo-ec2-key-pair.pem`) and save it in the same directory, but it's managed by Terraform state.

## Running the Migration Pipeline

The database migration is designed to be run via a GitHub Actions workflow.

1.  **Trigger the Workflow:** The sample workflow in `.github/workflows/migration.yml` can be triggered manually. Go to the "Actions" tab in your GitHub repository, select the "Run Migration" workflow, and click "Run workflow".
2.  **Workflow Execution:** The workflow will:
    - Wait for the self-hosted runner to come online.
    - Execute a job on the runner that fetches database credentials from AWS Secrets Manager.
    - Construct the `DATABASE_URL`.
    - Run `make migrate-up`, which applies the pending database migrations.

## Infrastructure Overview

The Terraform code in the `infra/` directory provisions the following key components:

- **VPC:** A dedicated Virtual Private Cloud to isolate our resources.
- **Public Subnet:** A subnet with a route to an Internet Gateway, allowing resources within it to access the internet.
- **EC2 Bastion Host:** An EC2 instance launched in the public subnet. This host is configured with a self-hosted GitHub Actions runner.
- **IAM Roles & Policies:** An IAM role for the EC2 instance to grant it permission to access other AWS services (like Secrets Manager) without needing hardcoded credentials.
- **Security Groups:** Firewall rules that control traffic to and from the EC2 instance and the RDS database.
- **SSH Key Pair:** A new SSH key pair is generated to allow you to securely connect to the EC2 instance. The private key is stored in the project directory but should be added to `.gitignore`.

## Cleaning Up

To destroy all the resources created by this project and avoid incurring further AWS charges:

1.  **Queue a Destroy Run:** In your HCP Terraform workspace, go to **Settings > Destruction and Deletion**.
2.  Click **Queue destroy plan**.
3.  Review the resources to be destroyed and confirm the action.

This will safely de-provision all the AWS infrastructure. You may also want to remove the self-hosted runner from your GitHub repository settings.
