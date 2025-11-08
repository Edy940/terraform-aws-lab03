terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }

  # Backend S3 - State armazenado remotamente
  # Credenciais devem ser configuradas via AWS CLI ou variáveis de ambiente
  backend "s3" {
    bucket         = "lab03-terraform-states-us-west-2"
    key            = "lab03/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "lab03-terraform-state-locks"
    encrypt        = true
  }
}