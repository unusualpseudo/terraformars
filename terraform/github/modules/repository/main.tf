
terraform {
  required_version = "1.5.3"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }
}

resource "github_repository" "repository" {
  name                 = var.repo_name
  vulnerability_alerts = var.vulnerability_alerts
  description          = var.description
  visibility           = var.visibility
  archive_on_destroy   = var.archive_on_destroy
  license_template     = var.license_template
  topics               = var.topics
  auto_init            = var.auto_init
  has_issues           = var.has_issues
  has_discussions      = var.has_discussions
  allow_auto_merge     = var.allow_auto_merge
  allow_merge_commit   = var.allow_merge_commit
  allow_squash_merge   = var.allow_squash_merge
  allow_rebase_merge   = var.allow_rebase_merge
}


resource "github_branch_default" "main" {
  repository = github_repository.repository.name
  branch     = "main"
  depends_on = [
    github_repository.repository
  ]
}


resource "github_branch_protection" "main" {

  repository_id = github_repository.repository.node_id

  pattern                 = "main"
  allows_deletions        = false
  allows_force_pushes     = true
  required_linear_history = true
  require_signed_commits  = true

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
    require_last_push_approval = true
  }

  required_status_checks {
    strict = true
  }
}


resource "github_repository_webhook" "discord" {
  repository = github_repository.repository.name
  active     = true
  configuration {
    url          = var.secrets["discord_webhook_url"]
    content_type = "json"
  }
  events = var.webhook_events
}


resource "github_actions_secret" "aws_account_id" {
  repository      = github_repository.repository.name
  secret_name     = "AWS_ACCOUNT_ID"
  plaintext_value = var.secrets["aws_account_id"]
}

resource "github_actions_secret" "app_id" {
  repository      = github_repository.repository.name
  secret_name     = "BOT_APP_ID"
  plaintext_value = var.secrets["app_id"]
}

resource "github_actions_secret" "app_private_key" {
  repository      = github_repository.repository.name
  secret_name     = "BOT_APP_PRIVATE_KEY"
  plaintext_value = var.secrets["app_private_key"]
}


resource "github_actions_secret" "sops_age_key_file" {
  repository      = github_repository.repository.name
  secret_name     = "SOPS_AGE_KEY_FILE"
  plaintext_value = var.secrets["sops_age_key_file"]
}
