# Script para configurar credenciais federadas do GitHub no Azure
# Execute este script no Azure Cloud Shell ou com Azure CLI atualizado

$APP_ID = "3827ee33-2db1-4bc3-8f55-4bec42299f96"
$REPO = "JosueVidalMVP/aks-store-demo"

Write-Host "=== Configurando credenciais federadas para GitHub Actions ===" -ForegroundColor Green

# Obter o Object ID do aplicativo
$APP_OBJECT_ID = $(az ad app show --id $APP_ID --query id -o tsv)
Write-Host "App Object ID: $APP_OBJECT_ID"

# Obter token de acesso
$TOKEN = $(az account get-access-token --resource https://graph.microsoft.com --query accessToken -o tsv)

# 1. Criar credencial federada para branch main
$body1 = @{
    name = "github-main"
    issuer = "https://token.actions.githubusercontent.com"
    subject = "repo:$REPO:ref:refs/heads/main"
    audiences = @("api://AzureADTokenExchange")
    description = "GitHub Actions for main branch"
} | ConvertTo-Json

Write-Host "`nCriando credencial federada para branch main..." -ForegroundColor Yellow

Invoke-RestMethod -Method POST `
    -Uri "https://graph.microsoft.com/beta/applications/$APP_OBJECT_ID/federatedIdentityCredentials" `
    -Headers @{
        "Authorization" = "Bearer $TOKEN"
        "Content-Type" = "application/json"
    } `
    -Body $body1

Write-Host "✓ Credencial para main branch criada" -ForegroundColor Green

# 2. Criar credencial federada para environment production
$body2 = @{
    name = "github-production"
    issuer = "https://token.actions.githubusercontent.com"
    subject = "repo:$REPO:environment:production"
    audiences = @("api://AzureADTokenExchange")
    description = "GitHub Actions for production environment"
} | ConvertTo-Json

Write-Host "`nCriando credencial federada para production environment..." -ForegroundColor Yellow

Invoke-RestMethod -Method POST `
    -Uri "https://graph.microsoft.com/beta/applications/$APP_OBJECT_ID/federatedIdentityCredentials" `
    -Headers @{
        "Authorization" = "Bearer $TOKEN"
        "Content-Type" = "application/json"
    } `
    -Body $body2

Write-Host "✓ Credencial para production environment criada" -ForegroundColor Green

# 3. Criar credencial federada para Pull Requests
$body3 = @{
    name = "github-pull-request"
    issuer = "https://token.actions.githubusercontent.com"
    subject = "repo:$REPO:pull_request"
    audiences = @("api://AzureADTokenExchange")
    description = "GitHub Actions for pull requests"
} | ConvertTo-Json

Write-Host "`nCriando credencial federada para Pull Requests..." -ForegroundColor Yellow

Invoke-RestMethod -Method POST `
    -Uri "https://graph.microsoft.com/beta/applications/$APP_OBJECT_ID/federatedIdentityCredentials" `
    -Headers @{
        "Authorization" = "Bearer $TOKEN"
        "Content-Type" = "application/json"
    } `
    -Body $body3

Write-Host "✓ Credencial para Pull Requests criada" -ForegroundColor Green

Write-Host "`n=== Configuracao concluida com sucesso! ===" -ForegroundColor Green
Write-Host "`n=== Adicione estes valores aos GitHub Secrets ===" -ForegroundColor Cyan
Write-Host "AZURE_CLIENT_ID: $APP_ID" -ForegroundColor White
Write-Host "AZURE_TENANT_ID: f70185a9-cf8d-4d9f-ae3e-aa6e02e41011" -ForegroundColor White
Write-Host "AZURE_SUBSCRIPTION_ID: 97fdf769-4f92-407b-83ec-0e2958b92cf4" -ForegroundColor White
