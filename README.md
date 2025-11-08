# Lab03 - Terraform AWS Infrastructure

## 📋 Visão Geral
Projeto de infraestrutura como código usando Terraform para provisionar recursos na AWS.

## 🏗️ Recursos Provisionados
- **VPC** - Virtual Private Cloud
- **Subnet** - Sub-rede pública
- **EC2 Instance** - Instância t3.micro
- **Network Interface** - Interface de rede
- **S3 Bucket** - Bucket de armazenamento

## 🌿 Estratégia Git Flow

Este projeto utiliza o **Git Flow** para gerenciar branches e deploys:

### Estrutura de Branches

```
main (production)
  ├── develop (development)
  │   ├── feature/nova-funcionalidade
  │   └── feature/outra-feature
  └── hotfix/correcao-urgente
```

### Branches Principais

- **`main`**: Branch de produção
  - Deploy automático para ambiente de **produção**
  - Somente recebe merges de `develop` ou `hotfix/*`
  - Protegida - requer Pull Request e aprovação

- **`develop`**: Branch de desenvolvimento
  - Deploy automático para ambiente de **desenvolvimento**
  - Integração contínua de features
  - Base para novas features

### Branches de Suporte

- **`feature/*`**: Novas funcionalidades
  - Criada a partir de `develop`
  - Merge de volta para `develop` via Pull Request
  - Exemplo: `feature/add-rds-database`

- **`hotfix/*`**: Correções urgentes em produção
  - Criada a partir de `main`
  - Deploy direto para produção com aprovação manual
  - Merge de volta para `main` E `develop`
  - Exemplo: `hotfix/security-patch`

## 🚀 Workflows CI/CD

### 1. **Terraform CI** (`terraform-ci.yml`)
Executado em: Pull Requests para `main` ou `develop`

**Ações:**
- ✅ Verifica formatação (`terraform fmt`)
- ✅ Valida sintaxe (`terraform validate`)
- ✅ Gera plano de execução (`terraform plan`)
- ✅ Comenta resultados no PR

### 2. **Terraform CD** (`terraform-cd.yml`)
Executado em: Push para `main` ou `develop`

**Ações:**
- 🚀 Deploy automático no ambiente correspondente
- 📊 Gera resumo de deployment
- 🔍 Exibe outputs da infraestrutura

**Ambientes:**
- `develop` → Deploy em **development**
- `main` → Deploy em **production**

### 3. **Terraform Hotfix** (`terraform-hotfix.yml`)
Executado em: Push para `hotfix/*`

**Ações:**
- 🚨 Cria issue para aprovação
- ⏳ Aguarda aprovação manual
- 🔥 Deploy imediato após aprovação
- ✅ Notifica conclusão

## 📝 Fluxo de Trabalho

### Para Nova Feature

```bash
# 1. Criar branch de feature
git checkout develop
git pull origin develop
git checkout -b feature/minha-feature

# 2. Fazer alterações e commits
git add .
git commit -m "feat: adiciona nova funcionalidade"

# 3. Push e criar Pull Request
git push origin feature/minha-feature
# Abrir PR para develop no GitHub
```

### Para Release em Produção

```bash
# 1. Criar Pull Request de develop para main
# 2. Aguardar CI passar
# 3. Obter aprovação do time
# 4. Fazer merge - deploy automático acontecerá
```

### Para Hotfix Urgente

```bash
# 1. Criar branch de hotfix
git checkout main
git pull origin main
git checkout -b hotfix/correcao-critica

# 2. Fazer correção
git add .
git commit -m "fix: corrige vulnerabilidade crítica"

# 3. Push - workflow de hotfix será acionado
git push origin hotfix/correcao-critica

# 4. Aprovar deployment no issue criado
# 5. Após deploy, fazer merge para main E develop
git checkout main
git merge hotfix/correcao-critica
git push origin main

git checkout develop
git merge hotfix/correcao-critica
git push origin develop

# 6. Deletar branch de hotfix
git branch -d hotfix/correcao-critica
git push origin --delete hotfix/correcao-critica
```

## 🔒 Configuração de Secrets no GitHub

Para que os workflows funcionem, configure os seguintes secrets no GitHub:

1. Vá em: **Settings** → **Secrets and variables** → **Actions**
2. Adicione os secrets:

```
AWS_ACCESS_KEY_ID=sua-access-key
AWS_SECRET_ACCESS_KEY=sua-secret-key
```

## 🛠️ Comandos Locais

### Inicializar Terraform
```bash
terraform init
```

### Validar Configuração
```bash
terraform validate
```

### Verificar Formatação
```bash
terraform fmt -check
```

### Ver Plano de Execução
```bash
terraform plan -var="env=dev" -var="name=test"
```

### Aplicar Mudanças
```bash
terraform apply -var="env=dev" -var="name=test"
```

### Ver Outputs
```bash
terraform output
```

### Destruir Recursos
```bash
terraform destroy -var="env=dev" -var="name=test"
```

## 📂 Estrutura do Projeto

```
lab03/
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml      # CI - Validação e testes
│       ├── terraform-cd.yml      # CD - Deploy automático
│       └── terraform-hotfix.yml  # Hotfix - Deploy urgente
├── aws_instance.tf               # Configuração EC2
├── aws_network_interface.tf      # Network interface
├── aws_s3_bucket.tf              # Bucket S3
├── aws_subnet.tf                 # Subnet
├── aws_vpc.tf                    # VPC
├── outputs.tf                    # Outputs
├── provider.tf                   # Provider AWS (NÃO COMMITAR)
├── terraform.tf                  # Configuração Terraform
├── variables.tf                  # Variáveis
└── .gitignore                    # Arquivos ignorados
```

## 🚫 Arquivos Não Versionados

Os seguintes arquivos **NÃO** são commitados (`.gitignore`):
- `terraform.tfstate*` - Estado da infraestrutura
- `provider.tf` - Credenciais AWS
- `.terraform/` - Cache de plugins
- `*.tfvars` - Valores sensíveis

## 🎯 Outputs Disponíveis

Após deploy, você pode consultar:
```bash
terraform output
```

Outputs:
- `ec2_id` - ID da instância EC2
- `ec2_private_ip` - IP privado da EC2
- `ec2_security_groups` - Security groups
- `s3_bucket_name` - Nome do bucket S3

## 📞 Suporte

Para dúvidas ou problemas, abra uma issue no repositório.

---

**Desenvolvido com ❤️ usando Terraform e GitHub Actions**
