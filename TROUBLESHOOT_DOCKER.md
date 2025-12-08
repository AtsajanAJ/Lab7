# 🔧 แก้ไขปัญหา Docker Service ไม่สามารถ Start ได้

## ปัญหา
```
Job for docker.service failed because the control process exited with error code.
```

## วิธีแก้ไข

### Step 1: ตรวจสอบ Error Logs

```bash
# ดู error logs
sudo journalctl -xeu docker.service

# หรือ
sudo systemctl status docker.service
```

### Step 2: ตรวจสอบและแก้ไขปัญหาที่พบบ่อย

#### ปัญหา 1: containerd ไม่ทำงาน

```bash
# ตรวจสอบ containerd
sudo systemctl status containerd

# Start containerd
sudo systemctl start containerd
sudo systemctl enable containerd

# Start Docker อีกครั้ง
sudo systemctl start docker
```

#### ปัญหา 2: iptables หรือ firewall

```bash
# ตรวจสอบ iptables
sudo iptables -L

# Flush iptables (ถ้าจำเป็น)
sudo iptables -F
sudo iptables -X

# Start Docker อีกครั้ง
sudo systemctl start docker
```

#### ปัญหา 3: Docker socket permission

```bash
# ตรวจสอบ socket
ls -la /var/run/docker.sock

# แก้ไข permission
sudo chmod 666 /var/run/docker.sock

# หรือ restart Docker
sudo systemctl restart docker
```

#### ปัญหา 4: Reinstall Docker (ถ้าจำเป็น)

```bash
# Uninstall Docker
sudo apt remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# ติดตั้งใหม่
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 3: ตรวจสอบ VirtualBox Settings

ถ้าใช้ VirtualBox อาจต้อง:
- Enable Virtualization ใน BIOS
- เพิ่ม RAM ให้ VM (อย่างน้อย 2GB)
- Enable VT-x/AMD-V ใน VirtualBox settings

---

## Quick Fix Script

```bash
# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# Restart Docker
sudo systemctl restart docker
sudo systemctl enable docker

# ตรวจสอบ status
sudo systemctl status docker
```


