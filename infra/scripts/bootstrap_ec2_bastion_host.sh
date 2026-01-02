#!/bin/bash

set -euo pipefail

LOG_FILE="/home/ec2-user/bootstrap.log"

# prefix all output with a timestamp [YYYY-MM-DD HH:MM:SS]
log_with_time() {
    while IFS= read -r line; do
        printf "[%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$line"
    done
}

# redirect all stdout/stderr through the timestamp function and into the log
exec > >(log_with_time | tee -a "$LOG_FILE") 2>&1

# --- HELPER FUNCTIONS ---

install_system_dependencies() {
    echo "Installing system dependencies..."
    yum update -y
    yum install git make telnet libicu jq -y
}

install_golang_migrate() {
    echo "Installing golang-migrate..."
    local version="v4.19.1"
    local temp_dir
    temp_dir=$(mktemp -d)
    
    curl -sL "https://github.com/golang-migrate/migrate/releases/download/$${version}/migrate.linux-amd64.tar.gz" | tar -C "$temp_dir" -xvz
    mv "$temp_dir/migrate" /usr/local/bin/migrate
    chmod +x /usr/local/bin/migrate
    rm -rf "$temp_dir"
}

setup_github_runner() {
    echo "Setting up GitHub Action Runner..."
    local runner_dir="/home/ec2-user/actions-runner"
    local runner_version="2.330.0"
    local checksum="af5c33fa94f3cc33b8e97937939136a6b04197e6dadfcfb3b6e33ae1bf41e79a"

    # run everything as ec2-user using a Heredoc
    sudo -u ec2-user bash <<EOF
        set -euo pipefail
        mkdir -p "$${runner_dir}" && cd "$${runner_dir}"

        # download and verify
        curl -o runner.tar.gz -L "https://github.com/actions/runner/releases/download/v$${runner_version}/actions-runner-linux-x64-$${runner_version}.tar.gz"
        echo "$${checksum}  runner.tar.gz" | sha256sum -c
        tar xzf runner.tar.gz

        # get Registration Token
        REG_TOKEN=\$(curl -sL -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${github_repo_pat}" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/${github_repo_name}/actions/runners/registration-token" | jq -r .token)

        # get EC2 Instance ID (IMDSv2)
        IMDS_TOKEN=\$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
        INSTANCE_ID=\$(curl -s -H "X-aws-ec2-metadata-token: \$IMDS_TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

        # configure Runner
        ./config.sh \
            --url "https://github.com/${github_repo_name}" \
            --token "\$REG_TOKEN" \
            --name "${github_runner_name}-\$INSTANCE_ID" \
            --work _work \
            --labels "${github_runner_labels}" \
            --unattended \
            --replace
EOF
}

start_runner_service() {
    echo "Starting GitHub Runner Service..."
    cd /home/ec2-user/actions-runner
    ./svc.sh install ec2-user
    ./svc.sh start
}

main() {
    echo "--- Starting Provisioning ---"

    install_system_dependencies
    install_golang_migrate
    setup_github_runner
    start_runner_service

    echo "--- Provisioning Complete ---"
}

main