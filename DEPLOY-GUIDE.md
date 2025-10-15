# 🚀 Deploy Automático do AKS via GitHub Actions - Guia Completo

## 📋 PRÉ-REQUISITOS

✅ App Registration criado: `github-actions-aks-workshop`
✅ Service Principal criado com permissão Contributor
✅ Workflow do GitHub Actions criado

## 🎯 CONFIGURAÇÃO EM 3 ETAPAS

### ETAPA 1: Configurar Credenciais Federadas no Azure Portal (5 minutos)

#### 1.1 Acessar o Azure Portal
🔗 https://portal.azure.com

#### 1.2 Navegar para App Registrations
1. Na barra de pesquisa do Portal, digite: `App registrations`
2. Clique em **App registrations**
3. Encontre e clique em: **github-actions-aks-workshop**

#### 1.3 Configurar Certificates & Secrets
1. No menu lateral esquerdo, clique em: **Certificates & secrets**
2. Clique na aba: **Federated credentials**
3. Clique no botão: **+ Add credential**

#### 1.4 Adicionar as 3 Credenciais Federadas

**CREDENCIAL 1 - Branch Main:**
```
Federated credential scenario: GitHub Actions deploying Azure resources
Organization: JosueVidalMVP
Repository: aks-store-demo
Entity type: Branch
GitHub branch name: main
Name: github-main
Description: GitHub Actions for main branch
```
👉 Clique em **Add**

**CREDENCIAL 2 - Environment Production:**
```
Federated credential scenario: GitHub Actions deploying Azure resources
Organization: JosueVidalMVP
Repository: aks-store-demo
Entity type: Environment
Environment name: production
Name: github-production
Description: GitHub Actions for production environment
```
👉 Clique em **Add**

**CREDENCIAL 3 - Pull Requests:**
```
Federated credential scenario: GitHub Actions deploying Azure resources
Organization: JosueVidalMVP
Repository: aks-store-demo
Entity type: Pull Request
Name: github-pull-request
Description: GitHub Actions for pull requests
```
👉 Clique em **Add**

---

### ETAPA 2: Configurar Secrets no GitHub (3 minutos)

#### 2.1 Acessar Configurações do Repositório
🔗 https://github.com/JosueVidalMVP/aks-store-demo/settings/secrets/actions

#### 2.2 Adicionar os Secrets

**SECRET 1:**
1. Clique em: **New repository secret**
2. Name: `AZURE_CLIENT_ID`
3. Secret: `3827ee33-2db1-4bc3-8f55-4bec42299f96`
4. Clique em: **Add secret**

**SECRET 2:**
1. Clique em: **New repository secret**
2. Name: `AZURE_TENANT_ID`
3. Secret: `f70185a9-cf8d-4d9f-ae3e-aa6e02e41011`
4. Clique em: **Add secret**

**SECRET 3:**
1. Clique em: **New repository secret**
2. Name: `AZURE_SUBSCRIPTION_ID`
3. Secret: `97fdf769-4f92-407b-83ec-0e2958b92cf4`
4. Clique em: **Add secret**

---

### ETAPA 3: Criar Environment no GitHub (2 minutos)

#### 3.1 Acessar Environments
🔗 https://github.com/JosueVidalMVP/aks-store-demo/settings/environments

#### 3.2 Criar o Environment Production
1. Clique em: **New environment**
2. Name: `production`
3. Clique em: **Configure environment**
4. (Opcional) Adicione Required reviewers se quiser aprovação manual
5. Clique em: **Save protection rules**

---

## 🎬 EXECUTAR O DEPLOY

### Opção 1: Commit e Push (Automático)

```bash
git add .
git commit -m "feat: Configure automated AKS deployment via GitHub Actions"
git push origin main
```

O workflow será executado automaticamente! 🚀

### Opção 2: Execução Manual

1. 🔗 Vá para: https://github.com/JosueVidalMVP/aks-store-demo/actions
2. Clique no workflow: **Deploy Azure Infrastructure**
3. Clique no botão: **Run workflow** (lado direito)
4. Selecione a branch: `main`
5. Clique em: **Run workflow**

---

## 📊 MONITORAR O DEPLOY

### Acompanhar no GitHub Actions
1. 🔗 https://github.com/JosueVidalMVP/aks-store-demo/actions
2. Clique na execução mais recente
3. Acompanhe o progresso em tempo real

### Verificar no Azure Portal
1. 🔗 https://portal.azure.com
2. Procure por: `Resource groups`
3. Abra o resource group: **workshop**
4. Você verá os recursos sendo criados:
   - AKS Cluster
   - Virtual Network
   - Network Security Groups
   - Managed Identity
   - Container Registry (opcional)

---

