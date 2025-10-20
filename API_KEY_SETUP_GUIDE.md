# 🔑 API Key Setup Guide

**For setting up API keys on a coworker's laptop**

---

## 📍 Where to Find and Edit API Keys

### File Location:
```
/Users/[username]/Desktop/LLM_Project/TEP_demo/.env
```

**IMPORTANT**: The `.env` file is at the **ROOT** of the project folder, NOT in `backend/` or `config/`!

```
TEP_demo/
├── .env              ← API KEYS HERE!
├── .env.template     ← Template (don't edit this!)
├── config/
│   └── config.json   ← Uses ${ENV_VAR} placeholders
├── backend/
├── frontend/
└── ...
```

---

## 🚀 Quick Setup (For Helping Your Coworker)

### Step 1: Navigate to Project Folder
```bash
cd /Users/[coworker_name]/Desktop/LLM_Project/TEP_demo
```

### Step 2: Check if .env Exists
```bash
ls -la .env
```

**If file exists**: Skip to Step 4

**If file NOT found**: Continue to Step 3

### Step 3: Create .env from Template
```bash
cp .env.template .env
```

### Step 4: Open .env File
```bash
# Option A: Use nano (terminal editor)
nano .env

# Option B: Use TextEdit (macOS GUI)
open -a TextEdit .env

# Option C: Use VS Code (if installed)
code .env
```

### Step 5: Edit the API Keys

**BEFORE** (.env.template):
```bash
# API Keys - NEVER commit this file to GitHub!
# This file is in .gitignore and stays LOCAL ONLY

# Anthropic Claude API
ANTHROPIC_API_KEY=sk-ant-xxxxx-your-key-here

# Google Gemini API
GEMINI_API_KEY=AIzaSyXXXXX-your-key-here

# Groq API (optional)
# GROQ_API_KEY=gsk_xxxxx
```

**AFTER** (with real keys):
```bash
# API Keys - NEVER commit this file to GitHub!
# This file is in .gitignore and stays LOCAL ONLY

# Anthropic Claude API (paste your actual key here)
ANTHROPIC_API_KEY=sk-ant-api03-ABC123XYZ...your-actual-key-here...789DEF

# Google Gemini API (paste your actual key here)
GEMINI_API_KEY=AIzaSyABC123...your-actual-key-here...XYZ789

# Groq API (optional - get free key at https://console.groq.com/keys)
# GROQ_API_KEY=gsk_xxxxx
```

**Just replace the placeholder text with the actual API keys!**

### Step 6: Save the File

**If using nano**:
- Press `Ctrl+O` (save)
- Press `Enter` (confirm filename)
- Press `Ctrl+X` (exit)

**If using TextEdit**:
- Press `Cmd+S` (save)
- Close the window

**If using VS Code**:
- Press `Cmd+S` (save)

### Step 7: Verify the File

```bash
cat .env
```

**Expected output**:
```
# API Keys - NEVER commit this file to GitHub!
ANTHROPIC_API_KEY=sk-ant-api03-XXXXX-your-key-here-XXXXX
GEMINI_API_KEY=AIzaSyXXXXX-your-key-here-XXXXX
```

### Step 8: Start the System

```bash
./START_ALL.command
```

**Check terminal output for**:
```
✅ Loaded environment variables from .env
✅ Anthropic API key: sk-ant-api03-jOts8... (first 20 chars)
✅ Gemini API key: AIzaSyCZX5u... (first 15 chars)
```

---

## 📋 Complete Walkthrough for Coworker Setup

### Scenario: Setting up on coworker's laptop

**You're sitting next to them, here's what to do:**

#### 1. Clone the Repo
```bash
cd ~/Desktop
mkdir -p LLM_Project
cd LLM_Project
git clone https://github.com/yourusername/TEP_demo.git
cd TEP_demo
```

#### 2. Create .env File
```bash
cp .env.template .env
```

