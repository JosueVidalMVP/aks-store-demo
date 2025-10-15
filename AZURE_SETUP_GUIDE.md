# Guia: Configurar Credenciais Federadas no Azure Portal

## INFORMAÇÕES DA APLICAÇÃO
- **App ID**: 3827ee33-2db1-4bc3-8f55-4bec42299f96
- **Tenant ID**: f70185a9-cf8d-4d9f-ae3e-aa6e02e41011
- **Subscription ID**: 97fdf769-4f92-407b-83ec-0e2958b92cf4
- **Repositório**: JosueVidalMVP/aks-store-demo

## PASSO A PASSO

### 1. Acessar o Azure Portal
1. Vá para: https://portal.azure.com
2. Procure por "App registrations" ou "Registros de aplicativo"
3. Encontre o app chamado **"github-actions-aks-workshop"**

### 2. Configurar Credenciais Federadas

#### 2.1. Abrir Certificates & secrets
1. No menu lateral do app, clique em "Certificates & secrets"
2. Clique na aba "Federated credentials"
3. Clique em "+ Add credential"

#### 2.2. Criar Credencial para Branch Main
- **Federated credential scenario**: GitHub Actions deploying Azure resources
- **Organization**: JosueVidalMVP
- **Repository**: aks-store-demo
- **Entity type**: Branch
- **GitHub branch name**: main
- **Name**: github-main
- Clique em "Add"

#### 2.3. Criar Credencial para Environment Production
- **Federated credential scenario**: GitHub Actions deploying Azure resources
- **Organization**: JosueVidalMVP
- **Repository**: aks-store-demo
- **Entity type**: Environment
- **Environment name**: production
- **Name**: github-production
- Clique em "Add"

#### 2.4. Criar Credencial para Pull Requests
- **Federated credential scenario**: GitHub Actions deploying Azure resources
- **Organization**: JosueVidalMVP
- **Repository**: aks-store-demo
- **Entity type**: Pull Request
- **Name**: github-pull-request
- Clique em "Add"

### 3. Configurar Secrets no GitHub

1. Vá para: https://github.com/JosueVidalMVP/aks-store-demo/settings/secrets/actions
2. Clique em "New repository secret" e adicione:

**Secret 1:**
- Name: `AZURE_CLIENT_ID`
- Value: `3827ee33-2db1-4bc3-8f55-4bec42299f96`

**Secret 2:**
- Name: `AZURE_TENANT_ID`
- Value: `f70185a9-cf8d-4d9f-ae3e-aa6e02e41011`

**Secret 3:**
- Name: `AZURE_SUBSCRIPTION_ID`
- Value: `97fdf769-4f92-407b-83ec-0e2958b92cf4`

### 4. Criar Environment no GitHub

1. Vá para: https://github.com/JosueVidalMVP/aks-store-demo/settings/environments
2. Clique em "New environment"
3. Nome: `production`
4. Clique em "Configure environment"
5. (Opcional) Configure proteções de deployment conforme necessário

### 5. Testar o Deploy

Após configurar tudo, faça um push para a branch main ou execute o workflow manualmente:
1. Vá para a aba "Actions" no GitHub
2. Selecione o workflow "Deploy Azure Infrastructure"
3. Clique em "Run workflow"
4. Acompanhe a execução

## VERIFICAÇÃO

Para verificar se as credenciais foram criadas corretamente no Azure Portal:
1. Vá para App registrations > github-actions-aks-workshop
2. Clique em "Certificates & secrets" > "Federated credentials"
3. Você deve ver 3 credenciais listadas:
   - github-main
   - github-production
   - github-pull-request

## TROUBLESHOOTING

Se o erro persistir:
- Verifique se todos os secrets foram adicionados corretamente
- Verifique se as credenciais federadas foram criadas no Azure
- Verifique se o Service Principal tem permissão de Contributor na subscription
- Aguarde alguns minutos após criar as credenciais (pode haver delay de propagação)
