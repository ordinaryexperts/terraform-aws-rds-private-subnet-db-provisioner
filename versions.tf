terraform {
  required_version = ">= 1.0.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0"
    }
    #    awsutils = {
    #      source  = "cloudposse/awsutils"
    #      version = ">= 0.16.0"
    #    }
  }
}
