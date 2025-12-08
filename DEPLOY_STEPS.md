# 🚀 ขั้นตอน Deploy บน Ubuntu VM (หลังจาก Clone แล้ว)

## ✅ สถานะปัจจุบัน
- ✅ Clone โปรเจคจาก Git แล้ว
- ⏳ ต้องติดตั้ง Docker และ Docker Compose
- ⏳ ต้องสร้าง .env file
- ⏳ ต้อง deploy services

---

## Step 1: ติดตั้ง Docker และ Docker Compose

### ตรวจสอบว่ามี Docker แล้วหรือยัง

```bash
docker --version
docker compose version
```

### ถ้ายังไม่มี ให้ติดตั้ง:

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

# Logout และ login ใหม่ (สำคัญ!)
exit
# SSH เข้ามาใหม่
```

### ตรวจสอบการติดตั้ง

```bash
docker --version
docker compose version
```

---

## Step 2: ไปที่โฟลเดอร์โปรเจค

```bash
cd ~/clicker-app-deployment
# หรือ
cd /path/to/clicker-app-deployment
```

---

## Step 3: สร้าง .env file

```bash
# Copy template
cp env.example .env

# แก้ไข .env
nano .env
```

**แก้ไขเนื้อหาใน .env เป็น:**

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

**บันทึก:** 
- `Ctrl + O` (เขียน)
- `Enter` (ยืนยัน)
- `Ctrl + X` (ออก)

---

## Step 4: ตรวจสอบ IP Address ของ VM

```bash
# ตรวจสอบ IP
ip addr show

# หรือ
hostname -I
```

**บันทึก IP Address** (เช่น `192.168.1.100`) และอัพเดทใน `.env` file

---

## Step 5: Pull Images จาก Docker Hub

```bash
# Pull images ทั้งหมด
docker compose pull
```

**จะ pull images:**
- `aj0811/clicker-frontend:v1`
- `aj0811/clicker-backend:v1`
- `aj0811/clicker-plugin:P1` (หรือ P2 ตาม PLUGIN_TAG)

---

## Step 6: Deploy Services

```bash
# Deploy services
docker compose up -d

# ตรวจสอบ status
docker compose ps
```

**ควรเห็น services:**
- `clicker-frontend`
- `clicker-backend`
- `clicker-plugin`
- `clicker-gateway`

---

## Step 7: ตรวจสอบ Logs

```bash
# ดู logs ทั้งหมด
docker compose logs -f

# หรือดู logs แยก
docker compose logs clicker-plugin
docker compose logs clicker-backend
docker compose logs clicker-frontend
docker compose logs clicker-gateway
```

**กด `Ctrl + C` เพื่อออกจาก logs**

---

## Step 8: ทดสอบ Application

### ทดสอบ API

```bash
# ทดสอบ health check
curl http://localhost/api/health

# ควรได้ response:
# {"status":"ok","service":"clicker-backend"}
```

### ทดสอบ Frontend

**จาก Windows Browser:**
```
http://<vm_ip_address>/
```

**ตัวอย่าง:**
```
http://192.168.1.100/
```

---

## Step 9: สลับ Plugin Version (ทดสอบ)

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

## 🔧 คำสั่งที่มีประโยชน์

```bash
# ดู status
docker compose ps

# ดู logs
docker compose logs -f

# Restart service
docker compose restart clicker-plugin

# Stop services
docker compose down

# Start services
docker compose up -d

# Rebuild และ restart
docker compose up -d --force-recreate

# ดู network
docker network ls
docker network inspect clicker-app-deployment_clicker-network
```

---

## 🐛 Troubleshooting

### Permission denied

```bash
# เพิ่ม user เข้า docker group
sudo usermod -aG docker $USER

# Logout และ login ใหม่
exit
```

### Port 80 already in use

```bash
# ตรวจสอบ port
sudo netstat -tulpn | grep :80

# หยุด service
sudo systemctl stop apache2
# หรือ
sudo systemctl stop nginx
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
# ตรวจสอบ logs
docker compose logs

# ตรวจสอบ network
docker network inspect clicker-app-deployment_clicker-network

# Restart services
docker compose restart
```

---

## ✅ Checklist

- [ ] ติดตั้ง Docker และ Docker Compose
- [ ] Logout และ login ใหม่
- [ ] ไปที่โฟลเดอร์โปรเจค
- [ ] สร้าง .env file
- [ ] ตรวจสอบ IP Address
- [ ] Pull images (`docker compose pull`)
- [ ] Deploy services (`docker compose up -d`)
- [ ] ตรวจสอบ status (`docker compose ps`)
- [ ] ทดสอบ API (`curl http://localhost/api/health`)
- [ ] ทดสอบ Frontend (`http://<vm_ip>/`)
- [ ] ทดสอบ Plugin P1 (increment by 2)
- [ ] ทดสอบ Plugin P2 (increment by 5)

---

## 🎯 สรุปขั้นตอน

1. **ติดตั้ง Docker** → `sudo apt install docker-ce docker-compose-plugin`
2. **Logout/Login** → `exit` แล้ว SSH เข้ามาใหม่
3. **สร้าง .env** → `cp env.example .env` แล้วแก้ไข
4. **Pull images** → `docker compose pull`
5. **Deploy** → `docker compose up -d`
6. **ทดสอบ** → `curl http://localhost/api/health` และเปิด browser

---

## 📞 ถ้ามีปัญหา

1. ตรวจสอบ Docker: `docker --version`
2. ตรวจสอบ logs: `docker compose logs`
3. ตรวจสอบ network: `docker network ls`
4. ตรวจสอบ IP: `ip addr show`


