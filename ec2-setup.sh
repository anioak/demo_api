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
mkdir -p /home/ec2-user/demo_api
cd /home/ec2-user/demo_api

echo ">>> Cloning your repo..."
git clone https://github.com/anioak/demo_api.git .

echo ">>> Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo ">>> Creating systemd service..."
sudo tee /etc/systemd/system/demo_api.service > /dev/null <<EOF
[Unit]
Description=FastAPI Demo App
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/demo_api
ExecStart=/home/ec2-user/demo_api/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=3
Environment=PATH=/home/ec2-user/demo_api/venv/bin:/usr/bin

[Install]
WantedBy=multi-user.target
EOF

echo ">>> Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable demo_api
sudo systemctl start demo_api

echo ""
echo "=== DONE ==="
echo "Your FastAPI app is running on port 8000"
echo "Check status:  sudo systemctl status demo_api"
echo "View logs:     sudo journalctl -u demo_api -f"
echo ""
echo "REMINDER: Open port 8000 in your EC2 Security Group!"
