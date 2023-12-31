
terraform {
  required_version = "1.5.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.10.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  backend "s3" {
    bucket  = "terraformars-state"
    key     = "cloudflare/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

provider "cloudflare" {
  email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
  api_key = data.sops_file.cloudflare_secrets.data["cloudflare_api_key"]
}
