variable "environment" {
  type        = string
  description = "Environment tag (e.g., prod, dev)"
}

variable "container_image" {
  type        = string
  description = "Container image to execute"
}
