variable "repositories" {
  type = map(object({
    description = string
    topics      = list(string)
  }))
  default = {
    "terraformars" = {
      description = "home to my iac experiments"
      topics      = ["terraform"]
    }
    "provision" = {
      description = "home to my ansible experiments"
      topics      = ["ansible"]
    }
    "dotfiles" = {
      description = "dotfiles for my ubuntu"
      topics      = ["fish", "chezmoi"]
    }
    "nexus" = {
      description = "my home lab"
      topics      = ["k8s", "k3s", "homelab", "ansible", "fluxcd"]
    }
  }
}
