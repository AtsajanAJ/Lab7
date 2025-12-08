# 🚀 คู่มือ Deploy บน Ubuntu Server (VirtualBox)

## 📋 สิ่งที่ต้องมี

- ✅ VirtualBox Ubuntu Lite Server
- ✅ Docker และ Docker Compose ติดตั้งแล้ว
- ✅ SSH access ไปยัง VM
- ✅ IP Address ของ VM

---

## Step 1: ตรวจสอบ Docker บน Ubuntu Server

```bash
# เช็คว่า Docker ติดตั้งแล้ว
docker --version
docker compose version

# ถ้ายังไม่มี ให้ติดตั้ง:
# sudo apt update
# sudo apt install docker.io docker-compose-plugin
# sudo usermod -aG docker $USER
# (logout และ login ใหม่)
```

---

## Step 2: Upload Files ไปยัง Ubuntu Server

### Option A: ใช้ SCP (จาก Windows PowerShell)

```powershell
# ตรวจสอบ IP ของ Ubuntu VM ก่อน
# บน Ubuntu: ip addr show

# Upload จาก Windows
scp -r C:\Architecture\L07\clicker-app-deployment ubuntu@<vm_ip>:/home/ubuntu/
```

### Option B: ใช้ Git (แนะนำ)

```powershell
# บน Windows: Push ไป Git
cd C:\Architecture\L07\clicker-app-deployment
git init
git add .
git commit -m "Deployment files"
git remote add origin <your_repo_url>
git push

# บน Ubuntu: Clone จาก Git
git clone <your_repo_url>
cd clicker-app-deployment
```

### Option C: ใช้ USB/Shared Folder

1. Copy โฟลเดอร์ `clicker-app-deployment` ไปยัง shared folder
2. บน Ubuntu: Copy จาก shared folder

---

## Step 3: สร้าง .env file บน Ubuntu

```bash
# บน Ubuntu Server
cd ~/clicker-app-deployment

# Copy template
cp env.example .env

# แก้ไข .env
nano .env
```

**เนื้อหาใน .env:**
```env
TAG=v1
USERNAME=aj0811
PLUGIN_TAG=P1
IP_ADDRESS=<vm_ip_address>
```

**ตัวอย่าง:**
```env
TAG=v1
USERNAME=aj0811
PLUGIN_TAG=P1
IP_ADDRESS=192.168.1.100
```

**บันทึก:** `Ctrl + O` แล้ว `Enter`, `Ctrl + X` เพื่อออก

---

## Step 4: Pull Images และ Deploy

```bash
# Pull images จาก Docker Hub
docker compose pull

# Deploy services
docker compose up -d

# ตรวจสอบ status
docker compose ps

# ดู logs
docker compose logs -f
```

---

## Step 5: ตรวจสอบ IP Address ของ VM

```bash
# บน Ubuntu Server
ip addr show

# หรือ
hostname -I
```

**บันทึก IP Address** (เช่น `192.168.1.100`)

---

## Step 6: ทดสอบ Application

### จากเครื่อง Host (Windows)

```powershell
# ทดสอบ API
curl http://<vm_ip>/api/health

# หรือเปิด browser
# http://<vm_ip>/
```

### จาก Ubuntu Server

```bash
# ทดสอบ API
curl http://localhost/api/health

# หรือ
curl http://127.0.0.1/api/health
```

---

## Step 7: สลับ Plugin Version

### ใช้ Plugin P1 (Increment by 2)

```bash
# แก้ไข .env
nano .env
# แก้ไข: PLUGIN_TAG=P1

# Restart services
docker compose up -d

# ทดสอบ: กดปุ่ม → ตัวเลขเพิ่มขึ้น 2
```

### ใช้ Plugin P2 (Increment by 5)

```bash
# แก้ไข .env
nano .env
# แก้ไข: PLUGIN_TAG=P2

# Restart services
docker compose up -d

# ทดสอบ: กดปุ่ม → ตัวเลขเพิ่มขึ้น 5
```

---

## 🔧 Troubleshooting

### Docker permission denied

```bash
# เพิ่ม user เข้า docker group
sudo usermod -aG docker $USER

# Logout และ login ใหม่
exit
# SSH เข้ามาใหม่
```

### Port 80 already in use

```bash
# ตรวจสอบ port ที่ใช้
sudo netstat -tulpn | grep :80

# หยุด service ที่ใช้ port 80
sudo systemctl stop apache2  # หรือ nginx
```

### Images not found

```bash
# Pull images ใหม่
docker compose pull

# ตรวจสอบ images
docker images | grep aj0811
```

### Cannot connect to services

```bash
# ตรวจสอบ network
docker network inspect clicker-app-deployment_clicker-network

# ตรวจสอบ logs
docker compose logs clicker-plugin
docker compose logs clicker-backend
docker compose logs clicker-frontend
```

---

## 📝 คำสั่งที่มีประโยชน์

```bash
# ดู status ของ services
docker compose ps

# ดู logs
docker compose logs -f
docker compose logs clicker-plugin
docker compose logs clicker-backend

# Restart service
docker compose restart clicker-plugin

# Stop services
docker compose down

# Start services
docker compose up -d

# Rebuild และ restart
docker compose up -d --force-recreate
```

---

## ✅ Checklist

- [ ] Docker และ Docker Compose ติดตั้งแล้วบน Ubuntu
- [ ] Upload files ไปยัง Ubuntu Server
- [ ] สร้าง .env file
- [ ] Pull images จาก Docker Hub
- [ ] Deploy services (`docker compose up -d`)
- [ ] ทดสอบ API (`curl http://localhost/api/health`)
- [ ] ทดสอบ Frontend (`http://<vm_ip>/`)
- [ ] ทดสอบ Plugin P1 (increment by 2)
- [ ] ทดสอบ Plugin P2 (increment by 5)

---

## 🎯 สรุป

1. **Upload files** ไปยัง Ubuntu Server
2. **สร้าง .env** file
3. **Pull images** และ **deploy**
4. **ทดสอบ** application
5. **สลับ plugin** version และทดสอบ

---

## 📞 ถ้ามีปัญหา

1. ตรวจสอบ Docker: `docker --version`
2. ตรวจสอบ logs: `docker compose logs`
3. ตรวจสอบ network: `docker network ls`
4. ตรวจสอบ IP: `ip addr show`