## 🔍 VERIFICAÇÃO PÓS-DEPLOY

### No GitHub
✅ Vá para: Actions → Deploy Azure Infrastructure → Última execução
✅ Todas as etapas devem estar com ✓ verde

### No Azure Portal
✅ Resource Group "workshop" criado
✅ AKS Cluster criado e rodando
✅ Todos os recursos provisionados

### Via Azure CLI (Opcional)
```powershell
# Listar resource groups
az group list --output table

# Listar recursos no resource group workshop
az resource list --resource-group workshop --output table

# Obter credenciais do AKS
az aks list --resource-group workshop --output table

# Conectar ao AKS
az aks get-credentials --resource-group workshop --name <aks-cluster-name>

# Verificar nodes
kubectl get nodes
```

---

## ⏱️ TEMPO ESTIMADO DE DEPLOY

- **Configuração das credenciais**: 5 minutos
- **Configuração dos secrets**: 3 minutos
- **Criação do environment**: 2 minutos
- **Deploy do AKS via GitHub Actions**: 15-20 minutos

**TOTAL**: ~30 minutos

---

## 🔄 CI/CD AUTOMÁTICO

Após a configuração inicial, o deploy será **100% automático**:

### Triggers Automáticos:
1. **Push para main**: Deploy automático quando houver alterações em `infra/terraform/**`
2. **Pull Requests**: Apenas validação (Terraform Plan)
3. **Manual**: Pode executar manualmente quando quiser

### Fluxo de CI/CD:
```
Commit → Push → GitHub Actions → Azure Login → Create RG → 
Terraform Init → Terraform Plan → Terraform Apply → AKS Deployed! ✅
```

---

## 📝 O QUE O WORKFLOW FAZ AUTOMATICAMENTE

1. ✅ Faz checkout do código
2. ✅ Faz login no Azure via OIDC (sem senha!)
3. ✅ Cria o Resource Group "workshop"
4. ✅ Inicializa o Terraform
5. ✅ Valida a configuração do Terraform
6. ✅ Cria um plano de execução (Terraform Plan)
7. ✅ Aplica as mudanças (Terraform Apply)
8. ✅ Provisiona o AKS com todos os recursos

---

## 🎯 RECURSOS QUE SERÃO CRIADOS

Baseado no arquivo `workshop.tfvars.json`:

- ✅ AKS Cluster (Azure Kubernetes Service)
- ✅ Azure Container Registry (ACR)
- ✅ Virtual Network
- ✅ Subnets
- ✅ Network Security Groups
- ✅ Managed Identity para Workload Identity
- ✅ Role Assignments

**Recursos OPCIONAIS** (desabilitados por padrão):
- ❌ Azure Service Bus
- ❌ Azure Cosmos DB
- ❌ Azure OpenAI
- ❌ Observability Tools (Prometheus/Grafana)

---

## 🆘 TROUBLESHOOTING

### Erro: "No matching federated identity record found"
**Solução**: 
- Verifique se as 3 credenciais federadas foram criadas no Azure Portal
- Aguarde 5 minutos para propagação
- Tente executar o workflow novamente

### Erro: "Login failed"
**Solução**:
- Confirme que os 3 secrets estão configurados corretamente no GitHub
- Verifique se os valores estão corretos (sem espaços extras)
- Verifique se o Service Principal tem permissão Contributor

### Erro: "Environment not found"
**Solução**:
- Confirme que o environment "production" foi criado no GitHub
- Vá para: Settings → Environments → Confirme que existe "production"

### Terraform Errors
**Solução**:
- Verifique os logs detalhados no GitHub Actions
- Confirme que você está logado na subscription correta
- Verifique se há quotas disponíveis para criar recursos

---

## 📚 PRÓXIMOS PASSOS

Após o deploy do AKS:

1. **Conectar ao cluster**:
   ```bash
   az aks get-credentials --resource-group workshop --name <cluster-name>
   kubectl get nodes
   ```

2. **Fazer deploy da aplicação**:
   ```bash
   kubectl apply -f aks-store-quickstart.yaml
   ```

3. **Configurar Ingress** (opcional)

4. **Configurar monitoramento** (opcional)

---

## 🎉 PRONTO!

Após seguir essas 3 etapas, você terá um pipeline de CI/CD completamente automatizado que fará o deploy do AKS no Azure sempre que houver mudanças no código Terraform!

**Links rápidos para configuração:**
- Azure Portal: https://portal.azure.com
- GitHub Secrets: https://github.com/JosueVidalMVP/aks-store-demo/settings/secrets/actions
- GitHub Environments: https://github.com/JosueVidalMVP/aks-store-demo/settings/environments
- GitHub Actions: https://github.com/JosueVidalMVP/aks-store-demo/actions
