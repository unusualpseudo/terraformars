
terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository" "repository" {
  name               = var.repo_name
  description        = var.description
  visibility         = var.visibility
  archive_on_destroy = var.archive_on_destroy
  license_template   = var.license_template
  topics             = var.topics
  auto_init          = var.auto_init
  has_issues         = var.has_issues
  has_discussions    = var.has_discussions
  allow_auto_merge   = var.allow_auto_merge
  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
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


  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
    require_last_push_approval = true
  }

  required_status_checks {
    strict = true
  }
}


resource "github_actions_secret" "op_svc_token" {

  repository      = github_repository.repository.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN"
  plaintext_value = var.op_svc_token
}

resource "github_repository_webhook" "discord" {
  repository = github_repository.repository.name
  active     = true
  configuration {
    url          = var.discord_webhook_url
    content_type = "json"
  }
  events = ["*"]
}
