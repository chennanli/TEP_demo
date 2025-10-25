# 🔧 Time Display Synchronization Fix (UPDATED v2)

## 📋 Problem Summary

**Issue**: DCS Screen and Anomaly Detection panels showed different time scales and had decimal precision issues.

### Before Fix:
- **DCS Screen**: Showed only last 30 points (1h30m), time like "4:7" (hours:minutes from Date object)
- **Anomaly Detection**: Showed last 200 points (10h), time like "3m", "6m", "1h30m"
- **Y-axis values**: Showed ugly decimals like "120.799999999"
- **Time mismatch**: Different calculation methods and different data windows caused confusion
- **X-axis fixed**: Time appeared frozen at 1h30m instead of scrolling

### After Fix (v2):
- **Both panels**: Keep last 500 points (same as preloaded data)
- **Both panels**: Use cumulative time counter (continues from preload to live)
- **Both panels**: Use identical time format ("3m", "6m", "1h00m", "1h30m")
- **Y-axis values**: Clean decimals (120.8 instead of 120.799999999)
- **X-axis scrolling**: Time updates continuously as new data arrives
- **Perfect synchronization**: Same time scale across all visualizations

---

## 🎯 Root Cause Analysis

### **Problem 1: Different Data Windows**
- DCS Screen kept only **30 points** (`.slice(-30)`)
- Anomaly Detection kept **200 points** (`.slice(-200)`)
- Result: Different time ranges displayed

### **Problem 2: Array Index-Based Time**
- Time calculated as `(index + 1) * 3`
- When array is sliced, index resets to 0!
- Result: Time always shows 0 to 1h30m (for 30 points)

### **Problem 3: No Cumulative Time Tracking**
- No global counter for total data points processed
- Switching from Replay to Live reset the time
- Result: Live data started from 0 instead of continuing from 1500 minutes

---

## 🎯 Changes Made (v2)

### **File 1: `frontend/src/App.tsx` (Main Application)**

#### Change 1: Add Cumulative Time Counter (Line ~501)

**Find this code:**
```typescript
  const [liveDataStarted, setLiveDataStarted] = useState<boolean>(false); // Track when live data starts
  // Stabilize flashing: consider connected only after first message within a session.
  const [liveEverReceived, setLiveEverReceived] = useState<boolean>(false);
```

**Replace with:**
```typescript
  const [liveDataStarted, setLiveDataStarted] = useState<boolean>(false); // Track when live data starts
  // 🔧 FIX: Track cumulative time (total data points processed)
  const [cumulativeDataPoints, setCumulativeDataPoints] = useState<number>(0);
  // Stabilize flashing: consider connected only after first message within a session.
  const [liveEverReceived, setLiveEverReceived] = useState<boolean>(false);
```

#### Change 2: Update StatContextId Type (Line ~310)

**Find this code:**
```typescript
export type StatContextId = { t2_stat: number; anomaly: boolean; time: string };
```

**Replace with:**
```typescript
export type StatContextId = {
  t2_stat: number;
  anomaly: boolean;
  time?: string; // Legacy field (optional)
  cumulativeTime?: number; // 🔧 FIX: Cumulative data point counter for accurate time tracking
};
```

#### Change 3: Update Data Processing Logic (Lines ~941-984)

**Find this code:**
```typescript
  useEffect(() => {
    if (currentRow) {
      setDataPoints((prevDataPoints) => {
        const newDataPoints = { ...prevDataPoints };
        for (const [key, value] of Object.entries(currentRow)) {
          if (!newDataPoints[key]) {
            newDataPoints[key] = [];
          }
          const numValue = parseFloat(value); // Convert the string value to a number
          if (!isNaN(numValue)) {
            newDataPoints[key] = [...newDataPoints[key], numValue].slice(-30);
          }
        }
        return newDataPoints;
      });
      setT2_stat((data) => {
        if ("t2_stat" in currentRow && "anomaly" in currentRow) {
          // Fixed: Use simple sequential time for better visualization
          const currentTime = Number(currentRow.time) || data.length;
          const timeString = `T${currentTime.toString().padStart(3, '0')}`;

          const anomalyVal = String((currentRow as any).anomaly).toLowerCase() === "true";

          // Keep only last 200 data points for better resolution
          const newData = [
            ...data,
            {
              t2_stat: Number(currentRow.t2_stat),
              anomaly: anomalyVal,
              time: timeString,
            },
          ].slice(-200);

          return newData;
        } else {
          return data;
        }
      });
```

