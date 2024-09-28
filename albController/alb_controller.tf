terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.5"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.aws_region
}

locals {
  cluster_name = "${var.projectname}-cluster"
}

data "aws_eks_cluster" "default" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = local.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}

module "alb_controller" {
  source  = "campaand/alb-ingress-controller/aws"
  version = "2.1.0"

  cluster_name = "${var.projectname}-cluster"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "projectname" {
  type        = string
  default     = "mslanchonete"
  description = "Application Name"
}