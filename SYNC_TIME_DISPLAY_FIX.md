# 🔧 Time Display Synchronization Fix

## 📋 Problem Summary

**Issue**: DCS Screen and Anomaly Detection panels showed different time scales and had decimal precision issues.

### Before Fix:
- **DCS Screen**: Showed time like "4:7" (hours:minutes from Date object)
- **Anomaly Detection**: Showed time like "3m", "6m", "1h30m"
- **Y-axis values**: Showed ugly decimals like "120.799999999"
- **Time mismatch**: Different calculation methods caused confusion

### After Fix:
- **Both panels**: Use identical time format ("3m", "6m", "1h00m", "1h30m")
- **Both panels**: Start from 0 and increment by 3 minutes per data point
- **Y-axis values**: Clean decimals (120.8 instead of 120.799999999)
- **Perfect synchronization**: Same time scale across all visualizations

---

## 🎯 Changes Made

### **File 1: `frontend/src/pages/PlotPage.tsx` (DCS Screen)**

#### Change 1: Update Time Calculation (Lines 138-163)

**Find this code:**
```typescript
  return (
    <ScrollArea h={`calc(100vh - 60px - 32px)`}>
      <SimpleGrid type="container" cols={3}>
        {sortedDataPoints.map(([fieldName, values]) => {
          // console.log(values);
          const timeAxis = fullDataPoints.time.map((item) => {
            const date = new Date(
              startTime.getTime() + (item * 3 * 60000) / 0.05
            );
            return date.getHours() + ":" + date.getMinutes();
          });

          // Get operating range for this parameter
          const range = TEP_RANGES[fieldName];
          const chartData = values.map((item, idx) => ({
            data: item,
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

### **File 2: `frontend/src/pages/FaultReports.tsx` (Anomaly Detection)**

#### Change 1: Round T² Values (Lines 21-43)

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
      t2_stat: normalData,      // Green area - only when normal
      anomaly: anomalyData,     // Red area - only when anomaly
      original_t2: item.t2_stat, // Keep original value for reference
      simulation_minutes: simulationMinutes, // For tooltip
    };
  });
```

**Replace with:**
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

