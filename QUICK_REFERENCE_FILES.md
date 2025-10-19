# 📁 Quick Reference: Important Files & Locations

**Visual guide to the most important files you'll need to edit**

---

## 🎯 The 3 Files You'll Actually Edit

```
TEP_demo/
├── .env                    ← 🔑 YOUR API KEYS (edit this!)
├── config/
│   └── config.json         ← 🎛️ ENABLE/DISABLE MODELS (edit this!)
└── STOP_ALL.command        ← 🛑 EMERGENCY STOP (click this!)
```

**That's it! Everything else works automatically.**

---

## 📍 File #1: .env (API Keys)

### Location:
```
/Users/[username]/Desktop/LLM_Project/TEP_demo/.env
```

### What's inside:
```bash
ANTHROPIC_API_KEY=sk-ant-api03-jOts8q_7Wvb...
GEMINI_API_KEY=AIzaSyXXXXX-REDACTED-XXXXX...
```

### When to edit:
- ✅ First time setup (add your keys)
- ✅ Switching to coworker's keys
- ✅ Regenerating keys after exposure

### How to edit:
```bash
cd /Users/[username]/Desktop/LLM_Project/TEP_demo
nano .env
# or
open -a TextEdit .env
```

### ⚠️ Important:
- This file is LOCAL ONLY (not in git)
- Don't commit this to GitHub!
- See: API_KEY_SETUP_GUIDE.md for details

---

## 📍 File #2: config.json (Enable/Disable Models)

### Location:
```
/Users/[username]/Desktop/LLM_Project/TEP_demo/config/config.json
```

### What's inside (lines 9-32):
```json
{
  "models": {
    "anthropic": {
      "enabled": true,    ← Change to false to disable Claude
      ...
    },
    "gemini": {
      "enabled": true,    ← Change to false to disable Gemini
      ...
    },
    "lmstudio": {
      "enabled": false    ← Change to true to enable LMStudio
      ...
    }
  }
}
```

### When to edit:
- ✅ Before starting system (choose which models to use)
- ✅ To save money (disable expensive models)
- ✅ To enable LMStudio (free, local)

### How to edit:
```bash
cd /Users/[username]/Desktop/LLM_Project/TEP_demo/config
nano config.json
# or
open -a TextEdit config.json
```

### ⚠️ Important:
- Must restart backend after editing!
- Run: `./STOP_ALL.command` then `./START_ALL.command`
- See: HOW_TO_CONTROL_LLMS.md for details

---

## 🎛️ Common Configurations

### Config A: Gemini Only (Cheapest)
**Cost**: ~$0.0002 per request

Edit `config/config.json`:
```json
"anthropic": { "enabled": false },
"gemini": { "enabled": true },
"lmstudio": { "enabled": false }
```

Then restart:
```bash
./STOP_ALL.command
./START_ALL.command
```

---

### Config B: Claude Only (Best Quality)
**Cost**: ~$0.015 per request

Edit `config/config.json`:
```json
"anthropic": { "enabled": true },
"gemini": { "enabled": false },
"lmstudio": { "enabled": false }
```

Then restart:
```bash
./STOP_ALL.command
./START_ALL.command
```

---

### Config C: All Three (Comparison Mode)
**Cost**: ~$0.0152 per request

Edit `config/config.json`:
```json
"anthropic": { "enabled": true },
"gemini": { "enabled": true },
"lmstudio": { "enabled": true }  ← Requires LMStudio installed
```

Then restart:
```bash
./STOP_ALL.command
./START_ALL.command
```

---

## 🗂️ Complete File Structure (Reference)

