####### Common Variables #######
variable "project_name" {
  type    = string
  default = "nexus-net"
}

variable "deployment_number" {
  type    = string
  default = "0.0.2"
}

variable "aws_region" {
  type    = string
  default = "us-east-1" #eu-central-1
}

variable "aws_access_key" {
  type        = string
  description = "Sensitive access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "Sensitive secret key"
  sensitive   = true
}

variable "lambda_runtime" {
  default = "java17"
}
