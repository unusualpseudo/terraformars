locals {
  repositories = {
    "terraformars" : { "description" = "home to my iac experiments", "topics" = ["terraform"] }
    "provision" : { "description" = "home to my ansible experiments", "topics" = ["ansible"] }
    "dotfiles" : { "description" = "dotfiles for my ubuntu", "topics" = ["fish", "chezmoi"] }
    "nexus" : { "description" = "my home lab", "topics" = ["k8s", "k3s", "homelab", "ansible", "fluxcd"] }
  }
}

module "github_repository" {
  source      = "./modules/repository/"
  for_each    = local.repositories
  repo_name   = each.key
  description = each.value.description
  topics      = each.value.topics
  secrets     = data.sops_file.github.data
}
