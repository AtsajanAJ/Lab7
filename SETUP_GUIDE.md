# 🚀 คู่มือการ Setup และ Deploy Clicker App

## 📍 สรุป: ตอนไหนต้องใช้ VM?

- ✅ **Phase 1 (Build & Push)**: ทำบนเครื่อง local **ไม่ต้องใช้ VM**
- ✅ **Phase 2 (Deploy)**: ต้องใช้ VM

---

## Phase 1: Build & Push Images (Local Machine) 🖥️

### Step 1: เตรียม Source Code

```powershell
# ไปที่โฟลเดอร์ L07
cd C:\Architecture\L07\clicker-app-deployment

# Copy frontend source code จาก L06
Copy-Item -Recurse ..\..\L06\clicker-app\clicker-frontend\* clicker-frontend\ -Force

# Copy backend package.json (ถ้ายังไม่มี)
Copy-Item ..\..\L06\clicker-app\clicker-backend\package.json clicker-backend\ -ErrorAction SilentlyContinue
```

### Step 2: Login Docker Hub

```powershell
docker login
# ใส่ username และ password ของ Docker Hub
```

### Step 3: Build และ Push Images

**ใช้ Script (แนะนำ):**
```powershell
# แทนที่ your_username ด้วย Docker Hub username ของคุณ
.\build-and-push.ps1 -Username your_username -Tag v1
```
Username: aj0811
password: Tanwa1812!

**หรือ Build แยกทีละตัว:**

```powershell
# 1. Frontend
cd clicker-frontend
docker build -t your_username/clicker-frontend:v1 -f Dockerfile.production .
docker push your_username/clicker-frontend:v1
cd ..

# 2. Backend
cd clicker-backend
docker build -t your_username/clicker-backend:v1 -f Dockerfile.production .
docker push your_username/clicker-backend:v1
cd ..

# 3. Plugin P1
cd clicker-plugin-P1
docker build -t your_username/clicker-plugin:P1 -f Dockerfile.production .
docker push your_username/clicker-plugin:P1
cd ..

# 4. Plugin P2
cd clicker-plugin-P2
docker build -t your_username/clicker-plugin:P2 -f Dockerfile.production .
docker push your_username/clicker-plugin:P2
cd ..
```

### Step 4: ตรวจสอบ Images บน Docker Hub

ไปที่ https://hub.docker.com และตรวจสอบว่า images ถูก push แล้ว:
- `your_username/clicker-frontend:v1`
- `your_username/clicker-backend:v1`
- `your_username/clicker-plugin:P1`
- `your_username/clicker-plugin:P2`

---

## Phase 2: Deploy บน VM (ต้องใช้ VM) 🖥️☁️

### Step 1: เตรียม VM

**สิ่งที่ต้องมีบน VM:**
- ✅ Docker และ Docker Compose ติดตั้งแล้ว
- ✅ SSH access ไปยัง VM
- ✅ IP Address ของ VM

### Step 2: Upload Files ไปยัง VM

**Option A: ใช้ SCP**
```powershell
# Upload โฟลเดอร์ deployment ไปยัง VM
scp -r C:\Architecture\L07\clicker-app-deployment user@vm_ip:/home/user/
```

**Option B: ใช้ Git (แนะนำ)**
```powershell
# บน local: push ไป Git
git init
git add .
git commit -m "Deployment files"
git remote add origin <your_repo_url>
git push

# บน VM: clone จาก Git
git clone <your_repo_url>
cd clicker-app-deployment
```

**Option C: สร้างไฟล์บน VM โดยตรง**
```bash
# บน VM: สร้างไฟล์ docker-compose.yml และ .env
mkdir clicker-app-deployment
cd clicker-app-deployment
```

### Step 3: สร้าง .env file บน VM

```bash
# บน VM
cd clicker-app-deployment
nano .env
```

**เนื้อหาใน .env:**
```env
TAG=v1
USERNAME=your_dockerhub_username
PLUGIN_TAG=P1
IP_ADDRESS=your_vm_ip_address
```

**ตัวอย่าง:**
```env
TAG=v1
USERNAME=atsajanaj
PLUGIN_TAG=P1
IP_ADDRESS=192.168.1.100
```

### Step 4: Deploy Services

```bash
# บน VM
cd clicker-app-deployment

# Pull images จาก Docker Hub
docker compose pull

# Start services
docker compose up -d

# ตรวจสอบ status
docker compose ps

# ดู logs
docker compose logs -f
```

### Step 5: ทดสอบ

```bash
# ทดสอบ API
curl http://localhost/api/health

# หรือเปิด browser ไปที่
# http://<vm_ip_address>/
```

---

## Phase 3: สลับ Plugin Version (บน VM) 🔄

### สลับเป็น Plugin P1 (Increment by 2)

```bash
# บน VM
cd clicker-app-deployment
nano .env
# แก้ไข: PLUGIN_TAG=P1

docker compose up -d
```

### สลับเป็น Plugin P2 (Increment by 5)

```bash
# บน VM
cd clicker-app-deployment
nano .env
# แก้ไข: PLUGIN_TAG=P2

docker compose up -d
```

---

## 📋 Checklist

### Phase 1 (Local) ✅
- [ ] Copy source code จาก L06
- [ ] Login Docker Hub
- [ ] Build images (frontend, backend, plugin P1, plugin P2)
- [ ] Push images ไป Docker Hub
- [ ] ตรวจสอบ images บน Docker Hub

### Phase 2 (VM) ✅
- [ ] เตรียม VM (Docker, Docker Compose)
- [ ] Upload files ไปยัง VM
- [ ] สร้าง .env file
- [ ] Deploy services (`docker compose up -d`)
- [ ] ทดสอบ application

### Phase 3 (VM) ✅
- [ ] ทดสอบ Plugin P1 (increment by 2)
- [ ] ทดสอบ Plugin P2 (increment by 5)
- [ ] สลับ plugin version และแสดงผลที่ต่างกัน

---

## 🐛 Troubleshooting

### Images not found
```bash
# ตรวจสอบว่า images ถูก push แล้ว
docker pull your_username/clicker-frontend:v1
```

### Port conflicts
```bash
# ตรวจสอบ port ที่ใช้
netstat -tulpn | grep :80
```

### Plugin connection error
```bash
# ตรวจสอบ plugin logs
docker compose logs clicker-plugin
```

---

## 📞 คำถามที่พบบ่อย

**Q: ต้องใช้ VM จริงๆ ไหม?**  
A: ใช่ สำหรับ Phase 2 (Deploy) ต้องใช้ VM หรือ server ที่มี Docker

**Q: ใช้ Docker Desktop บน local ได้ไหม?**  
A: ได้ แต่ควร deploy บน VM เพื่อให้เหมือน production environment

**Q: VM ต้องมีอะไรบ้าง?**  
A: Docker, Docker Compose, และ internet connection เพื่อ pull images

**Q: ใช้ Cloud VM ได้ไหม?**  
A: ได้ (AWS EC2, Google Cloud, Azure, DigitalOcean, etc.)

