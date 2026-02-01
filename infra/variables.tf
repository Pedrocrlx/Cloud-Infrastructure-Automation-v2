variable "environments" {
  description = "List of namespaces to create for application isolation"
  type        = set(string)
  default     = ["dev", "prod"]
}