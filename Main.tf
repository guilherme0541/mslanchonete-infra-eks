terraform {
  backend "s3" {
    bucket = "ms-lanchonete"
    key    = "infra-eks/terraform.tfstate"
    region = "us-east-1"
  }
}

module "mslanchonete" {
  source = "./infra"

  project_name = var.projectname
  region = var.aws_region
}

variable "aws_region" {
  type = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "projectname" {
  type = string
  default = "mslanchonete"
  description = "Application Name"
}