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
  access_key = "AKIA2P7GLS7YAJANMDFA"
  secret_key = "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"
}