#### 3. Open .env
```bash
open -a TextEdit .env
```

#### 4. Paste Your API Keys

**IMPORTANT DECISION**: Whose API keys to use?

**Option A: Use YOUR keys (temporary)**
- ✅ Fast setup (coworker can test immediately)
- ✅ You control costs
- ⚠️ Your billing account will be charged
- ⚠️ Remember to switch to their keys later!

**Option B: Have coworker get their own keys**
- ✅ They own their costs
- ✅ Better for long-term use
- ⚠️ Takes 5-10 minutes to get keys
- ⚠️ Requires credit card (for Claude)

**Recommended**: Start with YOUR keys for initial demo, then switch to theirs.

#### 5. Save and Close

#### 6. Run Setup
```bash
./SETUP_FIRST_TIME.command
```

**This will**:
- Install Python packages (5-10 min)
- Install Node.js packages (3-5 min)
- Verify .env file exists ✅

#### 7. Start System
```bash
./START_ALL.command
```

#### 8. Test in Browser
- Open: http://127.0.0.1:9002
- Click "🚀 Ultra Start"
- Trigger fault: Click IDV(1)
- Wait 3-5 min for anomaly
- Check LLM analysis appears

#### 9. (Later) Switch to Coworker's Keys

**After demo, when coworker has their own keys**:

```bash
cd /Users/[coworker]/Desktop/LLM_Project/TEP_demo
./STOP_ALL.command

# Edit .env
nano .env
# Replace YOUR keys with THEIR keys
# Save and exit

./START_ALL.command
```

---

## 🔐 Getting API Keys (For Coworker)

### Anthropic Claude ($5 free credit for new users)

**Steps**:
1. Go to: https://console.anthropic.com/
2. Click "Sign Up"
3. Verify email
4. Add payment method (credit card required)
5. Go to: https://console.anthropic.com/settings/keys
6. Click "Create Key"
7. Name it: "TEP_RCA_System"
8. Copy the key (starts with `sk-ant-api03-...`)
9. ⚠️ **IMPORTANT**: Save it immediately (shown only once!)

**Free credit**:
- $5 USD for new accounts
- Enough for ~300 LLM requests
- ~10-15 demo sessions

**After free credit**:
- Pay-as-you-go pricing
- ~$0.015 per request
- ~$0.30 per 30-min demo

---

### Google Gemini (Free tier available!)

**Steps**:
1. Go to: https://aistudio.google.com/apikey
2. Sign in with Google account
3. Click "Create API Key"
4. Select or create a Google Cloud project
5. Copy the key (starts with `AIzaSy...`)

**Free tier**:
- 1,500 requests per day (generous!)
- No credit card required
- Perfect for testing/demos

**Paid tier** (if you exceed free tier):
- Very cheap (~$0.0002 per request)
- $0.004 for 20 requests (basically free!)

---

### LM Studio (100% Free, Local)

**Steps**:
1. Download: https://lmstudio.ai/
2. Install and open LM Studio
3. Click "Discover" tab
4. Search for "qwen-7b" or "mistral-7b"
5. Click "Download" (3-5 GB)
6. Wait for download (5-10 min)
7. Click "Local Server" tab
8. Click "Start Server"
9. Server runs on: http://127.0.0.1:1234

**No API key needed!**

**To enable in TEP system**:
1. Edit `config/config.json`
2. Find `"lmstudio"` section
3. Change `"enabled": false` to `"enabled": true`
4. Restart system

---

## 🎯 Recommended Configuration for Coworker

### Initial Demo (Your Keys, Minimize Cost)

**Edit config.json**:
```json
"anthropic": { "enabled": false },   ← Disable Claude (save $$$)
"gemini": { "enabled": true },        ← Enable Gemini (almost free)
"lmstudio": { "enabled": false }      ← Skip for now
```

