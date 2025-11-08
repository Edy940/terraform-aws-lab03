resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket-lab03-cicd-${var.env}"

  tags = {
    environment = var.env
  }
}