# 🎛️ How to Control Which LLMs Run

**IMPORTANT DISCOVERY**: There's currently **NO frontend toggle** for enabling/disabling LLMs. You must edit the config file and restart the backend.

---

## 🔍 Understanding the Current System

### What Works:
- ✅ Backend reads `config/config.json` on startup
- ✅ Models with `"enabled": true` are activated
- ✅ Models with `"enabled": false` are NOT activated
- ✅ Backend code HAS a `toggle_model()` function (unused!)

### What Doesn't Work:
- ❌ No frontend checkboxes to enable/disable models
- ❌ No runtime toggle (must restart backend)
- ❌ Frontend "Show Claude"/"Show Gemini" (if exists) only controls DISPLAY, not execution

### The Problem:
**Every LLM request sends to ALL enabled models** (costs money!)
- If Claude enabled → Every request calls Claude API ($$$)
- If Gemini enabled → Every request calls Gemini API ($)
- If LMStudio enabled → Every request calls LMStudio (FREE but slower)

---

## 📝 Method 1: Edit config.json (Recommended)

### Step-by-Step Instructions:

#### 1. Stop the System
```bash
./STOP_ALL.command
```

#### 2. Open config.json
```bash
# Navigate to config folder
cd /Users/chennanli/Desktop/LLM_Project/TEP_demo/config

# Open with text editor (choose one)
nano config.json        # Terminal editor
open -a TextEdit config.json    # macOS TextEdit
code config.json        # VS Code (if installed)
```

#### 3. Find the "models" Section

Look for lines 9-32 (approximately):

```json
"models": {
  "anthropic": {
    "api_key": "${ANTHROPIC_API_KEY}",
    "model_name": "claude-3-7-sonnet-20250219",
    "enabled": true,          ← THIS LINE!
    "premium": true,
    "description": "Anthropic Claude 3.7 Sonnet"
  },
  "gemini": {
    "api_key": "${GEMINI_API_KEY}",
    "model_name": "gemini-2.5-flash",
    "enabled": true,          ← THIS LINE!
    "premium": true,
    "description": "Google Gemini 2.5 Flash"
  },
  "lmstudio": {
    "enabled": false,         ← THIS LINE!
    "base_url": "http://127.0.0.1:1234/v1",
    "model_name": "openai/gpt-oss-20b",
    "api_key": "not-needed",
    "premium": false,
    "description": "Local model via LM Studio - FREE"
  }
}
```

#### 4. Change "enabled" Values

**To disable Claude (save money):**
```json
"anthropic": {
  "enabled": false,    ← Change true to false
```

**To enable LMStudio (free, local):**
```json
"lmstudio": {
  "enabled": true,     ← Change false to true
```

**To use only Gemini (cheapest cloud option):**
```json
"anthropic": {
  "enabled": false,    ← Disable Claude
  ...
},
"gemini": {
  "enabled": true,     ← Keep Gemini
  ...
},
"lmstudio": {
  "enabled": false     ← Keep LMStudio off (unless you want it)
```

#### 5. Save the File
- **nano**: Press `Ctrl+O`, then `Enter`, then `Ctrl+X`
- **TextEdit**: `Cmd+S`
- **VS Code**: `Cmd+S`

#### 6. Restart the System
```bash
cd /Users/chennanli/Desktop/LLM_Project/TEP_demo
./START_ALL.command
```

#### 7. Verify in Terminal Output

Look for this line when backend starts:
```
✅ Initialized models: ['anthropic', 'gemini', 'lmstudio']
📊 Config-enabled models: ['gemini']    ← Only Gemini enabled!
```

---

## 💰 Cost Saving Configurations

### Configuration A: Gemini Only (Cheapest Cloud)
**Cost**: ~$0.0002 per request (almost free!)

```json
"anthropic": { "enabled": false },
"gemini": { "enabled": true },
"lmstudio": { "enabled": false }
```

**Pros**:
- ✅ Very cheap (free tier available)
- ✅ Fast response
- ✅ Cloud-based (no local setup)

**Cons**:
- ⚠️ Sometimes misses summary (but we fixed this!)
- ⚠️ Not as detailed as Claude

---

### Configuration B: LMStudio Only (100% Free)
**Cost**: $0 (local model)

```json
"anthropic": { "enabled": false },
"gemini": { "enabled": false },
"lmstudio": { "enabled": true }
```

**Pros**:
- ✅ Completely free
- ✅ No API key needed
- ✅ Privacy (data stays local)

**Cons**:
- ⚠️ Slower (depends on your Mac)
- ⚠️ Requires LM Studio installation
- ⚠️ Requires downloading model (~4GB)

**Setup LMStudio**:
1. Download: https://lmstudio.ai/
2. Install and open LM Studio
3. Download a model (e.g., "qwen-7b" or "mistral-7b")
4. Click "Local Server" → Start Server
5. Server runs on http://127.0.0.1:1234
6. Edit config.json to enable lmstudio
7. Restart backend

---

### Configuration C: Claude Only (Best Quality, Most Expensive)
**Cost**: ~$0.015 per request

