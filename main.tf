terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "AutoHealingWebTier"
    }
  }
}

module "web_tier" {
  source          = "./modules/auto_healing_web"
  environment     = var.environment
  container_image = var.container_image
}
