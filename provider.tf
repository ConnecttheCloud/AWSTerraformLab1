terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#   backend "s3" {
#     profile = "cloudcasts"
#     region  = "us-east-2"
#   }


provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}
