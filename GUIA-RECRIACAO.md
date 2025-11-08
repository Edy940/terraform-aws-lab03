# 🚀 Guia Completo - Recriar Lab do Zero

Este guia te ensina a recriar toda essa infraestrutura Terraform + CI/CD do zero.

## 📋 Pré-requisitos

- [ ] Conta AWS com créditos
- [ ] Terraform instalado
- [ ] Git instalado
- [ ] Conta GitHub
- [ ] VS Code (opcional)

---

## 1️⃣ Criar Estrutura de Arquivos

### Passo 1: Criar pasta do projeto
```bash
mkdir lab03
cd lab03
git init
```

### Passo 2: Criar arquivos Terraform

**`provider.tf`** (NÃO COMMITAR - adicionar no .gitignore)
```terraform
provider "aws" {
  region     = "us-west-2"
  access_key = "SUA_ACCESS_KEY"
  secret_key = "SUA_SECRET_KEY"
}
```

**`terraform.tf`**
```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }

  # Backend S3 - Adicionar depois de criar bucket e tabela
  backend "s3" {
    bucket         = "seu-projeto-terraform-states-us-west-2"
    key            = "seu-projeto/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "seu-projeto-terraform-state-locks"
    encrypt        = true
  }
}
```

**`variables.tf`**
```terraform
variable "name" {
  description = "Nome do projeto"
  type        = string
}

variable "env" {
  description = "Ambiente (dev/prod)"
  type        = string
}
```

**`aws_vpc.tf`**
```terraform
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}
```

**`aws_subnet.tf`**
```terraform
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name        = "public-subnet"
    Environment = var.env
  }
}
```

**`aws_instance.tf`**
```terraform
resource "aws_network_interface" "main" {
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "main-network-interface"
  }
}

resource "aws_instance" "main" {
  ami           = "ami-05134c8ef96964280"  # Amazon Linux 2023 - us-west-2
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  tags = {
    Name        = "main-instance"
    Environment = var.env
  }
}
```

**`aws_s3_bucket.tf`**
```terraform
resource "aws_s3_bucket" "data" {
  bucket = "seu-projeto-data-${var.env}"

  tags = {
    environment = var.env
  }
}
```

**`backend.tf`**
```terraform
resource "aws_s3_bucket" "terraform_state" {
  bucket = "seu-projeto-terraform-states-us-west-2"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "all"
    Purpose     = "terraform-backend"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "seu-projeto-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "all"
    Purpose     = "terraform-backend"
  }
}
```

**`outputs.tf`**
```terraform
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID da VPC"
}

output "ec2_id" {
  value       = aws_instance.main.id
  description = "ID da instância EC2"
}

output "ec2_private_ip" {
  value       = aws_instance.main.private_ip
  description = "IP privado da EC2"
}

output "ec2_security_groups" {
  value       = aws_instance.main.vpc_security_group_ids
  description = "Security groups da EC2"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.data.bucket
  description = "Nome do bucket S3 de dados"
}

output "backend_s3_bucket" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Bucket S3 do backend"
}

output "backend_dynamodb_table" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Tabela DynamoDB do backend"
}
```

**`.gitignore`**
```
# Terraform
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
*tfplan*

# Provider com credenciais
provider.tf

# Backups
*.backup
*.bak
```

---

## 2️⃣ Inicializar e Aplicar Terraform

### Passo 1: Inicializar (primeira vez - sem backend)
```bash
# Comentar o bloco backend no terraform.tf primeiro
terraform init
```

### Passo 2: Validar e formatar
```bash
terraform fmt
terraform validate
```

### Passo 3: Criar infraestrutura inicial
```bash
terraform plan -var="env=dev" -var="name=meu-projeto"
terraform apply -var="env=dev" -var="name=meu-projeto" -auto-approve
```

### Passo 4: Migrar para backend S3
```bash
# Descomentar o bloco backend no terraform.tf
terraform init -migrate-state
```

---

## 3️⃣ Configurar Git e GitHub

### Passo 1: Criar branches
```bash
git add .
git commit -m "chore: initial commit"
git branch -M main
git branch develop
```

### Passo 2: Criar repositório no GitHub
1. Acesse https://github.com/new
2. Crie o repositório (sem README, .gitignore, ou license)

### Passo 3: Conectar e enviar
```bash
git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
git push -u origin main
git push -u origin develop
```

---

## 4️⃣ Configurar CI/CD

