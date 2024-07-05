provider "aws" {
  region = var.region
}

# Configure AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Adjust if needed
    }
  }
}
