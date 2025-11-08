resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket-lab03-20251108013323"

  tags = {
    environment = "dev"
  }
}