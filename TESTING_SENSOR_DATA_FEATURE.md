# Testing Sensor Data in RCA Snapshots

## Quick Test Steps

### Step 1: Trigger a Fault Analysis
1. Open the **Unified Control Panel** (port 9002)
2. Navigate to the **TEP Simulation** section
3. Trigger a fault (e.g., select a fault type and click "Start Simulation")
4. Wait for anomaly detection to trigger LLM analysis
5. Observe the analysis results

### Step 2: Verify Sensor Data is Saved
1. Open terminal and check the snapshot file:
   ```bash
   tail -1 backend/diagnostics/analysis_history.jsonl | python3 -m json.tool | head -50
   ```
2. Look for the `"sensor_data"` field in the JSON output
3. Verify it contains sensor feature names (XMEAS_1, XMEAS_2, XMV_1, etc.)

### Step 3: Load History and Open Interactive RCA
1. In the **Unified Control Panel**, click **"🔄 Load History"** button
2. Scroll through the **Diagnostic Logs** window
3. Find an RCA entry with a timestamp
4. Click the **"🔗 Click here to discuss this event with RAG →"** link
5. This opens the **Interactive RCA Assistant** in a new window

### Step 4: Verify Sensor Data in Chat Context
1. In the **Interactive RCA** window, look at the top section
2. You should see:
   - **Analysis ID**: [timestamp]
   - **Timestamp**: [date/time]
   - **Feature Analysis**: [text comparison]
   - **[MODEL] Analysis**: [LLM response]
   - **Sensor Data Summary**: [NEW - all 52 sensor features with min/avg/max]

### Step 5: Test Interactive Chat with Sensor Data
1. In the chat input box, ask questions like:
   - "What was the average value of XMEAS_1?"
   - "Which sensor had the highest variation?"
   - "What were the min and max values for XMV_1?"
   - "Compare the sensor readings to normal operation"

2. The AI should now reference the actual sensor data from the snapshot

## Expected Output Format

### Sensor Data Summary Section (in chat context):
```
**Sensor Data Summary** (52 sensor features captured at fault time):
- XMEAS_1: min=3610.80, avg=3611.45, max=3612.10
- XMEAS_2: min=4493.50, avg=4493.80, max=4494.20
- XMEAS_3: min=2632.00, avg=2633.03, max=2634.50
- XMV_1: min=50.40, avg=50.50, max=50.60
- XMV_2: min=45.20, avg=45.35, max=45.50
... (all 52 sensor features)

(Total 52 sensor features captured)
```

## Verification Checklist

- [ ] Sensor data is saved in `analysis_history.jsonl` snapshots
- [ ] Sensor data includes all 52 features (or available features)
- [ ] Each feature has min, avg, max values
- [ ] Interactive RCA displays "Sensor Data Summary" section
- [ ] AI can reference sensor values in chat responses
- [ ] Backward compatibility: old snapshots without sensor_data still work
- [ ] No errors in backend logs when loading snapshots

## Troubleshooting

### Issue: Sensor data not appearing in snapshot
**Solution**: 
- Check that the `/explain` endpoint is being called (not `/explain_gemini`)
- Verify `request.data` contains sensor features
- Check backend logs for errors

### Issue: Chat context doesn't show sensor data
**Solution**:
- Verify snapshot was saved with sensor_data field
- Check that `/chat` endpoint is loading the snapshot correctly
- Look for warnings in backend logs about missing sensor_data

### Issue: Sensor data shows but values are wrong
**Solution**:
- Verify the sensor data is being captured at the right time
- Check that min/avg/max calculations are correct
- Ensure the data structure matches expected format

## Files to Monitor

- **Snapshots**: `backend/diagnostics/analysis_history.jsonl`
- **Backend logs**: `backend/logs/backend.log`
- **Chat history**: `backend/diagnostics/operator_context.jsonl`

## Performance Notes

- Sensor data is stored as-is (no compression)
- Each snapshot may be 10-50KB larger with sensor data
- Chat context building is slightly slower but still <100ms
- No impact on LLM response times

