terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # alias      = "mumbai"
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}


