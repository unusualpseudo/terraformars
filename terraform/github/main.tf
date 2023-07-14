
data "sops_file" "github_secrets" {
  source_file = "github_secrets.sops.yaml"
  input_type  = "yaml"
}


module "github_repository" {
  source      = "./modules/repository/"
  for_each    = var.repositories
  repo_name   = each.key
  description = each.value.description
  topics      = each.value.topics
  secrets     = data.sops_file.github_secrets.data
}