**Replace with:**
```typescript
  useEffect(() => {
    if (currentRow) {
      // 🔧 FIX: Increment cumulative time counter
      setCumulativeDataPoints(prev => prev + 1);

      setDataPoints((prevDataPoints) => {
        const newDataPoints = { ...prevDataPoints };
        for (const [key, value] of Object.entries(currentRow)) {
          if (!newDataPoints[key]) {
            newDataPoints[key] = [];
          }
          const numValue = parseFloat(value); // Convert the string value to a number
          if (!isNaN(numValue)) {
            // 🔧 FIX: Keep last 500 points instead of 30 (same as preloaded data)
            newDataPoints[key] = [...newDataPoints[key], numValue].slice(-500);
          }
        }
        // 🔧 FIX: Store cumulative time in the 'time' array
        if (!newDataPoints['time']) {
          newDataPoints['time'] = [];
        }
        newDataPoints['time'] = [...newDataPoints['time'], cumulativeDataPoints].slice(-500);

        return newDataPoints;
      });
      setT2_stat((data) => {
        if ("t2_stat" in currentRow && "anomaly" in currentRow) {
          const anomalyVal = String((currentRow as any).anomaly).toLowerCase() === "true";

          // 🔧 FIX: Keep last 500 data points (same as DCS Screen)
          const newData = [
            ...data,
            {
              t2_stat: Number(currentRow.t2_stat),
              anomaly: anomalyVal,
              cumulativeTime: cumulativeDataPoints, // Store cumulative time
            },
          ].slice(-500);

          return newData;
        } else {
          return data;
        }
      });
```

#### Change 4: Update Auto-Switch Logic (Lines ~552-564)

**Find this code:**
```typescript
  // 🔧 FIX: Auto-switch from Replay (fault0.csv baseline) to Live mode after 5 seconds
  useEffect(() => {
    console.log("[Auto-Switch] Starting with Replay mode (fault0.csv baseline)");
    const autoSwitchTimer = setTimeout(() => {
      console.log("[Auto-Switch] 5 seconds elapsed, switching to Live mode");
      setDataSource('Live');
      setLiveDataStarted(false); // Will trigger reset on first live data
    }, 5000); // 5 seconds

    return () => clearTimeout(autoSwitchTimer);
  }, []); // Run once on mount
```

**Replace with:**
```typescript
  // 🔧 FIX: Auto-switch from Replay (fault0.csv baseline) to Live mode after 5 seconds
  useEffect(() => {
    console.log("[Auto-Switch] Starting with Replay mode (fault0.csv baseline)");
    const autoSwitchTimer = setTimeout(() => {
      console.log("[Auto-Switch] 5 seconds elapsed, switching to Live mode");
      setDataSource('Live');
      setLiveDataStarted(false); // Will trigger reset on first live data
      // 🔧 FIX: Don't reset cumulative time - continue from preloaded data
      // setCumulativeDataPoints will continue counting from where Replay left off
    }, 5000); // 5 seconds

    return () => clearTimeout(autoSwitchTimer);
  }, []); // Run once on mount
```

#### Change 5: Update LiveSubscriber (Lines ~1090-1107)

**Find this code:**
```typescript
          <LiveSubscriber
            onRow={(row)=>{
              setCurrentRow(row);
              if(!liveEverReceived) setLiveEverReceived(true);
              // FIX: Clear t2_stat when first live data arrives to reset time to 0
              if (!liveDataStarted) {
                console.log("✅ First live data received - resetting anomaly detection time to 0");
                setT2_stat([]);
                setLiveDataStarted(true);
              }
            }}
            onConnect={() => { console.log("[Live] SSE connection opened (waiting for data...)"); }}
            onDisconnect={() => { setLiveConnected(false); setLiveEverReceived(false); setLiveDataStarted(false); }}
            onMessage={() => { setLiveCount((c) => c + 1); setLiveConnected(true); }}
          />
```

