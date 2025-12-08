#!/bin/bash

# Script สำหรับแก้ไขปัญหา Docker Daemon ไม่ทำงาน

echo "🔧 Fixing Docker Daemon..."
echo ""

# Reset failed state
echo "🔄 Resetting failed state..."
sudo systemctl reset-failed docker.service
sudo systemctl reset-failed docker.socket

# Stop Docker socket และ service
echo "🛑 Stopping Docker services..."
sudo systemctl stop docker.socket
sudo systemctl stop docker.service

# ตรวจสอบ containerd
echo "📦 Checking containerd..."
sudo systemctl start containerd
sudo systemctl enable containerd

# ตรวจสอบ Docker socket
echo "📡 Checking Docker socket..."
if [ -S /var/run/docker.sock ]; then
    echo "   Removing old socket..."
    sudo rm /var/run/docker.sock
fi

# Start Docker socket
echo "🚀 Starting Docker socket..."
sudo systemctl start docker.socket
sudo systemctl enable docker.socket

# Wait a moment
sleep 2

# Start Docker service
echo "🚀 Starting Docker service..."
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Wait a moment
sleep 3

# ตรวจสอบ status
echo ""
echo "📊 Docker Service Status:"
sudo systemctl status docker.service --no-pager -l | head -20

# ตรวจสอบ Docker
echo ""
echo "✅ Testing Docker:"
if docker --version &> /dev/null; then
    docker --version
    docker compose version
    echo ""
    echo "✅ Docker is working!"
else
    echo "❌ Docker is still not working. Checking logs..."
    echo ""
    echo "📋 Recent error logs:"
    sudo journalctl -u docker.service --no-pager -n 20 | grep -i error
    echo ""
    echo "Try running manually to see error:"
    echo "  sudo dockerd --debug"
fi


