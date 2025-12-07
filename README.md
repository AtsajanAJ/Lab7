# L07 - Clicker App Deployment (Microkernel Architecture)

โปรเจคสำหรับ Build, Publish และ Deploy Clicker Application บน Docker Hub และ VM

## 📋 เนื้อหา

โปรเจคนี้แสดงวิธีการ:
- ✅ Build Docker images สำหรับ production
- ✅ Publish images ไปยัง Docker Hub
- ✅ Deploy บน VM ด้วย docker-compose
- ✅ เพิ่ม API Gateway (Nginx) สำหรับ routing
- ✅ สร้าง Plugin 2 เวอร์ชัน (P1: +2, P2: +5)

## 📁 โครงสร้างโปรเจค

```
clicker-app-deployment/
├── clicker-frontend/
│   ├── Dockerfile.production    # Multi-stage build (React + Nginx)
│   └── nginx.conf               # Nginx config for frontend
│
├── clicker-backend/
│   ├── Dockerfile.production    # Production build
│   ├── server.production.js     # Production server (no CORS, port 8000)
│   └── clicker.proto            # gRPC proto file
│
├── clicker-plugin-P1/
│   ├── Dockerfile.production    # Plugin P1 (increment by 2)
│   ├── plugin.js
│   ├── clicker.proto
│   └── package.json
│
├── clicker-plugin-P2/
│   ├── Dockerfile.production    # Plugin P2 (increment by 5)
│   ├── plugin.js
│   ├── clicker.proto
│   └── package.json
│
├── docker-compose.yml           # Deployment configuration
├── nginx_gateway.conf           # API Gateway configuration
├── build-and-push.sh            # Build script (Linux/Mac)
├── build-and-push.ps1           # Build script (Windows)
└── env.example                  # Environment variables template
```

## 🚀 ขั้นตอนการใช้งาน

### **Step 1: เตรียม Source Code**

ก่อน build คุณต้อง copy source code จาก L06:

```bash
# Copy frontend source code
cp -r ../L06/clicker-app/clicker-frontend/* clicker-frontend/

# Copy backend source code (ถ้ายังไม่มี)
cp ../L06/clicker-app/clicker-backend/clicker.proto clicker-backend/
```

### **Step 2: Build & Push ไปยัง Docker Hub**

#### 2.1 Login Docker Hub

```bash
docker login
```

#### 2.2 Build และ Push Images

**Windows (PowerShell):**
```powershell
.\build-and-push.ps1 -Username your_username -Tag v1
```

**Linux/Mac:**
```bash
chmod +x build-and-push.sh
./build-and-push.sh your_username v1
```

**Manual Build (ถ้าต้องการ build แยก):**

```bash
# Frontend
cd clicker-frontend
docker build -t <username>/clicker-frontend:v1 -f Dockerfile.production .
docker push <username>/clicker-frontend:v1

# Backend
cd ../clicker-backend
docker build -t <username>/clicker-backend:v1 -f Dockerfile.production .
docker push <username>/clicker-backend:v1

# Plugin P1
cd ../clicker-plugin-P1
docker build -t <username>/clicker-plugin:P1 -f Dockerfile.production .
docker push <username>/clicker-plugin:P1

# Plugin P2
cd ../clicker-plugin-P2
docker build -t <username>/clicker-plugin:P2 -f Dockerfile.production .
docker push <username>/clicker-plugin:P2
```

### **Step 3: Deploy บน VM**

#### 3.1 สร้าง .env file บน VM

```bash
# บน VM
cd /path/to/clicker-app-deployment
cp env.example .env
nano .env
```

แก้ไขค่าใน `.env`:
```env
TAG=v1
USERNAME=your_dockerhub_username
PLUGIN_TAG=P1
IP_ADDRESS=your_vm_ip_address
```

#### 3.2 Deploy Services

```bash
docker compose up -d
```

#### 3.3 ทดสอบ

```bash
# ตรวจสอบ services
docker compose ps

# ดู logs
docker compose logs -f

# ทดสอบ API
curl http://localhost/api/health
```

### **Step 4: เพิ่ม API Gateway (Nginx)**

API Gateway ถูกตั้งค่าไว้ใน `docker-compose.yml` แล้ว:

- **Route `/`** → Frontend (port 3000)
- **Route `/api`** → Backend (port 8000)
- **Listen on port 80**

**เข้าถึงแอปพลิเคชัน:**
```
http://<vm_ip_address>/
```

### **Step 5: สลับ Plugin Version (P1 ↔ P2)**

#### 5.1 ใช้ Plugin P1 (Increment by 2)

แก้ไข `.env`:
```env
PLUGIN_TAG=P1
```

Restart services:
```bash
docker compose up -d
```

ทดสอบ: กดปุ่ม → ตัวเลขเพิ่มขึ้น **2**

#### 5.2 ใช้ Plugin P2 (Increment by 5)

แก้ไข `.env`:
```env
PLUGIN_TAG=P2
```

Restart services:
```bash
docker compose up -d
```

ทดสอบ: กดปุ่ม → ตัวเลขเพิ่มขึ้น **5**

## 🔧 Configuration

### Port Configuration

- **Frontend**: Expose port 3000 (internal)
- **Backend**: Expose port 8000 (internal)
- **Plugin**: Expose port 50001 (internal)
- **Gateway**: Publish port 80 (external)

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TAG` | Docker image tag | `v1` |
| `USERNAME` | Docker Hub username | - |
| `PLUGIN_TAG` | Plugin version (P1 or P2) | `P1` |
| `IP_ADDRESS` | VM IP address (documentation) | - |

## 📝 API Endpoints

### Backend API (via Gateway)

- **POST** `/api/click`
  - Request: `{ "currentCount": 0 }`
  - Response: `{ "newCount": 2, "message": "..." }`

- **GET** `/api/health`
  - Response: `{ "status": "ok", "service": "clicker-backend" }`

### Frontend

- **GET** `/` - Main application

## 🎯 Plugin Versions

### Plugin P1
- **Algorithm**: Increment by 2
- **Image**: `<username>/clicker-plugin:P1`
- **Logic**: `newCount = currentCount + 2`

### Plugin P2
- **Algorithm**: Increment by 5
- **Image**: `<username>/clicker-plugin:P2`
- **Logic**: `newCount = currentCount + 5`

## 🐛 Troubleshooting

### Images not found
```bash
# ตรวจสอบว่า images ถูก push ไป Docker Hub แล้ว
docker pull <username>/clicker-frontend:v1
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

# ตรวจสอบ network
docker network inspect clicker-app-deployment_clicker-network
```

## ✅ Checklist

- [x] สร้าง Dockerfile.production สำหรับทุก component
- [x] สร้าง Multi-stage build สำหรับ Frontend
- [x] สร้าง Nginx Gateway configuration
- [x] สร้าง Plugin P1 และ P2
- [x] สร้าง docker-compose.yml สำหรับ deployment
- [x] สร้าง build scripts
- [x] สร้าง documentation

## 📚 สิ่งที่ได้เรียนรู้

1. **Production Docker Images**: Multi-stage builds, optimization
2. **Docker Hub**: Publishing and versioning images
3. **API Gateway**: Nginx routing and load balancing
4. **Microkernel Pattern**: Plugin versioning and switching
5. **VM Deployment**: Docker Compose on remote servers

## 🔗 Related Projects

- **L06**: Clicker App Development (Microkernel Architecture)
- **L05**: gRPC Calculator Service

