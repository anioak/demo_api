# GEN AI Demo API

A simple FastAPI app deployed to AWS EC2 via GitHub Actions. Built to demo **GNE AI's** error-fixing capabilities.

## Endpoints

| Method | Path             | Description       |
|--------|------------------|-------------------|
| GET    | `/`              | Welcome message   |
| GET    | `/health`        | Health check      |
| POST   | `/items`         | Create an item    |
| GET    | `/items`         | List all items    |
| GET    | `/items/{id}`    | Get single item   |
| DELETE | `/items/{id}`    | Delete an item    |

## Setup

### 1. Launch an EC2 Instance
- AMI: **Ubuntu 22.04 LTS**
- Instance type: **t2.micro** (free tier)
- Open **port 8000** in the Security Group

### 2. Run the Setup Script on EC2
```bash
chmod +x ec2-setup.sh
./ec2-setup.sh
```

### 3. Configure GitHub Secrets
In your GitHub repo → Settings → Secrets → Actions, add:

| Secret        | Value                          |
|---------------|--------------------------------|
| `EC2_HOST`    | Your EC2 public IP             |
| `EC2_USER`    | `ubuntu`                       |
| `EC2_SSH_KEY` | Contents of your `.pem` file   |

### 4. Push to `main`
Every push to `main` triggers automatic deployment.

## Demo Flow (for GNE AI showcase)
1. Show the working API at `http://<EC2_IP>:8000`
2. Introduce bugs in `main.py` (typos, logic errors, missing imports)
3. Push the broken code to GitHub
4. Let **GEN AI** detect and fix the errors
5. Push the fix → auto-deploys → API works again
