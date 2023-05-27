variable "access_key" {
  type        = string
  description = "AWS access key"
}
variable "secret_key" {
  type        = string
  description = "AWS secret key"
}
variable "token" {
  type        = string
  description = "AWS token"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "infra_env" {
  type        = string
  description = "Deploying infrastucture"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "additional_tags" {
  default = {
    Project     = "NYP Assignment2"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
  description = "Additional resource tags"
  type        = map(string)
}




