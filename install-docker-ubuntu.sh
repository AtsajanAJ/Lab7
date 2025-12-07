#!/bin/bash

# Script สำหรับติดตั้ง Docker และ Docker Compose บน Ubuntu Server

echo "🔧 Installing Docker and Docker Compose on Ubuntu Server..."

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install prerequisites
echo "📦 Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
echo "🔑 Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo "📦 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt update

# Install Docker Engine, CLI, and Docker Compose
echo "📦 Installing Docker Engine, CLI, and Docker Compose..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Start and enable Docker
echo "🚀 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
echo "✅ Verifying installation..."
docker --version
docker compose version

echo ""
echo "✅ Docker and Docker Compose installed successfully!"
echo "⚠️  Please logout and login again for group changes to take effect."
echo ""
echo "After logging in again, verify with:"
echo "  docker --version"
echo "  docker compose version"