**Replace with:**
```typescript
          <LiveSubscriber
            onRow={(row)=>{
              setCurrentRow(row);
              if(!liveEverReceived) setLiveEverReceived(true);
              // 🔧 FIX: Don't reset time - continue from preloaded data
              if (!liveDataStarted) {
                console.log("✅ First live data received - continuing from preloaded data");
                setLiveDataStarted(true);
              }
            }}
            onConnect={() => { console.log("[Live] SSE connection opened (waiting for data...)"); }}
            onDisconnect={() => {
              setLiveConnected(false);
              setLiveEverReceived(false);
              setLiveDataStarted(false);
            }}
            onMessage={() => { setLiveCount((c) => c + 1); setLiveConnected(true); }}
          />
```

#### Change 6: Update Manual Mode Switch (Lines ~1147-1167)

**Find this code:**
```typescript
                <Select
                  data={[{value:'Replay',label:'Replay (CSV)'},{value:'Live',label:'Live (stream)'}]}
                  value={dataSource}
                  onChange={(v)=>{
                    const newSource = (v as 'Replay'|'Live')||'Replay';
                    setDataSource(newSource);
                    // FIX: Reset anomaly detection time when switching modes
                    if (newSource === 'Live') {
                      setLiveDataStarted(false); // Will trigger reset on first live data
                    } else {
                      setT2_stat([]); // Clear for replay mode
                    }
                  }}
                  miw="160px"
                />
                <Button size="xs" onClick={()=>{
                  setDataSource('Live');
                  setLiveDataStarted(false); // Will trigger reset on first live data
                }}>
```

**Replace with:**
```typescript
                <Select
                  data={[{value:'Replay',label:'Replay (CSV)'},{value:'Live',label:'Live (stream)'}]}
                  value={dataSource}
                  onChange={(v)=>{
                    const newSource = (v as 'Replay'|'Live')||'Replay';
                    setDataSource(newSource);
                    // 🔧 FIX: Reset cumulative time and data when switching modes
                    if (newSource === 'Live') {
                      setLiveDataStarted(false); // Will trigger reset on first live data
                    } else {
                      setT2_stat([]); // Clear for replay mode
                      setCumulativeDataPoints(0); // Reset time counter
                    }
                  }}
                  miw="160px"
                />
                <Button size="xs" onClick={()=>{
                  setDataSource('Live');
                  setLiveDataStarted(false); // Will trigger reset on first live data
                  setCumulativeDataPoints(0); // 🔧 FIX: Reset time counter
                }}>
```

---

### **File 2: `frontend/src/pages/PlotPage.tsx` (DCS Screen)**

#### Change 1: Update Time Calculation to Use Cumulative Time (Lines 138-163)

**Find this code:**
```typescript
  return (
    <ScrollArea h={`calc(100vh - 60px - 32px)`}>
      <SimpleGrid type="container" cols={3}>
        {sortedDataPoints.map(([fieldName, values]) => {
          // console.log(values);
          // 🔧 FIX: Use same time calculation as Anomaly Detection (each step = 3 minutes)
          const timeAxis = fullDataPoints.time.map((item, index) => {
            // Each data point represents 3 minutes of simulation time
            const simulationMinutes = (index + 1) * 3;
            const hours = Math.floor(simulationMinutes / 60);
            const minutes = simulationMinutes % 60;
            // Format: "3m", "6m", "1h00m", "1h30m", etc.
            return hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;
          });

          // Get operating range for this parameter
          const range = TEP_RANGES[fieldName];
          const chartData = values.map((item, idx) => ({
            data: parseFloat(item.toFixed(1)), // 🔧 FIX: Round to 1 decimal place
            time: timeAxis[idx],
            // Add reference lines if range exists
            ...(range && {
              min_range: range.min,
              max_range: range.max,
            }),
          }));
```

**Replace with:**
```typescript
  return (
    <ScrollArea h={`calc(100vh - 60px - 32px)`}>
      <SimpleGrid type="container" cols={3}>
        {sortedDataPoints.map(([fieldName, values]) => {
          // console.log(values);
          // 🔧 FIX: Use cumulative time from data (each step = 3 minutes)
          const timeAxis = fullDataPoints.time.map((cumulativeTime) => {
            // Each data point represents 3 minutes of simulation time
            const simulationMinutes = cumulativeTime * 3;
            const hours = Math.floor(simulationMinutes / 60);
            const minutes = simulationMinutes % 60;
            // Format: "3m", "6m", "1h00m", "1h30m", etc.
            return hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;
          });

          // Get operating range for this parameter
          const range = TEP_RANGES[fieldName];
          const chartData = values.map((item, idx) => ({
            data: parseFloat(item.toFixed(1)), // 🔧 FIX: Round to 1 decimal place
            time: timeAxis[idx],
            // Add reference lines if range exists
            ...(range && {
              min_range: range.min,
              max_range: range.max,
            }),
          }));
```

