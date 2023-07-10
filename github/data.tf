
data "sops_file" "github" {
  source_file = "github_secrets.sops.yaml"
  input_type  = "yaml"
}
