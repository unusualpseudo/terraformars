terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.29.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
  backend "local" {}
}

provider "github" {
  token = data.sops_file.github.data["token"]
  owner = "unusualpseudo"
}
