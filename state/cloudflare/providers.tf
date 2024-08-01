
terraform {
  required_version = "1.5.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.10.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "cloudflare" {
  email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
  api_key = data.sops_file.cloudflare_secrets.data["cloudflare_api_key"]
}
