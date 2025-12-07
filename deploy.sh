#!/bin/bash

# Script สำหรับ Deploy Clicker App บน Ubuntu Server
# Usage: chmod +x deploy.sh && ./deploy.sh

set -e  # Exit on error

echo "🚀 Deploying Clicker App..."
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp env.example .env
    echo ""
    echo "⚠️  Please edit .env file with your settings:"
    echo "   nano .env"
    echo ""
    echo "Required settings:"
    echo "   TAG=v1"
    echo "   USERNAME=aj0811"
    echo "   PLUGIN_TAG=P1"
    echo "   IP_ADDRESS=<your_vm_ip>"
    echo ""
    read -p "Press Enter after editing .env file..."
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please run install-docker-ubuntu.sh first."
    exit 1
fi

# Check if Docker Compose is installed
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please run install-docker-ubuntu.sh first."
    exit 1
fi

# Check if user is in docker group
if ! groups | grep -q docker; then
    echo "⚠️  User is not in docker group."
    echo "   Please logout and login again after running install-docker-ubuntu.sh"
    exit 1
fi

# Get VM IP address
echo "📡 Detecting VM IP address..."
VM_IP=$(hostname -I | awk '{print $1}')
echo "   Detected IP: $VM_IP"
echo ""

# Update .env with detected IP if not set
if grep -q "IP_ADDRESS=your_vm_ip_address" .env 2>/dev/null || ! grep -q "IP_ADDRESS=" .env 2>/dev/null; then
    echo "📝 Updating .env with detected IP address..."
    if grep -q "IP_ADDRESS=" .env; then
        sed -i "s/IP_ADDRESS=.*/IP_ADDRESS=$VM_IP/" .env
    else
        echo "IP_ADDRESS=$VM_IP" >> .env
    fi
    echo "   Updated IP_ADDRESS to $VM_IP"
    echo ""
fi

# Pull images
echo "📦 Pulling Docker images from Docker Hub..."
docker compose pull

# Deploy services
echo "🚀 Deploying services..."
docker compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 5

# Check status
echo ""
echo "📊 Service Status:"
docker compose ps

# Test API
echo ""
echo "🧪 Testing API..."
sleep 3
if curl -s http://localhost/api/health > /dev/null; then
    echo "✅ API is responding!"
    curl http://localhost/api/health
else
    echo "⚠️  API is not responding yet. Please check logs:"
    echo "   docker compose logs"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Deployment completed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Access the application:"
echo "   http://$VM_IP/"
echo ""
echo "📝 Useful commands:"
echo "   docker compose ps          # Check status"
echo "   docker compose logs -f     # View logs"
echo "   docker compose restart     # Restart services"
echo "   docker compose down        # Stop services"
echo ""
echo "🔄 To switch plugin version:"
echo "   1. nano .env"
echo "   2. Change PLUGIN_TAG to P1 or P2"
echo "   3. docker compose up -d"
echo ""

