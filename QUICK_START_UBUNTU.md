# 🚀 Quick Start Guide - Ubuntu Server

## Step 1: ติดตั้ง Docker และ Docker Compose

### วิธีที่ 1: ใช้ Script (แนะนำ)

```bash
# Upload script ไปยัง Ubuntu
# จาก Windows: scp install-docker-ubuntu.sh ubuntu@<vm_ip>:~/

# บน Ubuntu: รัน script
chmod +x install-docker-ubuntu.sh
./install-docker-ubuntu.sh

# Logout และ login ใหม่
exit
# SSH เข้ามาใหม่
```

### วิธีที่ 2: ติดตั้งด้วยตนเอง

```bash
# Update package list
sudo apt update

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list
sudo apt update

# Install Docker Engine, CLI, and Docker Compose
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Logout และ login ใหม่
exit
# SSH เข้ามาใหม่
```

### ตรวจสอบการติดตั้ง

```bash
docker --version
docker compose version
```

---

## Step 2: Upload Files ไปยัง Ubuntu

### จาก Windows PowerShell

```powershell
# ตรวจสอบ IP ของ Ubuntu VM
# บน Ubuntu: ip addr show

# Upload files
scp -r C:\Architecture\L07\clicker-app-deployment ubuntu@<vm_ip>:/home/ubuntu/
```

---

## Step 3: Setup บน Ubuntu

```bash
# ไปที่โฟลเดอร์
cd ~/clicker-app-deployment

# สร้าง .env file
cp env.example .env
nano .env
```

**แก้ไข .env:**
```env
TAG=v1
USERNAME=aj0811
PLUGIN_TAG=P1
IP_ADDRESS=<vm_ip_address>
```

**บันทึก:** `Ctrl + O`, `Enter`, `Ctrl + X`

---

## Step 4: Deploy

```bash
# Pull images
docker compose pull

# Deploy services
docker compose up -d

# ตรวจสอบ status
docker compose ps

# ดู logs
docker compose logs -f
```

---

## Step 5: ทดสอบ

```bash
# ตรวจสอบ IP
ip addr show

# ทดสอบ API
curl http://localhost/api/health

# จาก Windows browser:
# http://<vm_ip>/
```

---

## สลับ Plugin Version

```bash
# แก้ไข .env
nano .env
# แก้ไข: PLUGIN_TAG=P1 หรือ P2

# Restart
docker compose up -d
```

---

## Troubleshooting

### Permission denied

```bash
# เพิ่ม user เข้า docker group
sudo usermod -aG docker $USER

# Logout และ login ใหม่
exit
```

### Port 80 already in use

```bash
# ตรวจสอบ
sudo netstat -tulpn | grep :80

# หยุด service
sudo systemctl stop apache2
# หรือ
sudo systemctl stop nginx
```


