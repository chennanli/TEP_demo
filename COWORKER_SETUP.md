# 👥 Coworker Setup Guide

**Welcome! This guide will get you running the TEP RCA System in 10 minutes.**

---

## ⚡ Quick Start (For Impatient Coworkers)

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/TEP_demo.git
cd TEP_demo

# 2. Setup API keys
cp .env.template .env
# Edit .env with your API keys (see below)

# 3. Run setup
./SETUP_FIRST_TIME.command

# 4. Start the system
./START_ALL.command

# 5. Open browser
# http://127.0.0.1:9002
```

**Done! Click "🚀 Ultra Start" button in the browser.**

---

## 📋 Detailed Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/TEP_demo.git
cd TEP_demo
```

---

### Step 2: Get API Keys (5 minutes)

You need API keys for **Claude** and **Gemini** to use AI-powered root cause analysis.

#### Option A: Anthropic Claude (Recommended)
1. Go to: https://console.anthropic.com/settings/keys
2. Sign up (free $5 credit for new users)
3. Click "Create Key"
4. Copy the key (starts with `sk-ant-api03-...`)

#### Option B: Google Gemini (Free Tier Available)
1. Go to: https://aistudio.google.com/apikey
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the key (starts with `AIzaSy...`)

#### Option C: Local LLM (No API Key Needed)
- Install LM Studio: https://lmstudio.ai/
- Download a model (e.g., "qwen-7b")
- Start local server (File → Start Local Server)
- **No API key needed** but slower performance

---

### Step 3: Configure API Keys

```bash
# Copy the template
cp .env.template .env

# Edit the file
nano .env  # or use any text editor
```

Replace the placeholders with your actual keys:

**Before** (.env.template):
```bash
ANTHROPIC_API_KEY=sk-ant-xxxxx-your-key-here
GEMINI_API_KEY=AIzaSyXXXXX-your-key-here
```

**After** (.env):
```bash
ANTHROPIC_API_KEY=sk-ant-api03-XXXXX-REDACTED-XXXXX...  # Your real key
GEMINI_API_KEY=AIzaSyXXXXX-REDACTED-XXXXX      # Your real key
```

**Save and close the file.**

---

### Step 4: Install Build Tools (Required!)

**IMPORTANT**: Before running setup, install Xcode Command Line Tools (includes GCC compiler):

```bash
xcode-select --install
```

**A popup will appear** - click "Install" and wait 5-10 minutes.

**Why needed?** Some Python packages need to compile C/C++ code during installation.

---

### Step 5: Install Python 3.12

**Check Python version**:
```bash
python3 --version
```

**If Python 3.9 or older**, install Python 3.12:
```bash
# Install via Homebrew
brew install python@3.12

# Verify
python3.12 --version
# Should show: Python 3.12.x
```

---

### Step 6: Setup Virtual Environment & Install Dependencies

**IMPORTANT**: Don't use the setup scripts yet - they may have issues. Do this manually:

```bash
cd /Users/[your_name]/Desktop/LLM_Project/TEP_demo

# Create virtual environment with Python 3.12
python3.12 -m venv .venv

# Activate it
source .venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Python packages (5-10 minutes)
pip install -r requirements.txt

# Install frontend packages (3-5 minutes)
cd frontend
npm install
cd ..

# Create .env
cp .env.template .env
```

**Expected output:**
```
✓ Virtual environment created: .venv/
✓ pip upgraded
✓ Python packages installed (fastapi, anthropic, genai, etc.)
✓ Frontend packages installed
✓ .env file created
```

---

### Step 5: Start the System

```bash
./START_ALL.command
```

**What happens:**
1. Unified Console starts on port 9002
2. Browser should auto-open to http://127.0.0.1:9002
3. You'll see the control panel interface

**If browser doesn't open:**
- Manually open: http://127.0.0.1:9002

---

### Step 6: Start Services

In the browser control panel:

1. Click **"🚀 Ultra Start"** button (one-click startup)
   - This starts Backend (port 8000) + Frontend (port 5173) + Simulation

**OR** start individually:
- Click "Backend Start" (green button)
- Click "Frontend Start" (blue button)
- Click "Start Simulation" (purple button)

---

### Step 7: Verify Everything Works

