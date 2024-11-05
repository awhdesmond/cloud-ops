variable "repo_name" {
  type = string
  nullable = false
  description = "name of the respository"
}

variable "lifecycle_policy_file" {
  type = string
  nullable = false
  description = "path to lifecycle policy"
}
