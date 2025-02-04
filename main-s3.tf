terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.85.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "jenkins-bucket" {
  bucket_prefix = "jenkins-bucket"

  tags = {
    Name        = "Jenkins-Test-Bucket"
    Environment = "Production"
  }
}