1. Check **System Status** panel:
   - ✅ Backend: Running (port 8000)
   - ✅ Frontend: Running (port 5173)
   - ✅ Simulation: Active

2. Open **DCS Screen**: Click "DCS Screen" tab
   - Should show live process data
   - Trend lines updating in real-time

3. Test **Anomaly Detection**:
   - Go to "IDV Controls" section
   - Click checkbox: IDV(1) - A Feed Composition
   - Wait 3-5 minutes
   - Should see "🚨 ANOMALY DETECTED" message
   - LLM analysis should appear with root cause

---

## 🛑 Stopping the System

```bash
./STOP_ALL.command
```

This kills:
- ✅ Unified Console
- ✅ Backend API
- ✅ Frontend
- ✅ TEP Simulation
- ✅ TEP Bridge (if running)

**Always use this script!** Don't just close terminals.

---

## 🐛 Troubleshooting

### Problem: "Cannot execute .command files" or "Move to Trash"

**Cause**: Files copied without executable permissions

**Solution:**
```bash
cd /Users/[your_name]/Desktop/LLM_Project/TEP_demo

# Make files executable
chmod +x *.command *.sh

# OR just use bash to run them
bash START_ALL.command
```

---

### Problem: ".command files not working" - Better: Use git clone

**Issue**: Copying the folder loses file permissions

**Solution**: Delete copied folder and clone from GitHub instead:
```bash
rm -rf /Users/[your_name]/Desktop/LLM_Project/TEP_demo
cd /Users/[your_name]/Desktop/LLM_Project
git clone https://github.com/chennanli/TEP_demo.git
cd TEP_demo
```

Git preserves all permissions correctly! ✅

---

### Problem: "GCC compiler needed" or "xcode-select needed"

**Cause**: Missing C/C++ compiler for Python packages

**Solution:**
```bash
xcode-select --install
```

Click "Install" in popup, wait 5-10 minutes. This is **required** for scientific Python packages.

---

### Problem: "Python 3.12 not found" (have Python 3.9)

**Cause**: Wrong Python version

**Solution:**
```bash
# Install Python 3.12
brew install python@3.12

# Verify
python3.12 --version
```

**IMPORTANT**: Python 3.9 is TOO OLD. Must use Python 3.12!

---

### Problem: "Failed to install Python dependencies"

**Cause**: Using system Python or wrong version

**Solution:**
```bash
# Use Python 3.12 explicitly
python3.12 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

---

### Problem: "config.json file not found"

**Cause**: Old repo clone before config.json was added

**Solution:**
```bash
cd /Users/[your_name]/Desktop/LLM_Project/TEP_demo
git pull origin main
ls -la config/config.json  # Should exist now
```

---

### Problem: "Backend failed to start - unknown error"

**Causes & Solutions**:

**1. Port 8000 already in use**:
```bash
lsof -ti:8000
kill -9 $(lsof -ti:8000)
```

**2. Missing dependencies**:
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

**3. .env file missing**:
```bash
cp .env.template .env
open -a TextEdit .env
# Add API keys
```

**4. See actual error**:
```bash
source .venv/bin/activate
cd backend
python app.py
# Copy the error message
```

---

### Problem: "DCS Screen shows 'waiting for live data'"

**Cause**: Simulation not started

**Solution:**
1. In browser control panel, click **"🚀 Ultra Start"**
2. Wait 10 seconds for all services to start
3. In DCS Screen tab, select **"Live (stream)"** from dropdown
4. Data should flow!

---

### Problem: "Node.js not found"

**Solution:**
```bash
brew install node
```

---

### Problem: "Port 8000 already in use"

**Solution:**
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9

# Restart
./START_ALL.command
```

---

### Problem: ".env file not found"

**Solution:**
```bash
# Create from template
cp .env.template .env

# Edit with your keys
nano .env
```

---

### Problem: "Backend not reachable" error

**Possible causes:**
1. Backend not started → Click "Backend Start" button
2. Port 8000 blocked → Check firewall settings
3. API keys invalid → Verify .env file has correct keys

**Check backend logs:**
```bash
# In the unified console terminal output
# Look for errors like:
# "❌ Invalid API key"
# "❌ Anthropic authentication failed"
```

---

### Problem: "LLM request timed out"

