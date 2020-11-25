# variable "AWS_ACCESS_KEY_ID" {
# }

# variable "AWS_SECRET_ACCESS_KEY" {
# }

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "project" {
  default = "example"
}

variable "scale_min" {
  default = "1"
}

variable "scale_max" {
  default = "5"
}

