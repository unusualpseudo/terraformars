locals {
  repositories = {
    "terraformars" : { "description" = "home to my iac experiments", "topics" = ["terraform"] }
    "provision" : { "description" = "home to my ansible experiments", "topics" = ["ansible"] }
  }
}

module "github_repository" {
  source      = "./module/core/"
  for_each    = local.repositories
  repo_name   = each.key
  description = each.value.description
  topics      = each.value.topics
  secrets     = data.sops_file.github.data
}
