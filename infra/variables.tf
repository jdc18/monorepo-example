variable "app_name" {
  description = "Application Name"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_default_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "ecs_ec2_type" {
  type = string
}

variable "backend_port" {
  type        = string
  description = "Backend Port"
  default     = "4000"
}

variable "vercel_team_id" {
  type        = string
  description = "Vercel Team ID"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}
