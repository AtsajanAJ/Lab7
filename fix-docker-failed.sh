#!/bin/bash

# Script สำหรับแก้ไขปัญหา Docker Service Failed

echo "🔧 Diagnosing Docker Service Failure..."
echo ""

# Reset failed state
echo "🔄 Resetting failed state..."
sudo systemctl reset-failed docker.service

# ดู error logs
echo "📋 Checking Docker error logs..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo journalctl -u docker.service --no-pager -n 50 | grep -i error
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ตรวจสอบ Docker socket
echo "📡 Checking Docker socket..."
if [ -S /var/run/docker.sock ]; then
    echo "   Docker socket exists"
    ls -la /var/run/docker.sock
else
    echo "   Docker socket not found"
fi

# ตรวจสอบ Docker directory
echo ""
echo "📁 Checking Docker directories..."
sudo ls -la /var/lib/docker/ 2>/dev/null || echo "   /var/lib/docker/ does not exist"

# ตรวจสอบ Docker daemon config
echo ""
echo "⚙️  Checking Docker daemon configuration..."
if [ -f /etc/docker/daemon.json ]; then
    echo "   daemon.json exists:"
    cat /etc/docker/daemon.json
else
    echo "   daemon.json does not exist"
fi

# ลอง start Docker daemon แบบ manual เพื่อดู error
echo ""
echo "🧪 Testing Docker daemon manually..."
echo "   (This will show the actual error)"
echo ""
sudo dockerd --debug 2>&1 | head -20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Common fixes:"
echo ""
echo "1. If permission error:"
echo "   sudo chmod 666 /var/run/docker.sock"
echo ""
echo "2. If directory error:"
echo "   sudo mkdir -p /var/lib/docker"
echo "   sudo chown root:root /var/lib/docker"
echo ""
echo "3. If config error:"
echo "   sudo rm /etc/docker/daemon.json"
echo ""
echo "4. Reinstall Docker:"
echo "   sudo apt remove docker-ce docker-ce-cli"
echo "   sudo apt install docker-ce docker-ce-cli"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


