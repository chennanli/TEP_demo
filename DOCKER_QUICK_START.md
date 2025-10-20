# 🐳 TEP Demo - Docker Quick Start Guide

**One-command deployment for Mac, Windows, and Linux**

---

## 📋 Prerequisites

### 1. Install Docker Desktop

**Mac:**
```bash
# Download from: https://docs.docker.com/desktop/setup/install/mac-install/
# Or use Homebrew:
brew install --cask docker
```

**Windows:**
```bash
# Download from: https://docs.docker.com/desktop/setup/install/windows-install/
```

**Linux:**
```bash
# Ubuntu/Debian:
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER  # Add yourself to docker group
```

### 2. Verify Installation

```bash
docker --version
# Expected: Docker version 24.0.0 or higher

docker-compose --version
# Expected: Docker Compose version 2.20.0 or higher
```

---

## 🚀 Quick Start (3 Steps)

### Step 1: Clone the Repository

```bash
git clone https://github.com/chennanli/TEP_demo.git
cd TEP_demo
```

### Step 2: Configure API Keys

```bash
# Copy the template
cp .env.template .env

# Edit .env and add your API keys
nano .env  # or use any text editor
```

**Required API Keys:**
```bash
# Anthropic (Claude)
ANTHROPIC_API_KEY=sk-ant-xxxxx

# Google (Gemini)
GEMINI_API_KEY=AIza-xxxxx

# Optional: LMStudio (if running locally)
LMSTUDIO_URL=http://host.docker.internal:1234
```

Get your API keys:
- **Claude**: https://console.anthropic.com/
- **Gemini**: https://aistudio.google.com/app/apikey

### Step 3: Start the System

```bash
# Build and start all services
docker-compose up -d

# View logs (optional)
docker-compose logs -f
```

**That's it!** 🎉

---

## 🌐 Access the System

Once started, open your browser:

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:5173 | React UI for data visualization |
| **Backend API** | http://localhost:8000 | FastAPI backend (API docs at /docs) |
| **Unified Console** | http://localhost:9002 | Flask control panel |

---

## 🛠️ Common Commands

### Start the System
```bash
docker-compose up -d
```

### Stop the System
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Restart a Service
```bash
docker-compose restart backend
```

### Rebuild After Code Changes
```bash
# Rebuild all services
docker-compose up -d --build

# Rebuild specific service
docker-compose up -d --build backend
```

### Check Service Status
```bash
docker-compose ps
```

### Access Container Shell
```bash
# Backend container
docker-compose exec backend bash

# Frontend container
docker-compose exec frontend sh
```

---

## 🔧 Troubleshooting

### Issue 1: Port Already in Use

**Error:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:8000: bind: address already in use
```

**Solution:**
```bash
# Find and kill the process using the port
lsof -ti:8000 | xargs kill -9

# Or change the port in docker-compose.yml
ports:
  - "8001:8000"  # Use 8001 instead of 8000
```

### Issue 2: API Keys Not Working

**Error:**
```
AuthenticationError: Invalid API key
```

**Solution:**
```bash
# Verify .env file exists and has correct keys
cat .env

# Restart services to reload environment variables
docker-compose down
docker-compose up -d
```

### Issue 3: Fortran Module Not Found

**Error:**
```
ModuleNotFoundError: No module named 'temain_mod'
```

**Solution:**
```bash
# Rebuild backend with verbose output
docker-compose build --no-cache backend

# Check if .so files are present
docker-compose exec backend ls -la /app/backend/simulation/
```

### Issue 4: Frontend Not Loading

**Error:**
```
Cannot GET /
```

**Solution:**
```bash
# Check if frontend build succeeded
docker-compose logs frontend

# Rebuild frontend
docker-compose up -d --build frontend
```

### Issue 5: LMStudio Connection Failed

**Error:**
```
Connection refused to http://host.docker.internal:1234
```

**Solution:**
```bash
# Verify LMStudio is running on host machine
curl http://localhost:1234/v1/models

# If on Linux, use host IP instead of host.docker.internal
# Find your host IP:
ip addr show docker0 | grep inet

# Update .env:
LMSTUDIO_URL=http://172.17.0.1:1234
```

---

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Network                       │
│                     (tep-network)                       │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Frontend   │  │   Backend    │  │   Console    │ │
│  │  React+Vite  │  │   FastAPI    │  │    Flask     │ │
│  │  Port 5173   │  │  Port 8000   │  │  Port 9002   │ │
│  └──────────────┘  └──────┬───────┘  └──────────────┘ │
│                           │                            │
│                    ┌──────┴──────┐                     │
│                    │             │                     │
│            ┌───────▼──────┐  ┌──▼────────┐            │
│            │ TEP Simulator│  │ LLM Client│            │
│            │  (Fortran)   │  │ Multi-API │            │
│            └──────────────┘  └───────────┘            │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 What's Included

- ✅ **TEP Simulation** - Fortran-based Tennessee Eastman Process
- ✅ **Anomaly Detection** - PyTorch + scikit-learn models
- ✅ **Multi-LLM Analysis** - Claude, Gemini, LMStudio support
- ✅ **RAG System** - Knowledge base with PDF processing
- ✅ **React Frontend** - Real-time data visualization
- ✅ **Flask Console** - System control panel

---

## 📦 Data Persistence

All important data is stored in volumes that persist across container restarts:

| Directory | Purpose |
|-----------|---------|
| `./data/` | TEP simulation data (CSV files) |
| `./RCA_Results/` | Root cause analysis reports |
| `./backend/diagnostics/` | System diagnostics and logs |
| `./backend/LLM_RCA_Results/` | LLM analysis results |

**To backup your data:**
```bash
tar -czf tep-backup-$(date +%Y%m%d).tar.gz data/ RCA_Results/ backend/diagnostics/
```

---

## 🔄 Updating the System

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

---

## 🧹 Cleanup

### Remove Containers (Keep Data)
```bash
docker-compose down
```

### Remove Containers + Volumes (Delete All Data)
```bash
docker-compose down -v
```

### Remove All Docker Images
```bash
docker system prune -a
```

---

## 🆘 Getting Help

1. **Check logs**: `docker-compose logs -f`
2. **Verify services**: `docker-compose ps`
3. **Test connectivity**: `docker-compose exec backend curl http://localhost:8000/`
4. **Rebuild from scratch**: `docker-compose down -v && docker-compose up -d --build`

---

## 📚 Next Steps

- **Production Deployment**: See `DOCKER_PRODUCTION.md` (coming soon)
- **Kubernetes Setup**: See `KUBERNETES_GUIDE.md` (coming soon)
- **CI/CD Pipeline**: See `.github/workflows/docker-build.yml` (coming soon)

---

**Questions?** Open an issue on GitHub or contact the maintainer.

