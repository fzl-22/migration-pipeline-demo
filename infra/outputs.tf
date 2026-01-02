output "github_repo_name_output" {
  value = var.github_repo_name
}

output "github_repo_pat_output" {
  value     = var.github_repo_pat
  sensitive = true
}
