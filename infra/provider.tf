provider "aws" {
  region = var.AWS_REGION
}

terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    bucket = "example-dev-1" # alter name bucket for you bucket created
    key    = "terraform/example-dev-1"
    region = "us-east-1"
  }
}