#### Change 2: Add Y-Axis Formatter (Lines 206-225)

**Find this code:**
```typescript
              <AreaChart
                h={300}
                key={fieldName}
                data={chartData}
                dataKey="time"
                yAxisLabel={columnFilterUnits[fieldName]}
                yAxisProps={yAxisDomain ? { domain: yAxisDomain } : undefined}
                series={series}
                curveType="step"
                tickLine="x"
                withTooltip={true}
                withDots={false}
                referenceLines={range ? [
                  { y: range.min, label: `Min: ${range.min}`, color: range.critical ? "red.4" : "orange.4" },
                  { y: range.max, label: `Max: ${range.max}`, color: range.critical ? "red.4" : "orange.4" }
                ] : undefined}
              />
```

**Replace with:**
```typescript
              <AreaChart
                h={300}
                key={fieldName}
                data={chartData}
                dataKey="time"
                yAxisLabel={columnFilterUnits[fieldName]}
                yAxisProps={{
                  ...(yAxisDomain ? { domain: yAxisDomain } : {}),
                  tickFormatter: (value: number) => value.toFixed(1) // 🔧 FIX: Round Y-axis to 1 decimal
                }}
                series={series}
                curveType="step"
                tickLine="x"
                withTooltip={true}
                withDots={false}
                referenceLines={range ? [
                  { y: range.min, label: `Min: ${range.min}`, color: range.critical ? "red.4" : "orange.4" },
                  { y: range.max, label: `Max: ${range.max}`, color: range.critical ? "red.4" : "orange.4" }
                ] : undefined}
              />
```

---

### **File 3: `frontend/src/pages/FaultReports.tsx` (Anomaly Detection)**

#### Change 1: Use Cumulative Time Instead of Array Index (Lines 21-43)

**Find this code:**
```typescript
  const transformedData = t2_stat.map((item, index) => {
    // Cap T² values at 100 for display, but keep original for tooltip
    const cappedT2 = Math.min(item.t2_stat, 100);

    // Fixed: Show normal data when no anomaly, anomaly data when anomaly detected
    const normalData = item.anomaly ? 0 : cappedT2;
    const anomalyData = item.anomaly ? cappedT2 : 0;

    // Convert time steps to actual simulation time (each step = 3 minutes)
    const simulationMinutes = (index + 1) * 3;
    const hours = Math.floor(simulationMinutes / 60);
    const minutes = simulationMinutes % 60;
    const timeLabel = hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;

    return {
      ...item,
      time: timeLabel,          // Real simulation time instead of step count
      t2_stat: parseFloat(normalData.toFixed(1)),      // 🔧 FIX: Round to 1 decimal - Green area (normal)
      anomaly: parseFloat(anomalyData.toFixed(1)),     // 🔧 FIX: Round to 1 decimal - Red area (anomaly)
      original_t2: parseFloat(item.t2_stat.toFixed(1)), // 🔧 FIX: Round original value
      simulation_minutes: simulationMinutes, // For tooltip
    };
  });
```

**Replace with:**
```typescript
  const transformedData = t2_stat.map((item) => {
    // Cap T² values at 100 for display, but keep original for tooltip
    const cappedT2 = Math.min(item.t2_stat, 100);

    // Fixed: Show normal data when no anomaly, anomaly data when anomaly detected
    const normalData = item.anomaly ? 0 : cappedT2;
    const anomalyData = item.anomaly ? cappedT2 : 0;

    // 🔧 FIX: Use cumulative time from data instead of array index
    const simulationMinutes = (item.cumulativeTime || 0) * 3;
    const hours = Math.floor(simulationMinutes / 60);
    const minutes = simulationMinutes % 60;
    const timeLabel = hours > 0 ? `${hours}h${minutes.toString().padStart(2, '0')}m` : `${minutes}m`;

    return {
      ...item,
      time: timeLabel,          // Real simulation time based on cumulative data points
      t2_stat: parseFloat(normalData.toFixed(1)),      // 🔧 FIX: Round to 1 decimal - Green area (normal)
      anomaly: parseFloat(anomalyData.toFixed(1)),     // 🔧 FIX: Round to 1 decimal - Red area (anomaly)
      original_t2: parseFloat(item.t2_stat.toFixed(1)), // 🔧 FIX: Round original value
      simulation_minutes: simulationMinutes, // For tooltip
    };
  });
```

