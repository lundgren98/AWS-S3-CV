terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "telia-bucket" {
  bucket = "telia-internship-challenge-bucket"
  tags = {
    Name = "Telia Internship Challege Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "telia-bucket-oc" {
  bucket = aws_s3_bucket.telia-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "telia-bucket-ab" {
  bucket = aws_s3_bucket.telia-bucket.id
}

resource "aws_s3_bucket_acl" "telia-bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.telia-bucket-oc,
    aws_s3_bucket_public_access_block.telia-bucket-ab
  ]
  bucket = aws_s3_bucket.telia-bucket.id
  acl    = "private"
}

resource "aws_s3_object" "cv" {
  depends_on = [aws_s3_bucket_acl.telia-bucket-acl]
  bucket     = aws_s3_bucket.telia-bucket.id
  key        = "CV-Alexander-Lundgren.pdf"
  source     = "~/Documents/Work/CV/CV.pdf"
  acl        = "public-read"
}
