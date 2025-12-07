#!/bin/bash

# Script สำหรับติดตั้ง Docker และ Docker Compose บน Ubuntu Server
# Usage: chmod +x install-docker-ubuntu.sh && ./install-docker-ubuntu.sh

set -e  # Exit on error

echo "🔧 Installing Docker and Docker Compose on Ubuntu Server..."
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "❌ Please do not run as root. Run as regular user with sudo privileges."
   exit 1
fi

# Update package list
echo "📦 Step 1/8: Updating package list..."
sudo apt update

# Install prerequisites
echo "📦 Step 2/8: Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
echo "🔑 Step 3/8: Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings

# Remove old key if exists
if [ -f /etc/apt/keyrings/docker.gpg ]; then
    echo "   Removing old Docker GPG key..."
    sudo rm /etc/apt/keyrings/docker.gpg
fi

# Download and add GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo "📦 Step 4/8: Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
echo "📦 Step 5/8: Updating package list with Docker repository..."
sudo apt update

# Install Docker Engine, CLI, and Docker Compose
echo "📦 Step 6/8: Installing Docker Engine, CLI, and Docker Compose..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
echo "👤 Step 7/8: Adding user to docker group..."
sudo usermod -aG docker $USER

# Start and enable Docker
echo "🚀 Step 8/8: Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation (using sudo because group change needs logout)
echo ""
echo "✅ Verifying installation..."
sudo docker --version
sudo docker compose version

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Docker and Docker Compose installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  IMPORTANT: Please logout and login again for group changes to take effect."
echo ""
echo "After logging in again, verify with:"
echo "  docker --version"
echo "  docker compose version"
echo ""
echo "Then you can proceed with deployment:"
echo "  1. cd ~/clicker-app-deployment"
echo "  2. cp env.example .env"
echo "  3. nano .env  # Edit with your settings"
echo "  4. docker compose pull"
echo "  5. docker compose up -d"
echo ""

