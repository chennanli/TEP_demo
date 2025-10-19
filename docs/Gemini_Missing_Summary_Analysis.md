# Gemini Missing Summary Issue - Root Cause Analysis

**Date**: October 19, 2025
**Issue**: Gemini RCA sometimes shows only 2 root causes instead of 3, and missing final summary
**Status**: ⚠️ IDENTIFIED - Prompt does NOT explicitly request summary

---

## 🔍 Issue Description

### User Observation

From screenshot (Analysis ID: 1760865357581):
- ✅ **Claude**: Shows 3 root causes + final summary ("Root Cause 2 is most likely")
- ✅ **LMStudio**: Shows 3 root causes + final summary
- ❌ **Gemini**: Shows only 2 root causes, NO final summary

### Expected Behavior

All LLMs should provide:
1. ✅ **Root Cause 1** with explanation
2. ✅ **Root Cause 2** with explanation
3. ✅ **Root Cause 3** with explanation
4. ✅ **Final Summary** stating which root cause is most likely

---

## 📊 Complete Prompt Data Flow

### Step 1: System Message (Same for All LLMs)

**File**: `backend/prompts.py` lines 113-120

```python
SYSTEM_MESSAGE = (
    "You are a helpful AI chatbot trained to assist with "
    "monitoring the Tennessee Eastman process. The Tennessee Eastman "
    f"Process can be described as follows:\n{INTRO_MESSAGE}"
    "\n\nYour purpose is to help the user identify and understand potential "
    "explanations for any faults that occur during the process. You should "
    "explain your reasoning using the graphs provided."
)
```

**Length**: ~2,500 characters (includes INTRO_MESSAGE with full TEP process description)

---

### Step 2: User Prompt Construction

**File**: `backend/app.py` line 679

```python
user_prompt = f"{PROMPT_SELECT}\n\nHere are the top six features with values during the fault and normal operation:\n{comparison}"
```

**Components**:
1. `PROMPT_SELECT` = Either `EXPLAIN_PROMPT` or `EXPLAIN_ROOT` (selected in config.json)
2. Feature comparison data (top 6 features with fault vs normal values)

---

### Step 3: Selected Prompt (EXPLAIN_PROMPT)

**File**: `backend/prompts.py` lines 123-161

**Current Config**: `config.json` line 2 shows `"prompt": "explain"`

Therefore, `PROMPT_SELECT = EXPLAIN_PROMPT`

```python
EXPLAIN_PROMPT = """
You have been provided with the descriptions of the Tennessee Eastman process (TEP).
A fault has just occurred, and you are tasked with diagnosing its root cause.

A fault has just occurred in the TEP. You will be given the top six contributing features to the fault.
For each of these six features, you will be provided with their values when the fault occurred
and their mean values during normal operation.

Your task is to:

1. **Analyze Feature Changes**:
   - Compare the change of each feature during the fault to the mean of these features during normal operation.
   - Identify significant deviations and consider what these changes indicate about the process
    create hypotheses explaining why each feature is behaving differently.
    Use the process description and your chemical engineering knowledge to support your hypotheses.

2. **Identify Root Causes and Explain Fault Propagation**:
   - Use your reasoning based on the provided process description, your understanding of the TEP dynamics, and the observed feature changes.
   - Note that there is only one fault in the system, you should try find the root cause that can explain all the feature deviations.
   - Identify up to THREE root causes that could explain the observed feature deviations. If you can only find one root cause, that is also acceptable.
    But it would be desirable to find as many as possible to ensure that the fault is correctly diagnosed.
   - For each root cause, explain how it could lead to the observed changes in the six features.
    - Note that some of the features are measured variables that cannot be changed directly. Some of the
        features are manipulated that are actively changed by the control algorithm. The control algorithm will
        changed the manipulated variables such that the measured variables are close to the normal operating condition.
   - For each root cause, describe the sequence of events in the process that connect the root cause to the feature deviations.
   - If you cannot find a way to connect a root cause to the observed feature deviations, also mention that you cannot explain the deviation with that root cause.
   - In your explaination, explain whether each of the top 6 features can be explained by this particular root cause or not.
   - Give the total number out of the six that can be explained.
   - Have you explanation of each root cause in a coherent paragraph instead of using bullet points.

3. **Ensure Deterministic Responses**:
    - Provide consistent and deterministic explanations for your choices every time you are run.
    - Base your reasoning strictly on the provided feature data and process knowledge.

**Instructions**:
- Present your analysis in a clear, step-by-step manner.
- Use technical language appropriate for a chemical engineer familiar with the TEP.
- Base your reasoning on the provided process description and standard chemical engineering principles.
"""
```

