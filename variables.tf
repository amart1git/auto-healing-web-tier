variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to deploy infrastructure"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Deployment environment name"
}

variable "container_image" {
  type        = string
  default     = "nginx:alpine" # Or "YOUR_DOCKERHUB_USERNAME/nginx-web-tier:latest"
  description = "Container image URL to run on EC2 instance launch"
}
