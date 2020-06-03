resource "aws_s3_bucket" "example" {
  bucket = "new-visions-s3-bucket"
  acl = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "s3-terraform-bucket"
  }
}