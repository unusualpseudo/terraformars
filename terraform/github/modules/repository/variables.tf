variable "repo_name" {
  description = "The name of the repository"
  type        = string
  nullable    = false
}

variable "vulnerability_alerts" {
  description = "Enable github vulnerability alerts"
  type        = bool
  default     = true
}

variable "description" {
  description = "A description of the repository"
  type        = string
  nullable    = false
}

variable "visibility" {
  description = "Visibility of the repository. Repositories are created as private by default"
  type        = string
  default     = "public"
}

variable "has_issues" {
  description = "Enable issues on repository"
  type        = bool
  default     = true
}

variable "has_discussions" {
  description = "Enable discusions on repository"
  type        = bool
  default     = true
}

variable "archive_on_destroy" {
  type    = bool
  default = true
}

variable "license_template" {
  type    = string
  default = "mit"
}

variable "topics" {
  type     = list(any)
  nullable = false
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "allow_merge_commit" {
  type    = bool
  default = false
}


variable "allow_auto_merge" {
  type    = bool
  default = false
}


variable "allow_squash_merge" {
  type    = bool
  default = false
}

variable "allow_rebase_merge" {
  type    = bool
  default = true
}

variable "webhook_events" {
  type    = list(string)
  default = ["*"]
}

variable "secrets" {
  type     = map(string)
  nullable = false
}