### Criar estrutura de workflows
```bash
mkdir -p .github/workflows
```

### Workflow CI: `.github/workflows/terraform-ci.yml`
```yaml
name: Terraform CI

on:
  pull_request:
    branches:
      - main
      - develop
  push:
    branches:
      - develop
      - 'feature/**'

jobs:
  terraform-validate:
    name: Terraform Validation
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.6.0

      - name: Terraform Format Check
        id: fmt
        run: terraform fmt -check -recursive
        continue-on-error: true

      - name: Terraform Init
        id: init
        run: terraform init -backend=false

      - name: Terraform Validate
        id: validate
        run: terraform validate -no-color

      - name: Show Validation Results
        if: always()
        run: |
          echo "#### Terraform Format: ${{ steps.fmt.outcome }}"
          echo "#### Terraform Init: ${{ steps.init.outcome }}"
          echo "#### Terraform Validate: ${{ steps.validate.outcome }}"
```

### Commitar workflows
```bash
git add .github/
git commit -m "ci: adiciona workflow de validação"
git push origin main develop
```

---

## 5️⃣ Configurar Secrets no GitHub

1. Vá em: **Settings** → **Secrets and variables** → **Actions**
2. Adicione:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

---

## 6️⃣ Testar Git Flow

### Criar feature branch
```bash
git checkout develop
git checkout -b feature/teste
echo "# Teste" >> TESTE.md
git add TESTE.md
git commit -m "test: adiciona arquivo de teste"
git push origin feature/teste
```

### Criar Pull Request
1. Vá no GitHub
2. Compare: `feature/teste` → Base: `develop`
3. Crie PR
4. Veja CI rodar
5. Faça merge

### Merge via linha de comando
```bash
git checkout develop
git pull origin develop
git merge feature/teste --no-ff -m "Merge feature/teste"
git push origin develop
git branch -d feature/teste
git push origin --delete feature/teste
```

---

## 7️⃣ Comandos Úteis

### Ver recursos criados
```bash
terraform state list
terraform output
```

### Destruir tudo
```bash
terraform destroy -var="env=dev" -var="name=meu-projeto" -auto-approve
```

### Destruir apenas alguns recursos
```bash
terraform destroy -target=aws_instance.main -var="env=dev" -var="name=meu-projeto"
```

### Ver custos estimados
```bash
# Console AWS → Billing Dashboard → Bills
```

---

## 8️⃣ Checklist Final

- [ ] Infraestrutura criada na AWS
- [ ] Backend S3 + DynamoDB configurado
- [ ] State migrado para S3
- [ ] Repositório no GitHub
- [ ] Branches main e develop criadas
- [ ] Workflows CI configurados
- [ ] Secrets AWS configurados
- [ ] Testado Git Flow com feature branch
- [ ] Documentação no README.md

---

## 🎯 Estrutura Final do Projeto

```
seu-projeto/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
├── .gitignore
├── README.md
├── GUIA-RECRIACAO.md (este arquivo)
├── aws_instance.tf
├── aws_s3_bucket.tf
├── aws_subnet.tf
├── aws_vpc.tf
├── backend.tf
├── outputs.tf
├── provider.tf (NÃO commitado)
├── terraform.tf
└── variables.tf
```

---

## 💡 Dicas Importantes

1. **Sempre substitua** `seu-projeto` pelos nomes reais
2. **Nunca commite** o `provider.tf` com credenciais
3. **Configure .gitignore** antes do primeiro commit
4. **Use variáveis** para ambientes diferentes
5. **Documente** mudanças importantes
6. **Destrua recursos** quando não estiver usando
7. **Configure alertas** de billing na AWS
8. **Teste localmente** antes de fazer PR
9. **Use branches** para cada nova feature
10. **Revise** código antes de merge

---

## 📞 Problemas Comuns

### Erro: "Backend initialization required"
```bash
terraform init -reconfigure
```

### Erro: "Bucket already exists"
- Mude o nome do bucket
- Ou delete o bucket antigo no console AWS

### Erro: "No valid credential sources"
```bash
# Configure variáveis de ambiente
$env:AWS_ACCESS_KEY_ID="sua-key"
$env:AWS_SECRET_ACCESS_KEY="sua-secret"
$env:AWS_DEFAULT_REGION="us-west-2"
```

### Workflow falha por falta de secrets
- Verifique se configurou os secrets no GitHub
- Settings → Secrets and variables → Actions

---

**Boa sorte! 🚀**
