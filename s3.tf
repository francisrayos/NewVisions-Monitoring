resource "aws_s3_bucket" "b" {
  bucket = "my-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    terraform   = "true"
    environment = "dev"
  }
}