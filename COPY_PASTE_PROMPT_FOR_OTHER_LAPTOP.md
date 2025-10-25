# 📋 Copy-Paste Prompt for Other Laptop

## 🎯 Quick Summary

**What was fixed**:
1. ❌ **Before**: Time showed ugly decimals like "0.150000000002m", "7.9500000m"
2. ❌ **Before**: DCS Screen showed ~3h, Anomaly Detection showed ~6h (different!)
3. ✅ **After**: Clean time labels like "3m", "6m", "1h00m", "15h00m"
4. ✅ **After**: Both panels show same 15-hour window, perfectly synchronized

---

## 📝 Copy This Prompt to AI on Other Laptop

```
Please apply the following changes to fix time display issues in the TEP_demo project:

## Problem:
1. Time axis shows ugly decimals: "0.150000000002m", "7.9500000m"
2. DCS Screen and Anomaly Detection show different time ranges
3. CSV file has a 'time' column with float values that cause issues

## Solution:
Apply these 3 file changes:

---

### File 1: frontend/src/App.tsx

**Change 1**: Around line 948-980, replace the useEffect for currentRow:

Find this section and replace it with:

```typescript
  useEffect(() => {
    if (currentRow) {
      // 🔧 FIX: Increment cumulative time counter FIRST
      setCumulativeDataPoints(prev => {
        const newCount = prev + 1;
        
        // Update data points with new cumulative time
        setDataPoints((prevDataPoints) => {
          const newDataPoints = { ...prevDataPoints };
          for (const [key, value] of Object.entries(currentRow)) {
            // 🔧 FIX: Skip CSV 'time' column - we use cumulative time instead
            if (key === 'time') continue;
            
            if (!newDataPoints[key]) {
              newDataPoints[key] = [];
            }
            const numValue = parseFloat(value); // Convert the string value to a number
            if (!isNaN(numValue)) {
              // 🔧 FIX: Keep last 300 points (300 * 3min = 900min = 15h)
              newDataPoints[key] = [...newDataPoints[key], numValue].slice(-300);
            }
          }
          // 🔧 FIX: Store cumulative time (keep as number, will format for display)
          if (!newDataPoints['time']) {
            newDataPoints['time'] = [];
          }
          newDataPoints['time'] = [...newDataPoints['time'], newCount].slice(-300);

          return newDataPoints;
        });
        
        return newCount;
      });

      // Update T2 stat with new cumulative time
      setT2_stat((data) => {
        if ("t2_stat" in currentRow && "anomaly" in currentRow) {
          const anomalyVal = String((currentRow as any).anomaly).toLowerCase() === "true";

          // 🔧 FIX: Keep last 300 data points (same as DCS Screen)
          const newData = [
            ...data,
            {
              t2_stat: Number(currentRow.t2_stat),
              anomaly: anomalyVal,
              cumulativeTime: cumulativeDataPoints + 1, // Use the new count
            },
          ].slice(-300);

          return newData;
        } else {
          return data;
        }
      });
    }
  }, [currentRow]);
```

**Key changes**:
- Skip CSV 'time' column (line with `if (key === 'time') continue;`)
- Changed `.slice(-500)` to `.slice(-300)` (2 places)
- Increment cumulative counter FIRST, then use it

---

### File 2: frontend/src/pages/PlotPage.tsx

**Change 1**: Around line 143-153, update time calculation:

Find the timeAxis mapping and replace with:

```typescript
          // 🔧 FIX: Use cumulative time from data (each step = 3 minutes)
          const timeAxis = fullDataPoints.time.map((cumulativeTime) => {
            // 🔧 FIX: Round to integer to avoid floating point issues (0.15 -> 0, 1.0 -> 1)
            const cumulativeInt = Math.round(Number(cumulativeTime));
            // Each data point represents 3 minutes of simulation time
            const simulationMinutes = cumulativeInt * 3;
            const hours = Math.floor(simulationMinutes / 60);
            const minutes = simulationMinutes % 60;
            // Format: "3m", "6m", "1h00m", "1h30m", etc.
            return hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;
          });
```

**Key change**: Added `Math.round(Number(cumulativeTime))` to ensure integer values

---

### File 3: frontend/src/pages/FaultReports.tsx

**Change 1**: Around line 29-34, update time calculation:

Find the simulationMinutes calculation and replace with:

```typescript
    // 🔧 FIX: Use cumulative time from data instead of array index
    const cumulativeInt = Math.round(item.cumulativeTime || 0); // Round to integer
    const simulationMinutes = cumulativeInt * 3;
    const hours = Math.floor(simulationMinutes / 60);
    const minutes = simulationMinutes % 60;
    const timeLabel = hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;
```

**Key change**: Added `Math.round()` to ensure integer values

---

## ✅ Expected Results:

**Before**:
- Time: "0.150000000002m", "7.9500000m" ❌
- DCS Screen: ~3h window
- Anomaly Detection: ~6h window
- Different time ranges ❌

**After**:
- Time: "3m", "6m", "1h00m", "15h00m" ✅
- DCS Screen: 15h window (300 points)
- Anomaly Detection: 15h window (300 points)
- Perfect synchronization ✅
- Live data continues from 15h03m, 15h06m, etc. ✅

---

## 🔍 How to Verify:

1. Start the system: `./start_all.command`
2. Open browser: `http://localhost:5173`
3. Check DCS Screen: Time should show clean labels like "3m", "6m", "1h00m"
4. Check Anomaly Detection: Should show same time range as DCS Screen
5. Both panels should be perfectly synchronized

---

Please apply these changes and commit them to the repository.
```

---

## 🚀 Alternative: Just Pull from GitHub

If you prefer, you can simply pull the latest changes:

```bash
cd /path/to/TEP_demo
git pull origin main
```

This will automatically apply all the fixes!

---

## 📊 Technical Details

### What Changed:

1. **CSV 'time' column is now skipped**
   - The CSV has a 'time' column with float values (0.05, 0.1, 0.15000000000000002)
   - We now skip this column entirely: `if (key === 'time') continue;`
   - Use integer cumulative counter instead

2. **Data retention reduced to 300 points**
   - Changed from 500 points to 300 points
   - 300 points × 3 min/point = 900 min = 15 hours
   - Both DCS Screen and Anomaly Detection keep same 300 points

3. **Integer rounding for display**
   - Added `Math.round(Number(cumulativeTime))` in both display components
   - Ensures clean integer values for time calculation
   - No more floating point precision issues

### Python Equivalent (for reference):

In Python, you would format decimals like this:
```python
# 2 decimal places
value = 120.799999999
formatted = f"{value:.2f}"  # "120.80"

# 1 decimal place
formatted = f"{value:.1f}"  # "120.8"

# No decimal places (integer)
formatted = f"{value:.0f}"  # "121"
```

In JavaScript/TypeScript, we use:
```typescript
value.toFixed(2)  // "120.80" (2 decimals)
value.toFixed(1)  // "120.8" (1 decimal)
Math.round(value) // 121 (integer)
```

---

**That's it! Copy the prompt above and paste it to the AI on your other laptop.** 🎉

