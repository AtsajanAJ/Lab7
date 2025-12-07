#!/bin/bash

# Script สำหรับแก้ไขปัญหา Docker Service

echo "🔧 Fixing Docker Service..."
echo ""

# Start containerd (ถ้ายังไม่ทำงาน)
echo "📦 Starting containerd..."
sudo systemctl start containerd
sudo systemctl enable containerd

# ตรวจสอบ Docker service status
echo "📊 Checking Docker service status..."
sudo systemctl status docker.service --no-pager -l

# ดู error logs
echo ""
echo "📋 Docker service logs:"
sudo journalctl -xeu docker.service --no-pager -n 20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Please check the error messages above and try:"
echo ""
echo "1. Restart Docker:"
echo "   sudo systemctl restart docker"
echo ""
echo "2. Check Docker daemon:"
echo "   sudo dockerd --debug"
echo ""
echo "3. If still failing, try:"
echo "   sudo systemctl daemon-reload"
echo "   sudo systemctl restart docker"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

