variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "AZs to create subnets into"
}

variable "public_subnets" {
  type        = list(string)
  description = "subnets to create for public network traffic, one per AZ"
}

variable "private_subnets" {
  type        = list(string)
  description = "subnets to create for private network traffic, one per AZ"
}
variable "public_subnet_names" {
  type    = list(string)
  default = ["NYP-subnet-Web-1a", "NYP-subnet-Web-1b", "NYP-subnet-Web-1c"]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["NYP-subnet-App-1a", "NYP-subnet-App-1b", "NYP-subnet-App-1c"]
}

variable "ingress_ports" {
  type        = list(number)
  description = "incoming ports to allow"
  default     = [22, 80, 443]
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

