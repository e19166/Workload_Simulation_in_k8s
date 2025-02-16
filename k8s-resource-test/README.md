# Kubernetes Resource Scaling Experiment

This project automates the deployment of a Kubernetes application, dynamically adjusts resource allocations, and collects latency metrics to analyze the impact of resource scaling on performance.

## 📌 Project Structure
```
├── manifests/
│   ├── test-app.yaml        # Kubernetes deployment and service manifest
├── results/
│   ├── latency_data.csv     # Collected latency metrics
├── scripts/
│   ├── deploy_app.ps1       # Deploys the application
│   ├── collect_metrics.ps1  # Collects latency metrics
│   ├── adjust_resources.ps1 # Adjusts CPU and memory allocations
│   ├── analyze_results.ps1  # Plots latency over time
│   ├── run_experiment.ps1   # Main script to run the experiment
└── README.md                # This documentation
```

## 🛠 Prerequisites
- Windows with PowerShell
- Kubernetes cluster (Minikube, Kind, or a cloud provider)
- `kubectl` installed and configured
- Python (for analysis)
- `matplotlib` and `pandas` for graphing results

## 🚀 Setup and Execution
### 1️⃣ Deploy the Application
```powershell
.\scripts\deploy_app.ps1
```
This script:
- Creates a Kubernetes namespace
- Deploys a simple Python web server
- Waits for the pod to be ready

### 2️⃣ Run the Experiment
```powershell
.\scripts\run_experiment.ps1
```
This script:
- Deploys the application
- Sets up port forwarding
- Collects initial latency metrics
- Adjusts resource allocations (CPU & Memory)
- Waits for the pod to restart
- Collects post-adjustment latency metrics
- Analyzes and visualizes the results
- Stops port forwarding

### 3️⃣ Stopping Port Forwarding Manually
If needed, stop the port forwarding manually:
```powershell
Get-Process | Where-Object { $_.ProcessName -like "*kubectl*" } | Stop-Process -Force
```

## 📊 Latency Analysis
### **Plot Latency Graph**
```python
import pandas as pd
import matplotlib.pyplot as plt

file_path = ".csv file path"
df = pd.read_csv(file_path, names=["Timestamp", "Latency"], parse_dates=["Timestamp"])

plt.figure(figsize=(20, 10))
plt.plot(df["Timestamp"], df["Latency"], marker="o", linestyle="-", color="b", label="Latency (ms)")
plt.xlabel("Time")
plt.ylabel("Latency (ms)")
plt.title("Latency vs Time")
plt.xticks(rotation=45)
plt.legend()
plt.grid(True)
plt.show()
```

## 🔄 How Resource Adjustment Works
- The `adjust_resources.ps1` script modifies CPU and memory requests/limits.
- If CPU limits change, the pod **must restart** for changes to take effect.
- If only memory limits change, the pod **does not require a restart** (handled dynamically).

## ❗ Troubleshooting
- **Port Forwarding Issues**: Restart using `kubectl port-forward` manually.
- **Pod Restart Failure**: Check logs with:
  ```powershell
  kubectl logs -l app=test-app -n test-namespace
  ```
- **Metrics Not Collected**: Ensure `Invoke-WebRequest` works correctly.

## 📌 Future Enhancements
- Automate real-time resource monitoring
- Extend to horizontal pod scaling experiments
- Implement detailed statistical analysis of results