```json
"anthropic": { "enabled": true },
"gemini": { "enabled": false },
"lmstudio": { "enabled": false }
```

**Pros**:
- ✅ Best analysis quality
- ✅ Most detailed explanations
- ✅ Always includes summary

**Cons**:
- ⚠️ Most expensive
- ⚠️ 10x more than Gemini

---

### Configuration D: All Three (Comparison Mode)
**Cost**: ~$0.0152 per request (Claude dominates cost)

```json
"anthropic": { "enabled": true },
"gemini": { "enabled": true },
"lmstudio": { "enabled": true }
```

**Pros**:
- ✅ Compare all 3 models side-by-side
- ✅ Best for research/demos
- ✅ Redundancy (if one fails, others work)

**Cons**:
- ⚠️ Most expensive (3 API calls per request)
- ⚠️ Slowest (waits for all 3 to finish)
- ⚠️ Requires LMStudio setup

---

### Configuration E: Gemini + LMStudio (Best Balance)
**Cost**: ~$0.0002 per request (Gemini only, LMStudio free)

```json
"anthropic": { "enabled": false },
"gemini": { "enabled": true },
"lmstudio": { "enabled": true }
```

**Pros**:
- ✅ Very cheap (Gemini almost free)
- ✅ Compare cloud vs local
- ✅ Fallback if Gemini fails

**Cons**:
- ⚠️ Requires LMStudio setup
- ⚠️ Slower than Gemini-only

---

## 🎯 Recommended Configuration for Demo

**For cost-conscious demo (30 minutes)**:

```json
"anthropic": { "enabled": false },   ← Save money!
"gemini": { "enabled": true },        ← Cheap & fast
"lmstudio": { "enabled": false }      ← Skip unless installed
```

**Estimated cost for 30-min demo**:
- 10-20 LLM requests
- Gemini only: **$0.002 - $0.004** (less than 1 cent!)
- vs Claude: $0.15 - $0.30 (100x more expensive!)

**After demo, if coworker wants to test Claude**:
1. Stop system: `./STOP_ALL.command`
2. Edit config.json: Change Claude `"enabled": true`
3. Restart: `./START_ALL.command`
4. Test 1-2 requests (cost: $0.03)
5. Stop and disable Claude again

---

## ❓ FAQ

### Q1: If I set LMStudio to `"enabled": false`, can I still select it in frontend?

**A**: No! If `"enabled": false` in config.json, the backend will NOT call that model, regardless of frontend settings.

**Reason**: Backend reads config.json ONLY on startup. Frontend cannot override this.

**To enable LMStudio**:
1. Edit config.json: `"lmstudio": { "enabled": true }`
2. Restart backend
3. Now LMStudio will be called

---

### Q2: Can I disable Claude mid-session without restarting?

**A**: No, not currently. The system requires backend restart.

**Why**: The toggle_model() function exists in code but has no API endpoint or frontend button.

**Workaround**: Use cost protection (30-min auto-shutdown) to limit exposure.

---

### Q3: I edited config.json but nothing changed. Why?

**A**: You forgot to restart the backend!

**Solution**:
```bash
./STOP_ALL.command
./START_ALL.command
```

Backend only reads config.json during startup.

---

### Q4: How do I know which models are active?

**Check terminal output when backend starts**:
```
✅ Initialized models: ['anthropic', 'gemini', 'lmstudio']
📊 Config-enabled models: ['gemini', 'lmstudio']
```

**Or check backend logs**:
```
🚀 Starting PARALLEL analysis with 2 models: ['gemini', 'lmstudio']
```

---

### Q5: What if I want different models for different faults?

**Current limitation**: Not supported. All enabled models run for every request.

**Future feature**: Could add frontend toggle, but requires code changes.

---

## 🔧 For Developers: How to Add Frontend Toggle

**Current code has `toggle_model()` function but no API endpoint!**

**To add this feature** (advanced users only):

1. **Add backend API endpoint** (backend/app.py):
```python
@app.post("/api/toggle_model")
async def toggle_model_endpoint(request: dict):
    model_name = request.get("model_name")
    enabled = request.get("enabled", True)
    result = multi_llm_client.toggle_model(model_name, enabled)
    return result
```

2. **Add frontend button** (templates/control_panel.html):
```javascript
function toggleClaude(enabled) {
    fetch('/api/toggle_model', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({model_name: 'anthropic', enabled: enabled})
    });
}
```

3. **Add checkbox** (HTML):
```html
<input type="checkbox" id="claude-toggle" onchange="toggleClaude(this.checked)">
<label>Enable Claude</label>
```

**This is a future enhancement, not currently implemented.**

---

## 📌 Summary

| Method | Difficulty | Restart Required? | When to Use |
|--------|------------|-------------------|-------------|
| Edit config.json | Easy | ✅ Yes | Before starting session |
| Frontend toggle | N/A | ❌ No | Not implemented yet |
| Cost protection | Easy | ❌ No | Auto-shutdown after 30 min |

**Best practice**: Edit config.json BEFORE starting the system, choose which models you want, then start.

**For coworker setup**: Use Gemini-only to minimize costs during initial testing!
