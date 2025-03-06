provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "insecure-bucket"
  acl    = "public-read"  # Security Issue: Publicly accessible bucket
}

resource "aws_s3_bucket_policy" "insecure_policy" {
  bucket = aws_s3_bucket.insecure_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::insecure-bucket/*"
    }
  ]
}
POLICY
}

resource "aws_security_group" "open_sg" {
  name        = "open-security-group"
  description = "Security group with open access"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Security Issue: Allows all traffic from anywhere
  }
}

resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "us-east-1a"
  size             = 50
  encrypted        = false  # Security Issue: Unencrypted EBS volume
}

resource "aws_iam_policy" "overprivileged_policy" {
  name        = "overprivileged-policy"
  description = "Overly permissive IAM policy"
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",  # Security Issue: Grants all actions
      "Resource": "*"  # Security Issue: Grants access to all resources
    }
  ]
}
POLICY
}

resource "aws_instance" "insecure_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "optional"  # Security Issue: Metadata service allows unauthenticated access
  }
}