**Solution:**
- This is normal for first request (cold start)
- Gemini timeout increased to 180 seconds
- Wait and try again
- If persists, check internet connection

---

## 💰 Cost Protection

**Built-in safety features:**

1. **30-minute auto-shutdown** (default)
   - Premium LLMs auto-disable after 30 minutes
   - Prevents runaway costs

2. **60-second rate limit** (default)
   - Maximum 1 LLM request per 60 seconds
   - Adjustable in control panel

3. **Manual emergency stop**
   - Click "Stop Everything" button
   - Or run `./STOP_ALL.command`

**Estimated costs:**
- Claude: ~$0.015 per analysis
- Gemini: ~$0.0002 per analysis (negligible)
- LMStudio: **FREE** (local)

**30-minute demo session:**
- ~10-20 analyses
- **Total cost: $0.30 - $0.60** (very cheap!)

---

## 📁 Project Structure

```
TEP_demo/
├── START_ALL.command          # ⭐ Main startup script
├── STOP_ALL.command            # ⭐ Emergency shutdown
├── SETUP_FIRST_TIME.command    # ⭐ First-time setup
├── .env                        # 🔒 YOUR API KEYS (not in git)
├── .env.template               # 📄 Template for .env
├── README.md                   # 📖 Main documentation
├── COWORKER_SETUP.md          # 👥 This file!
├── backend/                    # Python FastAPI backend
├── frontend/                   # React TypeScript frontend
├── templates/                  # Unified console HTML
├── config/                     # Configuration files
├── docs/                       # Documentation
└── scripts/                    # Utility scripts (rarely used)
```

**Files you'll edit:**
- ✅ `.env` - API keys
- ⚠️ `config/config.json` - System settings (optional)

**Files you won't touch:**
- ❌ Everything else (unless you're developing)

---

## 🎓 Learning the System

### Recommended order:

1. **Start with DCS Screen**
   - Watch normal operation (5 minutes)
   - Observe process trends

2. **Trigger simple fault**
   - IDV(1) - A Feed Composition
   - Watch anomaly detection activate
   - Read LLM root cause analysis

3. **Try different faults**
   - IDV(13) - Reaction Kinetics (slow drift)
   - IDV(6) - A Feed Loss (step change)
   - IDV(8) - Composition Random Walk

4. **Explore features**
   - Load History (past analyses)
   - Data Analysis (export results)
   - System Logs (debugging)

---

## 💡 Tips for Demos

### Best single-fault demo:
**Use IDV(13) - Reaction Kinetics Drift**

**Why:**
- ✅ 20-30 minute early warning (very impressive!)
- ✅ PCA detects at 10 minutes
- ✅ DCS alarms at 40 minutes
- ✅ Shows predictive capability

**Demo script:**
```
1. Start normal operation
2. Click IDV(13) checkbox
3. Narrate: "Simulating slow catalyst degradation..."
4. Wait 10 min → PCA anomaly ✅
5. Narrate: "PCA detected it already!"
6. Wait 40 min → DCS alarms ❌
7. Narrate: "Traditional alarms MUCH later!"
```

### Best combo-fault demo:
**Use IDV(1) + IDV(4)** (current default)

**Why:**
- ✅ 9-minute early warning
- ✅ Step changes (easy to see)
- ✅ Multivariate propagation
- ✅ Faster than IDV(13) (less waiting)

---

## 🆘 Getting Help

### First steps:
1. Check terminal output for errors
2. Check `backend/diagnostics/ingest.log` for backend errors
3. Check browser console (F12) for frontend errors

### Contact:
- Project lead: [Your name/email]
- Documentation: README.md, docs/
- Issues: GitHub Issues (if applicable)

---

## ✅ Success Checklist

After setup, you should be able to:
- [ ] Open http://127.0.0.1:9002 (unified console)
- [ ] See DCS Screen with live data
- [ ] Trigger fault (IDV checkbox)
- [ ] See "🚨 ANOMALY DETECTED" message
- [ ] Read LLM root cause analysis (Claude, Gemini)
- [ ] Load past analysis history
- [ ] Export results to PDF

**If all checkboxes ✅ → You're ready to go!**

---

## 🎉 You're All Set!

**Questions? Issues?**
- Re-read this guide
- Check README.md
- Ask project lead

**Happy fault diagnosing!** 🔧🎛️🤖
