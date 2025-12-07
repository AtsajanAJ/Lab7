# 🔧 แก้ไขปัญหา Docker Installation

## ปัญหา
คำสั่งผิดพลาด: ลืมใส่ชื่อไฟล์ output

## แก้ไข

### คำสั่งที่ถูกต้อง:

```bash
# Add Docker GPG key (แก้ไข: เพิ่ม docker.gpg)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### ขั้นตอนต่อเนื่อง:

```bash
# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Logout และ login ใหม่
exit
```

