variable "vpc_name" {
  description = "vpc_name"
  default     = "ec2-vpc"
}

variable "vpc_cidr" {
  description = "vpc_cidr"
  default     = "10.0.0.0/16"
}

variable "vpc_az" {
  description = "vpc_az"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets_cidr" {
  description = "private_subnets_cidr"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_cidr" {
  description = "public_subnets_cidr"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  description = "enable_nat_gateway"
  default = true
}

variable "single_nat_gateway" {
  description = "single_nat_gateway"
  default = true
}