#!/bin/bash
# =============================================================
# EC2 SETUP SCRIPT — Run this ONCE on a fresh Amazon Linux EC2
# Usage:  chmod +x ec2-setup.sh && ./ec2-setup.sh
# =============================================================

set -e

echo ">>> Updating system packages..."
sudo yum update -y

echo ">>> Installing Python & pip & git..."
sudo yum install -y python3 python3-pip git

echo ">>> Creating app directory..."
mkdir -p /home/ec2-user/fastapi-demo
cd /home/ec2-user/fastapi-demo

echo ">>> Cloning your repo (replace with your actual repo URL)..."
# git clone https://github.com/YOUR_USERNAME/fastapi-demo.git .

echo ">>> Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo ">>> Creating systemd service..."
sudo tee /etc/systemd/system/fastapi-demo.service > /dev/null <<EOF
[Unit]
Description=FastAPI Demo App
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/fastapi-demo
ExecStart=/home/ec2-user/fastapi-demo/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=3
Environment=PATH=/home/ec2-user/fastapi-demo/venv/bin:/usr/bin

[Install]
WantedBy=multi-user.target
EOF

echo ">>> Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable fastapi-demo
sudo systemctl start fastapi-demo

echo ""
echo "=== DONE ==="
echo "Your FastAPI app is running on port 8000"
echo "Check status:  sudo systemctl status fastapi-demo"
echo "View logs:     sudo journalctl -u fastapi-demo -f"
echo ""
echo "REMINDER: Open port 8000 in your EC2 Security Group!"
