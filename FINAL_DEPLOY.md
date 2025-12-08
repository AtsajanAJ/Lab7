# 🚀 Final Deployment Steps

## ✅ สถานะปัจจุบัน
- ✅ โปรเจค clone แล้ว
- ✅ ไฟล์ครบถ้วน
- ✅ .env file มีอยู่แล้ว
- ⏳ ต้องแก้ไขปัญหา Docker
- ⏳ ต้อง pull images และ deploy

---

## Step 1: ตรวจสอบ .env file

```bash
# ดูเนื้อหาใน .env
cat .env
```

**ต้องมีค่า:**
```env
TAG=v1
USERNAME=aj0811
PLUGIN_TAG=P1
IP_ADDRESS=192.168.200.3
```

**ถ้ายังไม่ถูกต้อง:**
```bash
nano .env
# แก้ไขค่าให้ถูกต้อง
```

---

## Step 2: แก้ไขปัญหา Docker

### วิธีที่ 1: Reset และ Restart

```bash
# Reset failed state
sudo systemctl reset-failed docker.service docker.socket

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# Restart Docker socket
sudo systemctl restart docker.socket
sudo systemctl enable docker.socket

# Wait a moment
sleep 2

# Restart Docker service
sudo systemctl restart docker.service
sudo systemctl enable docker.service

# ตรวจสอบ
sudo systemctl status docker
```

### วิธีที่ 2: ใช้ Script

```bash
chmod +x fix-docker-daemon.sh
./fix-docker-daemon.sh
```

### วิธีที่ 3: ดู Error Logs (ถ้ายังไม่ได้)

```bash
# ดู error logs
sudo journalctl -u docker.service --no-pager -n 50

# หรือลอง start แบบ manual
sudo dockerd --debug
```

---

## Step 3: ตรวจสอบ Docker ทำงาน

```bash
# ตรวจสอบ
docker --version
docker compose version

# ควรเห็น version numbers
```

---

## Step 4: Pull Images และ Deploy

```bash
# Pull images จาก Docker Hub
docker compose pull

# Deploy services
docker compose up -d

# ตรวจสอบ status
docker compose ps
```

---

## Step 5: ตรวจสอบ Logs

```bash
# ดู logs ทั้งหมด
docker compose logs -f

# หรือดู logs แยก
docker compose logs clicker-plugin
docker compose logs clicker-backend
docker compose logs clicker-frontend
docker compose logs clicker-gateway
```

---

## Step 6: ทดสอบ Application

```bash
# ทดสอบ API
curl http://localhost/api/health

# ควรได้ response:
# {"status":"ok","service":"clicker-backend"}
```

**จาก Windows Browser:**
```
http://192.168.200.3/
```

---

## Step 7: สลับ Plugin Version

### ใช้ Plugin P1 (Increment by 2)

```bash
nano .env
# แก้ไข: PLUGIN_TAG=P1

docker compose up -d
```

### ใช้ Plugin P2 (Increment by 5)

```bash
nano .env
# แก้ไข: PLUGIN_TAG=P2

docker compose up -d
```

---

## 🔧 Troubleshooting

### Docker still not working

```bash
# ดู error logs
sudo journalctl -u docker.service --no-pager -n 50

# ลอง reinstall Docker
sudo apt remove docker-ce docker-ce-cli
sudo apt install docker-ce docker-ce-cli
```

### Images not found

```bash
# Pull images ใหม่
docker compose pull

# ตรวจสอบ images
docker images | grep aj0811
```

### Services not starting

```bash
# ดู logs
docker compose logs

# Restart services
docker compose restart
```

---

## ✅ Checklist

- [ ] ตรวจสอบ .env file
- [ ] แก้ไขปัญหา Docker
- [ ] Pull images (`docker compose pull`)
- [ ] Deploy services (`docker compose up -d`)
- [ ] ตรวจสอบ status (`docker compose ps`)
- [ ] ทดสอบ API (`curl http://localhost/api/health`)
- [ ] ทดสอบ Frontend (`http://192.168.200.3/`)
- [ ] ทดสอบ Plugin P1 และ P2


