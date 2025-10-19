#!/usr/bin/env python3
"""
TEP-FaultExplainer Data Bridge
Connects live TEP simulation data to FaultExplainer analysis
"""

import pandas as pd
import numpy as np
import time
import requests
import json
import os
from collections import deque
from datetime import datetime

class TEPFaultExplainerBridge:
    """Bridge between TEP simulation and FaultExplainer"""
    
    def __init__(self):
        self.live_data_file = "data/live_tep_data.csv"
        # 🔧 FIX: Use localhost instead of hardcoded IP (Mac compatibility)
        self.faultexplainer_url = "http://127.0.0.1:8000"
        self.window_size = 20
        self.data_buffer = deque(maxlen=self.window_size)
        self.last_processed_step = -1
        
        # TEP to FaultExplainer variable mapping
        self.variable_mapping = {
            'XMEAS_1': 'A Feed',
            'XMEAS_2': 'D Feed', 
            'XMEAS_3': 'E Feed',
            'XMEAS_4': 'A and C Feed',
            'XMEAS_5': 'Recycle Flow',
            'XMEAS_6': 'Reactor Feed Rate',
            'XMEAS_7': 'Reactor Pressure',
            'XMEAS_8': 'Reactor Level',
            'XMEAS_9': 'Reactor Temperature',
            'XMEAS_10': 'Purge Rate',
            'XMEAS_11': 'Product Sep Temp',
            'XMEAS_12': 'Product Sep Level',
            'XMEAS_13': 'Product Sep Pressure',
            'XMEAS_14': 'Product Sep Underflow',
            'XMEAS_15': 'Stripper Level',
            'XMEAS_16': 'Stripper Pressure',
            'XMEAS_17': 'Stripper Underflow',
            'XMEAS_18': 'Stripper Temp',
            'XMEAS_19': 'Stripper Steam Flow',
            'XMEAS_20': 'Compressor Work',
            'XMEAS_21': 'Reactor Coolant Temp',
            'XMEAS_22': 'Separator Coolant Temp'
        }
        
        print("🌉 TEP-FaultExplainer Bridge initialized")
        print(f"📁 Monitoring: {self.live_data_file}")
        print(f"🔗 FaultExplainer: {self.faultexplainer_url}")
    
    def check_faultexplainer_status(self):
        """Check if FaultExplainer backend is running"""
        try:
            response = requests.get(f"{self.faultexplainer_url}/", timeout=2)
            return response.status_code == 200
        except:
            return False
    
    def read_new_data(self):
        """Read new data points from live TEP CSV"""
        try:
            if not os.path.exists(self.live_data_file):
                return []
            
            df = pd.read_csv(self.live_data_file)
            if df.empty:
                return []
            
            # Get new data points since last processing
            new_data = df[df['step'] > self.last_processed_step]
            
            if not new_data.empty:
                self.last_processed_step = new_data['step'].max()
                return new_data.to_dict('records')
            
            return []
            
        except Exception as e:
            print(f"❌ Error reading data: {e}")
            return []
    
    def map_tep_to_faultexplainer(self, tep_data):
        """Convert TEP variable names to FaultExplainer format.
        Supports both XMEAS_* input and already-friendly names (e.g., 'A Feed').
        """
        mapped_data = {}

        # Case 1: XMEAS_* style keys present
        has_xmeas = any(k.startswith('XMEAS_') for k in tep_data.keys())
        if has_xmeas:
            for tep_name, fe_name in self.variable_mapping.items():
                if tep_name in tep_data:
                    mapped_data[fe_name] = tep_data[tep_name]
        else:
            # Case 2: Already-friendly keys present; pass through expected keys
            for fe_name in self.variable_mapping.values():
                if fe_name in tep_data:
                    mapped_data[fe_name] = tep_data[fe_name]

        # Add timestamp and step info (optional)
        mapped_data['timestamp'] = tep_data.get('timestamp', time.time())
        mapped_data['step'] = tep_data.get('step', tep_data.get('time', 0))

        return mapped_data
    
    def send_to_faultexplainer(self, window_data):
        """Legacy stub retained for compatibility. Backend no longer exposes /analyze.
        Live LLM triggering is handled inside /ingest; nothing to call here.
        """
        print("ℹ️ Skipping legacy /analyze call (handled by /ingest now)")
        return None
    
    def process_data_point(self, tep_data):
        """Process a single TEP data point"""
        # Map TEP variables to FaultExplainer format
        mapped_data = self.map_tep_to_faultexplainer(tep_data)

        # POST live point immediately for PCA + LLM triggering
        try:
            resp = requests.post(
                f"{self.faultexplainer_url}/ingest",
                json={"data_point": {k: v for k, v in mapped_data.items() if k in self.variable_mapping.values()}},
                timeout=60,
            )
            if resp.status_code == 200:
                info = resp.json()
                if info.get("llm", {}).get("status") == "triggered":
                    print("🤖 LLM analysis triggered (live)")
            else:
                print(f"⚠️ Ingest HTTP {resp.status_code}")
        except Exception as e:
            print(f"❌ Error posting /ingest: {e}")

        # Also maintain a local sliding window for optional /analyze batch route (legacy)
        self.data_buffer.append(mapped_data)
        print(f"📊 Buffer size: {len(self.data_buffer)}/{self.window_size}")
        if len(self.data_buffer) == self.window_size:
            # Legacy batch call removed; /ingest already triggers LLM when criteria met
            pass
        return None
    
    def run_bridge(self):
        """Main bridge loop - monitors TEP data and sends to FaultExplainer"""
        print("🚀 Starting TEP-FaultExplainer bridge...")
        print("📡 Monitoring for new TEP data...")
        
        while True:
            try:
                # Check for new data
                new_data_points = self.read_new_data()
                
                if new_data_points:
                    print(f"📥 Found {len(new_data_points)} new data points")
                    
                    for data_point in new_data_points:
                        result = self.process_data_point(data_point)
                        
                        if result:
                            print(f"🎯 Analysis complete for step {data_point['step']}")
                
                # Wait before checking again (0.5s for ultra-fast real-time response)
                time.sleep(0.5)  # 0.5s = 2x faster than 1s, reduces lag significantly
                
            except KeyboardInterrupt:
                print("\n🛑 Bridge stopped by user")
                break
            except Exception as e:
                print(f"❌ Bridge error: {e}")
                time.sleep(10)

def main():
    """Run the bridge"""
    bridge = TEPFaultExplainerBridge()
    
    print("\n" + "="*60)
    print("🌉 TEP-FAULTEXPLAINER DATA BRIDGE")
    print("="*60)
    print("This connects live TEP simulation to FaultExplainer analysis")
    print()
    print("📋 Prerequisites:")
    print("1. TEP simulation running (generating data/live_tep_data.csv)")
    print("2. FaultExplainer backend running (http://10.252.64.231:8000)")
    print()
    print("🔄 Data Flow:")
    print("TEP Simulation → CSV → Bridge → FaultExplainer → Analysis")
    print()
    
    # Check prerequisites
    if not bridge.check_faultexplainer_status():
        print("❌ FaultExplainer backend not running!")
        print("💡 Start it with: cd backend && python app.py")
        return
    
    if not os.path.exists(bridge.live_data_file):
        print("❌ No live TEP data found!")
        print("💡 Start TEP simulation with: python real_tep_simulator.py")
        return
    
    print("✅ All prerequisites met - starting bridge...")
    bridge.run_bridge()

if __name__ == "__main__":
    main()