**Why**:
- ✅ Minimal cost (~$0.004 for entire demo)
- ✅ Fast response
- ✅ No local setup needed

**After initial demo, if they want to compare models**:
- Enable Claude: `"enabled": true`
- Cost: ~$0.30 for 30-min session
- Still very affordable!

---

## ⚠️ Security Warnings

### DO:
- ✅ Keep .env file LOCAL (never commit to git)
- ✅ Use .gitignore to prevent accidents
- ✅ Share keys only via secure channel (not email!)
- ✅ Regenerate keys if exposed
- ✅ Use separate keys for different projects

### DON'T:
- ❌ Commit .env to GitHub (keys exposed publicly!)
- ❌ Share keys in Slack/email (insecure)
- ❌ Use same key for multiple people
- ❌ Leave keys in screenshots/videos
- ❌ Hardcode keys in Python files

---

## 🔍 Troubleshooting

### Problem: "ANTHROPIC_API_KEY not found"

**Check 1**: Is .env file in the right location?
```bash
ls -la /Users/[username]/Desktop/LLM_Project/TEP_demo/.env
```

**Should show**:
```
-rw-r--r--  1 username  staff  234 Oct 19 10:30 .env
```

**If not found**: Create from template
```bash
cp .env.template .env
```

---

### Problem: "Invalid API key"

**Check 1**: Did you copy the entire key?
- Claude keys are ~100 characters
- Gemini keys are ~39 characters
- Must include all characters

**Check 2**: Any extra spaces or newlines?
```bash
# Bad (extra space at end)
ANTHROPIC_API_KEY=sk-ant-api03-xxx

# Good (no extra space)
ANTHROPIC_API_KEY=sk-ant-api03-xxx
```

**Check 3**: Did you restart backend after editing .env?
```bash
./STOP_ALL.command
./START_ALL.command
```

---

### Problem: "Backend not loading .env"

**Check 1**: Is .env in root folder (not backend/)?
```bash
# Correct location
TEP_demo/.env

# Wrong location (will NOT work)
TEP_demo/backend/.env
```

**Check 2**: Verify python-dotenv is installed
```bash
pip list | grep python-dotenv
```

**If not installed**:
```bash
pip install python-dotenv
```

---

### Problem: "git showing .env as untracked file"

**This is GOOD!** It means .gitignore is working.

**Verify .env is ignored**:
```bash
git status
```

**Should NOT show .env in output**

**If it does show up**:
```bash
# Make sure .gitignore has these lines
cat .gitignore | grep "\.env"

# Should show:
# .env
# .env.*
# **/.env
```

---

## 📌 Quick Reference

| File | Location | Purpose | Edit? |
|------|----------|---------|-------|
| `.env` | `TEP_demo/.env` | YOUR API KEYS | ✅ YES |
| `.env.template` | `TEP_demo/.env.template` | Template (safe placeholders) | ❌ NO |
| `config.json` | `TEP_demo/config/config.json` | Uses `${ENV_VAR}` | ❌ NO (usually) |

**To setup API keys**: Only edit `.env`

**To enable/disable models**: Edit `config/config.json` (see HOW_TO_CONTROL_LLMS.md)

---

## ✅ Success Checklist

After setting up API keys:

- [ ] .env file exists in root folder
- [ ] .env contains real API keys (not placeholders)
- [ ] No extra spaces or newlines in .env
- [ ] .env is in .gitignore (git status doesn't show it)
- [ ] Backend starts without "API key not found" error
- [ ] Terminal shows "✅ Loaded environment variables"
- [ ] LLM analysis works (test with IDV fault)

**If all checked ✅ → API keys are set up correctly!**

---

## 🎉 Done!

Your coworker should now have working API keys and can run LLM analysis!

**Next steps**:
- Read HOW_TO_CONTROL_LLMS.md (choose which models to enable)
- Read COWORKER_SETUP.md (full system usage guide)
- Start demo: `./START_ALL.command`
