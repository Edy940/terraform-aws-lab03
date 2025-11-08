# Guia Rápido - Configuração do Repositório GitHub

## 🚀 Passos para Subir para o GitHub

### 1. Criar Repositório no GitHub
1. Acesse https://github.com/new
2. Nome: `terraform-aws-lab03` (ou outro nome)
3. Descrição: "Infraestrutura AWS com Terraform e CI/CD"
4. **NÃO** inicialize com README, .gitignore ou license
5. Clique em "Create repository"

### 2. Adicionar Remote e Push

```bash
# Adicionar remote (substitua SEU_USUARIO pelo seu usuário do GitHub)
git remote add origin https://github.com/SEU_USUARIO/terraform-aws-lab03.git

# Push da branch main
git push -u origin main

# Push da branch develop
git push -u origin develop
```

### 3. Configurar Secrets no GitHub

1. Vá em **Settings** → **Secrets and variables** → **Actions**
2. Clique em **New repository secret**
3. Adicione:
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: Sua AWS Access Key
4. Repita para:
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: Sua AWS Secret Key

### 4. Configurar Branch Protection Rules

#### Para branch `main`:
1. **Settings** → **Branches** → **Add rule**
2. Branch name pattern: `main`
3. Marque:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (1)
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - Status checks: `Terraform Validation`, `Terraform Plan`
4. Save changes

#### Para branch `develop`:
1. **Settings** → **Branches** → **Add rule**
2. Branch name pattern: `develop`
3. Marque:
   - ✅ Require status checks to pass before merging
   - Status checks: `Terraform Validation`
4. Save changes

### 5. Configurar Environments (Opcional mas Recomendado)

#### Environment: production
1. **Settings** → **Environments** → **New environment**
2. Name: `production`
3. Configure:
   - ✅ Required reviewers (adicione você mesmo)
   - ✅ Wait timer: 5 minutes (opcional)
4. Save protection rules

#### Environment: development
1. **Settings** → **Environments** → **New environment**
2. Name: `development`
3. Sem proteções (deploy automático)

## 📋 Comandos Úteis

### Ver branches
```bash
git branch -a
```

### Ver status
```bash
git status
```

### Ver remote
```bash
git remote -v
```

### Criar feature branch
```bash
git checkout develop
git checkout -b feature/minha-feature
```

### Criar hotfix branch
```bash
git checkout main
git checkout -b hotfix/correcao-urgente
```

## ✅ Checklist Final

- [ ] Repositório criado no GitHub
- [ ] Remote adicionado
- [ ] Branch `main` enviada
- [ ] Branch `develop` enviada
- [ ] Secrets AWS configurados
- [ ] Branch protection rules configurados
- [ ] Environments configurados
- [ ] Testado primeiro Pull Request

## 🎯 Próximos Passos

1. Criar uma feature branch de teste:
   ```bash
   git checkout develop
   git checkout -b feature/test-ci
   echo "# Test" >> TEST.md
   git add TEST.md
   git commit -m "test: adiciona arquivo de teste"
   git push origin feature/test-ci
   ```

2. Abrir Pull Request para `develop` e verificar se o CI roda

3. Fazer merge e verificar se o CD deploya no ambiente de desenvolvimento

## 🆘 Problemas Comuns

### "Authentication failed"
- Certifique-se de que suas credenciais do GitHub estão corretas
- Use Personal Access Token ao invés de senha
- Gere em: Settings → Developer settings → Personal access tokens

### "Workflow não executou"
- Verifique se os secrets AWS estão configurados
- Confirme que o arquivo de workflow está em `.github/workflows/`
- Verifique logs em Actions tab no GitHub

### "Terraform failed"
- Verifique se as credenciais AWS estão corretas
- Confirme que a região está correta (us-west-2)
- Verifique se os recursos já existem na AWS

---

**Boa sorte com seu projeto! 🚀**
