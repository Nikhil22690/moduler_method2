variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-08bb0cb0bdc397181"
}

variable "subnet_id" {
  description = "Existing Subnet ID"
  type        = string
  default     = "subnet-033b3927bc0c2d24c"
}

variable "instance_type" {
  description = "EC2 instance type (used by both instances)"
  type        = string
  default     = "t3.micro"
}
variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "environment" {
  description = "Environment tag (dev, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "key_pair_name" {
  description = "Existing AWS key pair name"
  type        = string
  default     = "ubuntu-key"
}

variable "volume_size" {
  description = "Root EBS volume size (GB) used by both instances"
  type        = number
  default     = 30
}

