# Build and Push Script for Clicker App (PowerShell)
# Usage: .\build-and-push.ps1 -Username <username> -Tag <tag>

param(
    [string]$Username = "your_username",
    [string]$Tag = "v1"
)

Write-Host "🔨 Building and pushing Docker images..." -ForegroundColor Cyan
Write-Host "Username: $Username"
Write-Host "Tag: $Tag"
Write-Host ""

# Build and push Frontend
Write-Host "📦 Building clicker-frontend..." -ForegroundColor Yellow
Set-Location clicker-frontend
docker build -t "${Username}/clicker-frontend:${Tag}" -f Dockerfile.production .
docker push "${Username}/clicker-frontend:${Tag}"
Set-Location ..

# Build and push Backend
Write-Host "📦 Building clicker-backend..." -ForegroundColor Yellow
Set-Location clicker-backend
docker build -t "${Username}/clicker-backend:${Tag}" -f Dockerfile.production .
docker push "${Username}/clicker-backend:${Tag}"
Set-Location ..

# Build and push Plugin P1
Write-Host "📦 Building clicker-plugin P1..." -ForegroundColor Yellow
Set-Location clicker-plugin-P1
docker build -t "${Username}/clicker-plugin:P1" -f Dockerfile.production .
docker push "${Username}/clicker-plugin:P1"
Set-Location ..

# Build and push Plugin P2
Write-Host "📦 Building clicker-plugin P2..." -ForegroundColor Yellow
Set-Location clicker-plugin-P2
docker build -t "${Username}/clicker-plugin:P2" -f Dockerfile.production .
docker push "${Username}/clicker-plugin:P2"
Set-Location ..

Write-Host ""
Write-Host "✅ All images built and pushed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Images:"
Write-Host ('  - ' + $Username + '/clicker-frontend:' + $Tag)
Write-Host ('  - ' + $Username + '/clicker-backend:' + $Tag)
Write-Host ('  - ' + $Username + '/clicker-plugin:P1')
Write-Host ('  - ' + $Username + '/clicker-plugin:P2')

