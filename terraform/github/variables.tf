variable "repositories" {
  type = map(object({
    description = string
    topics      = list(string)
  }))
}