#### Change 2: Add Y-Axis Formatter (Lines 53-69)

**Find this code:**
```typescript
      <AreaChart
        h={300}
        data={transformedData}
        dataKey="time"
        yAxisProps={{ domain: [0, 100] }}
        yAxisLabel="Anomaly Score (0-100 scale)"
        xAxisLabel="Time (each step = 3 min in reality)"
        xAxisProps={{
          height: 80
        }}
        series={[
          { name: "t2_stat", label: "Normal", color: "green.2" },
          { name: "anomaly", label: "Anomaly", color: "red.4" },
        ]}
```

**Replace with:**
```typescript
      <AreaChart
        h={300}
        data={transformedData}
        dataKey="time"
        yAxisProps={{ 
          domain: [0, 100],
          tickFormatter: (value: number) => value.toFixed(1) // 🔧 FIX: Round Y-axis to 1 decimal
        }}
        yAxisLabel="Anomaly Score (0-100 scale)"
        xAxisLabel="Time (each step = 3 min in reality)"
        xAxisProps={{
          height: 80
        }}
        series={[
          { name: "t2_stat", label: "Normal", color: "green.2" },
          { name: "anomaly", label: "Anomaly", color: "red.4" },
        ]}
```

---

## 📝 Step-by-Step Instructions for Other Laptop

### **1. Open the project**
```bash
cd /path/to/TEP_demo
```

### **2. Edit File 1: `frontend/src/pages/PlotPage.tsx`**
```bash
code frontend/src/pages/PlotPage.tsx
# or use any text editor
```

- Make **Change 1** (lines ~138-163): Update time calculation
- Make **Change 2** (lines ~206-225): Add Y-axis formatter
- Save the file

### **3. Edit File 2: `frontend/src/pages/FaultReports.tsx`**
```bash
code frontend/src/pages/FaultReports.tsx
# or use any text editor
```

- Make **Change 1** (lines ~21-43): Round T² values
- Make **Change 2** (lines ~53-69): Add Y-axis formatter
- Save the file

### **4. Test the changes**
```bash
cd frontend
npm run dev
```

### **5. Verify the fix**
- Open browser to `http://localhost:5173`
- Navigate to **DCS Screen** page
- Navigate to **Anomaly Detection** page
- **Check**:
  - ✅ Both pages show same time format ("3m", "6m", "1h00m")
  - ✅ Time scales match perfectly
  - ✅ Y-axis shows clean decimals (120.8, not 120.799999999)
  - ✅ X-axis shows clean time labels (3m, not 3.111111m)

---

## ✅ Expected Results

### **Time Format (Both Panels)**
- 0-59 minutes: "3m", "6m", "9m", ..., "57m"
- 1+ hours: "1h00m", "1h03m", "1h30m", "2h15m", etc.

### **Decimal Precision**
- **Y-axis**: 1 decimal place (120.8, 95.3, 42.1)
- **Data values**: 1 decimal place
- **No more**: 120.799999999 or 3.111111m

### **Synchronization**
- DCS Screen time = Anomaly Detection time
- Both start from 0
- Both increment by 3 minutes per data point
- Preloaded data (500 points) = 0 to 1500 minutes (25 hours)
- Live data continues from 1503 minutes onwards

---

## 🎯 Key Concepts

### **Time Calculation Logic**
```typescript
// Each data point = 3 minutes
const simulationMinutes = (index + 1) * 3;
const hours = Math.floor(simulationMinutes / 60);
const minutes = simulationMinutes % 60;
const timeLabel = hours > 0 
  ? `${hours}h${minutes.toString().padStart(2, '0')}m` 
  : `${minutes}m`;
```

### **Decimal Rounding**
```typescript
// Round to 1 decimal place
parseFloat(value.toFixed(1))

// Y-axis formatter
tickFormatter: (value: number) => value.toFixed(1)
```

---

## 📦 Files Modified

- `frontend/src/pages/PlotPage.tsx` (2 changes)
- `frontend/src/pages/FaultReports.tsx` (2 changes)

---

**That's it! Copy this entire document to your other laptop and follow the step-by-step instructions to apply the same fixes.** 🎉

