resource "aws_s3_bucket" "s3_bucket" {
  bucket = "new-visions-s3"
  acl = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-terraform-bucket"
  }
}