```
TEP_demo/
├── 🔑 .env                          ← YOUR API KEYS HERE!
├── 📄 .env.template                 ← Template (don't edit)
├── ✅ README.md                     ← Main documentation
├── 👥 COWORKER_SETUP.md            ← Onboarding guide
├── 🔑 API_KEY_SETUP_GUIDE.md       ← This guide!
├── 🎛️ HOW_TO_CONTROL_LLMS.md       ← Enable/disable models
├── 📁 QUICK_REFERENCE_FILES.md     ← This file
│
├── 🚀 START_ALL.command             ← Start system
├── 🛑 STOP_ALL.command              ← Stop system
├── 🔧 SETUP_FIRST_TIME.command     ← First-time setup
│
├── config/
│   └── 🎛️ config.json               ← ENABLE/DISABLE MODELS HERE!
│
├── backend/                         ← Python backend code
│   ├── app.py                       ← Main backend API
│   ├── multi_llm_client.py          ← LLM client
│   ├── prompts.py                   ← LLM prompts
│   └── diagnostics/
│       ├── analysis_history.jsonl   ← LLM analysis results
│       └── ingest.log               ← Backend logs
│
├── frontend/                        ← React frontend
│   ├── src/
│   └── public/
│
├── templates/
│   └── control_panel.html           ← Unified console UI
│
├── scripts/                         ← Utility scripts
│   ├── RESTART_UNIFIED_CONSOLE.sh
│   └── START_BRIDGE.command
│
└── docs/                            ← Documentation
    └── ... (other MD files)
```

---

## 🎯 Quick Decision Tree

### "Which file should I edit?"

**Q**: Want to add/change API keys?
- **A**: Edit `.env` (root folder)
- **Guide**: API_KEY_SETUP_GUIDE.md

**Q**: Want to enable/disable Claude, Gemini, or LMStudio?
- **A**: Edit `config/config.json` (config/ folder)
- **Guide**: HOW_TO_CONTROL_LLMS.md
- **Remember**: Restart backend after editing!

**Q**: Want to change LLM prompts?
- **A**: Edit `backend/prompts.py`
- **Remember**: Restart backend after editing!

**Q**: Want to change frontend UI?
- **A**: Edit `templates/control_panel.html` or `frontend/src/`
- **Remember**: Restart unified console or frontend

**Q**: Just want to use the system?
- **A**: Don't edit anything! Just run `./START_ALL.command`

---

## ⚠️ Common Mistakes

### Mistake #1: Editing .env.template instead of .env
**Problem**: .env.template is a template, not the actual file!

**Solution**:
```bash
# Don't edit this:
TEP_demo/.env.template

# Edit this instead:
TEP_demo/.env
```

---

### Mistake #2: Putting .env in backend/ folder
**Problem**: Backend reads .env from ROOT folder, not backend/

**Wrong location**:
```
TEP_demo/backend/.env  ❌
```

**Correct location**:
```
TEP_demo/.env  ✅
```

---

### Mistake #3: Editing config.json but not restarting
**Problem**: Backend only reads config.json on startup

**Solution**:
```bash
# After editing config.json:
./STOP_ALL.command
./START_ALL.command
```

---

### Mistake #4: Thinking frontend checkboxes disable models
**Problem**: Frontend only controls DISPLAY, not execution!

**Reality**:
- Frontend checkbox = show/hide results
- config.json = actually enable/disable API calls

**Solution**: Edit config.json to save money!

---

## ✅ Verification Commands

### Check if .env exists:
```bash
ls -la /Users/[username]/Desktop/LLM_Project/TEP_demo/.env
```

### Check which models are enabled:
```bash
cat /Users/[username]/Desktop/LLM_Project/TEP_demo/config/config.json | grep "enabled"
```

### Verify backend loaded API keys:
```bash
# Start backend and look for:
# ✅ Loaded environment variables from .env
# ✅ Anthropic API key: sk-ant-api03-jOts8... (first 20 chars)
./START_ALL.command
```

---

## 📚 Related Guides

| Guide | Purpose | When to Read |
|-------|---------|--------------|
| **API_KEY_SETUP_GUIDE.md** | How to add/change API keys | First-time setup, coworker migration |
| **HOW_TO_CONTROL_LLMS.md** | Enable/disable models, save money | Before every session |
| **COWORKER_SETUP.md** | Complete onboarding guide | Sharing with new user |
| **README.md** | Main documentation | General reference |

---

## 🎉 That's It!

**Remember**: Only 2 files to edit!
1. `.env` (API keys)
2. `config/config.json` (enable/disable models)

Everything else is automatic! 🚀
