# ✅ RESUMO: Configuração Completa do Azure + GitHub Actions

## 🎯 O QUE JÁ FOI FEITO

### 1. Azure AD App Registration
✅ Aplicação criada: **github-actions-aks-workshop**
- **Client ID**: `3827ee33-2db1-4bc3-8f55-4bec42299f96`
- **Tenant ID**: `f70185a9-cf8d-4d9f-ae3e-aa6e02e41011`
- **Subscription ID**: `97fdf769-4f92-407b-83ec-0e2958b92cf4`

### 2. Service Principal
✅ Service Principal criado
✅ Permissão **Contributor** atribuída na subscription

### 3. GitHub Actions Workflow
✅ Arquivo criado: `.github/workflows/deploy-azure-infrastructure.yml`

---

## ⚠️ O QUE VOCÊ PRECISA FAZER AGORA

### ETAPA 1: Configurar Credenciais Federadas no Azure Portal

Como seu Azure CLI está desatualizado, você precisa fazer isso no Portal:

1. **Acesse o Azure Portal**: https://portal.azure.com

2. **Navegue para App Registrations**:
   - Procure por "App registrations" na barra de pesquisa
   - Encontre o app **"github-actions-aks-workshop"**
   - Clique nele

3. **Vá para Certificates & secrets**:
   - No menu lateral, clique em "Certificates & secrets"
   - Clique na aba "Federated credentials"
   - Clique no botão "+ Add credential"

4. **Adicione 3 credenciais federadas**:

   **Credencial 1 - Para Branch Main:**
   - Federated credential scenario: `GitHub Actions deploying Azure resources`
   - Organization: `JosueVidalMVP`
   - Repository: `aks-store-demo`
   - Entity type: `Branch`
   - GitHub branch name: `main`
   - Name: `github-main`
   - Clique em "Add"

   **Credencial 2 - Para Environment Production:**
   - Federated credential scenario: `GitHub Actions deploying Azure resources`
   - Organization: `JosueVidalMVP`
   - Repository: `aks-store-demo`
   - Entity type: `Environment`
   - Environment name: `production`
   - Name: `github-production`
   - Clique em "Add"

   **Credencial 3 - Para Pull Requests:**
   - Federated credential scenario: `GitHub Actions deploying Azure resources`
   - Organization: `JosueVidalMVP`
   - Repository: `aks-store-demo`
   - Entity type: `Pull Request`
   - Name: `github-pull-request`
   - Clique em "Add"

### ETAPA 2: Configurar Secrets no GitHub

1. **Acesse as configurações do repositório**:
   https://github.com/JosueVidalMVP/aks-store-demo/settings/secrets/actions

2. **Adicione os seguintes secrets** (clique em "New repository secret" para cada um):

   ```
   Name: AZURE_CLIENT_ID
   Value: 3827ee33-2db1-4bc3-8f55-4bec42299f96
   ```

   ```
   Name: AZURE_TENANT_ID
   Value: f70185a9-cf8d-4d9f-ae3e-aa6e02e41011
   ```

   ```
   Name: AZURE_SUBSCRIPTION_ID
   Value: 97fdf769-4f92-407b-83ec-0e2958b92cf4
   ```

### ETAPA 3: Criar Environment no GitHub

1. **Acesse Environments**:
   https://github.com/JosueVidalMVP/aks-store-demo/settings/environments

2. **Crie o environment**:
   - Clique em "New environment"
   - Nome: `production`
   - Clique em "Configure environment"
   - (Opcional) Configure proteções se desejar
   - Clique em "Save protection rules"

### ETAPA 4: Criar Storage Account para Terraform State (Opcional)

Se você quiser usar remote state para o Terraform:

```powershell
# Execute no PowerShell local (se conectado ao Azure)
$RG_NAME = "workshop"
$LOCATION = "eastus"
$STORAGE_NAME = "tfstateworkshop$(Get-Random -Maximum 9999)"

az group create --name $RG_NAME --location $LOCATION

az storage account create `
    --name $STORAGE_NAME `
    --resource-group $RG_NAME `
    --location $LOCATION `
    --sku Standard_LRS `
    --encryption-services blob

az storage container create `
    --name tfstate `
    --account-name $STORAGE_NAME

# Adicione este secret no GitHub:
# Name: TERRAFORM_STORAGE_ACCOUNT
# Value: (o valor de $STORAGE_NAME)
```

**OU** você pode comentar a seção de Terraform Init no workflow e usar local state.

---

## 🚀 TESTANDO O DEPLOY

Após configurar tudo:

### Opção 1: Push para Main
```bash
git add .
git commit -m "Configure Azure deployment"
git push
```

### Opção 2: Execução Manual
1. Vá para: https://github.com/JosueVidalMVP/aks-store-demo/actions
2. Selecione o workflow "Deploy Azure Infrastructure"
3. Clique em "Run workflow"
4. Selecione a branch "main"
5. Clique em "Run workflow"

---

## 🔍 VERIFICANDO SE ESTÁ TUDO CERTO

### No Azure Portal:
1. Vá para **App registrations** > **github-actions-aks-workshop**
2. Clique em **Certificates & secrets** > **Federated credentials**
3. Você deve ver 3 credenciais listadas

### No GitHub:
1. Vá para **Settings** > **Secrets and variables** > **Actions**
2. Você deve ver 3 secrets (ou 4 se configurou o Terraform Storage)

3. Vá para **Settings** > **Environments**
4. Você deve ver o environment "production"

---

## 📝 NOTAS IMPORTANTES

1. **O Terraform Init vai falhar** se você não configurar o `TERRAFORM_STORAGE_ACCOUNT` secret
   - Solução: Configure o storage account OU remova/comente essa etapa do workflow

2. **O workflow só executa Terraform Apply** na branch main (não em PRs)

3. **Pode haver um delay** de alguns minutos para as credenciais federadas propagarem

4. **Se ainda houver erros**, aguarde 5-10 minutos e tente novamente

---

## 🆘 SUPORTE

Se encontrar erros:
1. Verifique os logs do GitHub Actions
2. Confirme que todas as credenciais federadas foram criadas
3. Confirme que todos os secrets estão configurados
4. Aguarde alguns minutos e tente novamente
