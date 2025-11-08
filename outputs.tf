# output "vpc_id"        { value = aws_vpc.main.id }
# output "subnet_id"     { value = aws_subnet.public_a.id }
# output "ec2_id"        { value = aws_instance.web.id }
# output "ec2_public_ip" { value = aws_instance.web.public_ip }
# output "sg_id"         { value = aws_security_group.web_sg.id }

output "s3_bucket_name" {
  value       = aws_s3_bucket.mybucket.bucket
  description = "Nome do bucket (se criado)"
}

output "ec2_private_ip" {
  value       = aws_instance.foo.private_ip
  description = "IP privado da instância EC2"
}

output "ec2_id" {
  value       = aws_instance.foo.id
  description = "ID da instância EC2"
}

output "ec2_security_groups" {
  value       = aws_instance.foo.vpc_security_group_ids
  description = "Security groups da instância EC2"
}

output "backend_s3_bucket" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Nome do bucket S3 para backend do Terraform"
}

output "backend_dynamodb_table" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Nome da tabela DynamoDB para locks do Terraform"
}

output "web_sg_id" {
  value       = aws_security_group.web_sg.id
  description = "ID do Security Group Web"
}

output "db_sg_id" {
  value       = aws_security_group.db_sg.id
  description = "ID do Security Group Database"
}
