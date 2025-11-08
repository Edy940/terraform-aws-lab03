resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket-lab03-cicd-test-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  tags = {
    environment = "dev"
  }
  
  lifecycle {
    ignore_changes = [bucket]
  }
}