terraform {
  required_version = "1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }

  backend "s3" {
    bucket  = "terraformars-state"
    key     = "aws/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}