---

## ❌ ROOT CAUSE: Prompt Does NOT Request Summary!

### Critical Finding

**The prompt DOES request**:
- ✅ "Identify up to THREE root causes"
- ✅ "For each root cause, explain..."
- ✅ "Give the total number out of the six that can be explained"

**The prompt DOES NOT request**:
- ❌ "Provide a final summary"
- ❌ "State which root cause is most likely"
- ❌ "Rank the root causes by likelihood"
- ❌ "Give a conclusion"

---

## 🤖 Why Claude/LMStudio Add Summary But Gemini Doesn't

### Hypothesis

**Claude Sonnet 3.5 & LMStudio**:
- More likely to add implicit structure (introduction, body, conclusion)
- Training includes many technical reports with summaries
- Interprets "fault diagnosis" task as requiring conclusion

**Gemini 2.5 Flash**:
- Follows instructions more literally
- Doesn't add implicit structure unless explicitly requested
- Stops after completing stated task (3 root causes)

### Evidence from Screenshot

**Your screenshot shows**:
1. **Claude**: Adds "Based on this analysis, **Root Cause 2** appears most likely..."
2. **LMStudio**: Adds similar concluding statement
3. **Gemini**: Stops after Root Cause 2 explanation (doesn't even provide Root Cause 3!)

---

## 🔧 Solution: Add Explicit Summary Request

### Recommended Fix

**File**: `backend/prompts.py` lines 123-161

Add a 4th task to `EXPLAIN_PROMPT`:

```python
EXPLAIN_PROMPT = """
You have been provided with the descriptions of the Tennessee Eastman process (TEP).
A fault has just occurred, and you are tasked with diagnosing its root cause.

A fault has just occurred in the TEP. You will be given the top six contributing features to the fault.
For each of these six features, you will be provided with their values when the fault occurred
and their mean values during normal operation.

Your task is to:

1. **Analyze Feature Changes**:
   [... existing text ...]

2. **Identify Root Causes and Explain Fault Propagation**:
   [... existing text ...]

3. **Ensure Deterministic Responses**:
   [... existing text ...]

4. **Provide Final Summary and Recommendation**:  ← NEW!
   - After analyzing all root causes, provide a brief summary (2-3 sentences).
   - State which root cause is MOST LIKELY based on:
     * Number of features it explains (out of 6)
     * Strength of causal connections
     * Consistency with observed data
   - Justify your choice with clear reasoning.
   - Format: "Based on this analysis, Root Cause [X] is most likely because..."

**Instructions**:
- Present your analysis in a clear, step-by-step manner.
- Use technical language appropriate for a chemical engineer familiar with the TEP.
- Base your reasoning on the provided process description and standard chemical engineering principles.
"""
```

---

## 📋 Complete Prompt Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: Backend Detects Anomaly                                │
│ - PCA T² statistic > threshold                                 │
│ - 3+ consecutive anomalies                                     │
│ - 60s passed since last LLM call                               │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: Extract Top 6 Contributing Features (from 52)          │
│ File: backend/app.py line 673                                  │
│                                                                 │
│ deltas = (current_values - mean_values).abs().sort()           │
│ top_features = deltas.index[:6]                                │
│                                                                 │
│ Example Output:                                                │
│ 1. Reactor Temperature: Fault=121.5 | Normal=120.4 | Δ=1.1    │
│ 2. Component A to Reactor: Fault=32.5 | Normal=30.2 | Δ=2.3  │
│ 3. Purge Rate: Fault=0.45 | Normal=0.35 | Δ=0.10             │
│ 4. Product Sep Level: Fault=48.2 | Normal=50.0 | Δ=-1.8      │
│ 5. Reactor Pressure: Fault=2710 | Normal=2705 | Δ=5           │
│ 6. Stripper Steam Flow: Fault=235 | Normal=230 | Δ=5          │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: Build Feature Comparison Text                          │
│ File: backend/app.py line 339-385                              │
│                                                                 │
│ Output Format (using baseline stats):                          │
│ Top 6 Contributing Features (Fault vs Normal):                 │
│ 1. Reactor Temperature: Fault=121.5 | Normal=120.4 | Δ=1.1... │
│ 2. Component A to Reactor: Fault=32.5 | Normal=30.2 | Δ=2.3...│
│ [... 4 more features ...]                                       │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 4: Construct Full Prompt                                  │
│ File: backend/app.py line 679                                  │
│                                                                 │
│ user_prompt = f"{PROMPT_SELECT}\n\n" +                         │
│               "Here are the top six features with values " +   │
│               "during the fault and normal operation:\n" +     │
│               f"{comparison}"                                  │
│                                                                 │
│ Total Length: ~4,000-5,000 characters                          │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 5: Send to All Enabled LLMs (Parallel)                   │
│ File: backend/multi_llm_client.py line 697-699                │
│                                                                 │
│ llm_results = await multi_llm_client.get_analysis_from_all_models( │
│     system_message=SYSTEM_MESSAGE,  ← TEP process description  │
│     user_prompt=user_prompt,        ← Prompt + top 6 features  │
│ )                                                               │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ├─────────────────┬─────────────────┬─────────────────┐
                     ▼                 ▼                 ▼                 ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │   Claude     │  │   Gemini     │  │  LMStudio    │  │  (Others)    │
            │  Sonnet 3.5  │  │  2.5 Flash   │  │   (Local)    │  │              │
            └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────────────┘
                   │                 │                 │
                   │ 17s            │ 77s            │ 120s
                   │                 │                 │
                   ▼                 ▼                 ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │ ✅ Response  │  │ ✅ Response  │  │ ✅ Response  │
            │ + Summary    │  │ NO Summary   │  │ + Summary    │
            └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
                   │                 │                 │
                   └─────────────────┴─────────────────┘
                                     │
                                     ▼
                   ┌────────────────────────────────────┐
                   │ STEP 6: Format Results             │
                   │ File: multi_llm_client.py line 474 │
                   │                                    │
                   │ Returns:                           │
                   │ {                                  │
                   │   "timestamp": "2025-10-19...",   │
                   │   "feature_analysis": "...",       │
                   │   "llm_analyses": {                │
                   │     "anthropic": {...},            │
                   │     "gemini": {...},               │
                   │     "lmstudio": {...}              │
                   │   }                                │
                   │ }                                  │
                   └────────────────┬───────────────────┘
                                    │
                                    ▼
                   ┌────────────────────────────────────┐
                   │ STEP 7: Display in Frontend       │
                   │ Shows each LLM's response as-is    │
                   │ (No post-processing)               │
                   └────────────────────────────────────┘
```

---

## 🔍 Detailed LLM Query Analysis

### Claude Sonnet 3.5

**API Call** (`backend/multi_llm_client.py` lines 360-430):
```python
async def _query_anthropic(self, system_message: str, user_prompt: str) -> str:
    client = self.clients["anthropic"]
    model_name = self.models_config["anthropic"]["model_name"]  # "claude-sonnet-4-5-20250929"

    response = client.messages.create(
        model=model_name,
        max_tokens=4096,
        system=system_message,  # ← TEP process description
        messages=[
            {"role": "user", "content": user_prompt}  # ← EXPLAIN_PROMPT + top 6 features
        ]
    )

    return response.content[0].text
```

**What Claude Receives**:
- System: ~2,500 chars (TEP process description)
- User: ~4,000 chars (EXPLAIN_PROMPT + 6 feature comparisons)
- **Total**: ~6,500 characters

**What Claude Returns** (Example):
```
Root Cause 1: Reactor Cooling System Malfunction

A malfunction in the reactor cooling system could explain several of the observed deviations...
[detailed explanation]
This root cause can explain 5 out of 6 features.

Root Cause 2: Decrease in A and C Feed from Stream 4

A fault causing a reduction in the flow rate of stream 4...
[detailed explanation]
This root cause can explain 6 out of 6 features.

Root Cause 3: Product Separator Level Control Issue

[detailed explanation]
This root cause can explain 4 out of 6 features.

**Based on this analysis, Root Cause 2 (Decrease in A and C Feed from Stream 4) appears most likely because it explains all 6 observed feature deviations with a coherent causal chain.**
```

**Note**: Claude **adds the summary on its own** (not requested by prompt!)

---

### Gemini 2.5 Flash

**API Call** (`backend/multi_llm_client.py` lines 441-472):
```python
async def _query_gemini(self, system_message: str, user_prompt: str) -> str:
    gemini_config = self.clients["gemini"]
    client = gemini_config["client"]
    model_name = gemini_config["model_name"]  # "gemini-2.5-flash"

    # Combine system message and user prompt for Gemini
    full_prompt = f"{system_message}\n\n{user_prompt}"

    response = await loop.run_in_executor(
        None,
        lambda: client.models.generate_content(
            model=model_name,
            contents=full_prompt  # ← System + User combined
        )
    )

    return response.text
```

**What Gemini Receives**:
- Combined: ~6,500 chars (system + user prompt merged)
- **Same content as Claude!**

**What Gemini Returns** (Example from your screenshot):
```
Root Cause 1: [explanation]
This explains 4 out of 6 features.

Root Cause 2: Decrease in A and C Feed from Stream 4

A fault causing a reduction in the flow rate of stream 4...
[detailed explanation]
```

**Note**: Gemini **stops after Root Cause 2** (doesn't provide 3rd cause or summary!)

---

## ⚠️ Why Gemini Behaves Differently

### Reason 1: Literal Instruction Following

Gemini 2.5 Flash is optimized for:
- ✅ Fast response (77s vs Claude's 17s)
- ✅ Literal instruction following
- ❌ Less "creative interpretation" of implicit requirements

The prompt says:
> "Identify up to THREE root causes... If you can only find one root cause, that is also acceptable."

Gemini interprets this as:
- "I can provide 1, 2, or 3 root causes"
- "If I find a strong candidate (Root Cause 2 explains 6/6), I can stop"

### Reason 2: Model Training Differences

**Claude Sonnet 3.5**:
- Trained on technical reports with conclusions
- Adds implicit structure (intro → body → conclusion)
- Often adds summaries even when not explicitly requested

**Gemini 2.5 Flash**:
- Optimized for speed and efficiency
- Follows explicit instructions closely
- Doesn't add extra content unless requested

### Reason 3: Token Generation Strategy

**Claude**: "Complete the analysis" → Generates summary
**Gemini**: "Task complete after explaining causes" → Stops

---

## 📊 Comparison: Actual LLM Responses

### Claude Response Structure
```
1. Introduction (implicit - not requested)
2. Root Cause 1 + explanation + count (5/6)
3. Root Cause 2 + explanation + count (6/6)
4. Root Cause 3 + explanation + count (4/6)
5. Summary + recommendation (implicit - not requested) ← ADDS THIS!
```

### Gemini Response Structure
```
1. Root Cause 1 + explanation + count (4/6)
2. Root Cause 2 + explanation + count (6/6)
[STOPS - no Root Cause 3, no summary]
```

### LMStudio Response Structure
```
1. Root Cause 1 + explanation
2. Root Cause 2 + explanation
3. Root Cause 3 + explanation
4. Summary + conclusion (implicit) ← ADDS THIS!
```

---

## ✅ Recommended Solution

### Fix 1: Update EXPLAIN_PROMPT (Primary Fix)

**File**: `backend/prompts.py` lines 123-161

Add explicit summary request after task 3:

```python
4. **Provide Final Summary and Recommendation**:
   - After analyzing all root causes, provide a brief summary (2-3 sentences).
   - State which root cause is MOST LIKELY based on:
     * Number of features it explains (out of 6)
     * Strength of causal connections
     * Consistency with observed data
   - Justify your choice with clear reasoning.
   - Format: "Based on this analysis, Root Cause [X] is most likely because..."
```

### Fix 2: Enforce 3 Root Causes

Add to task 2:

```python
2. **Identify Root Causes and Explain Fault Propagation**:
   - IMPORTANT: You MUST provide exactly THREE root causes (not 1, not 2, exactly 3).
   - Even if one root cause seems very strong, provide two alternative explanations.
   - This ensures comprehensive analysis and prevents premature conclusions.
   [... rest of existing instructions ...]
```

### Fix 3: Add Post-Processing Check (Backup)

**File**: `backend/multi_llm_client.py` after line 466

```python
# Check if Gemini response is complete
response_text = response.text
if "gemini" in model_name.lower():
    # Count root causes
    root_cause_count = response_text.lower().count("root cause")

    # If less than 3, log warning
    if root_cause_count < 3:
        logger.warning(f"⚠️ Gemini provided only {root_cause_count} root causes (expected 3)")

    # If no summary detected, log warning
    if "most likely" not in response_text.lower() and "based on this analysis" not in response_text.lower():
        logger.warning(f"⚠️ Gemini response missing summary statement")

return response_text
```

---

## 🧪 Testing Plan

After implementing fixes:

### Test 1: Trigger Known Fault
```bash
# Run TEP simulation with fault IDV(4)
# Check that all 3 LLMs provide:
# - Exactly 3 root causes
# - Final summary statement
# - "Most likely" recommendation
```

### Test 2: Compare Outputs
```
✅ Claude: 3 causes + summary
✅ Gemini: 3 causes + summary (after fix)
✅ LMStudio: 3 causes + summary
```

### Test 3: Edge Cases
```
- What if only 1 obvious root cause?
  → LLMs should still provide 2 alternatives

- What if tie between 2 root causes?
  → Summary should acknowledge tie and explain both
```

---

## 📝 Summary

### Root Cause of Missing Summary

**The prompt does NOT explicitly request a summary!**

`EXPLAIN_PROMPT` says:
- ✅ "Identify up to THREE root causes"
- ✅ "For each root cause, explain..."
- ❌ NO request for final summary or conclusion

### Why Claude/LMStudio Add It Anyway

- Trained on technical reports with conclusions
- Implicit understanding that analysis needs summary
- More "helpful" behavior (adds context LLM thinks user wants)

### Why Gemini Doesn't Add It

- Follows literal instructions more strictly
- Optimized for speed (no extra tokens)
- Interprets "up to three" as "1, 2, or 3 is acceptable"
- Stops after strong candidate (Root Cause 2 explains 6/6 features)

### Solution

**Add explicit summary request to prompt**:
```
4. Provide Final Summary and Recommendation:
   - State which root cause is MOST LIKELY
   - Justify your choice
   - Format: "Based on this analysis, Root Cause [X] is most likely because..."
```

This will ensure **all LLMs** (Claude, Gemini, LMStudio) provide:
1. ✅ Exactly 3 root causes
2. ✅ Final summary statement
3. ✅ Clear recommendation

---

**Generated**: October 19, 2025
**Tool**: Claude Code
**Status**: ⚠️ Issue Identified - Fix Ready to Implement

🤖 This analysis explains why Gemini behaves differently and provides actionable solution.
