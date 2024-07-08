terraform {
  required_version = "1.5.3"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
  backend "s3" {
    bucket  = "terraformars-state"
    region  = "eu-west-3"
    key     = "github/terraform.tfstate"
    encrypt = true
  }
}

provider "github" {
  token = data.sops_file.secrets.data["token"]
  owner = "unusualpseudo"
}
