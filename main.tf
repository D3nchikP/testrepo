resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-demo"
  acl    = "public-read"  # Insecure setting for demo purposes
}
