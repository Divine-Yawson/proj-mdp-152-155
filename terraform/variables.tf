variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "kops_s3_bucket" {
  description = "The name of the S3 bucket to store KOPS state"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}
