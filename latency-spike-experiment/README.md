# Kubernetes Latency Testing with NGINX & Prometheus

## 📌 Overview
This project sets up an **NGINX-based web server** in Kubernetes with **Prometheus monitoring** to test latency changes due to vertical scaling. The experiment monitors HTTP request latencies and dynamically scales pod resources to mitigate high latency spikes.

## 🎯 Objectives
- Deploy an **NGINX** application with Prometheus monitoring.
- Set up **Prometheus alert rules** for detecting latency spikes.
- Automatically **scale pod resources** when latency increases.
- Utilize **Grafana dashboards** for visualization.

## 📁 Project Structure
```
📂 manifests
 ├── namespace.yaml                 # Namespace definition
 ├── nginx-deployment.yaml          # NGINX deployment with Prometheus exporter
 ├── prometheus-rule.yaml           # Prometheus alert rule for latency spikes
 ├── vertical-scaling-job.yaml      # Kubernetes job for vertical scaling
📂 scripts
 ├── apply-manifests.ps1            # Script to apply all Kubernetes manifests
 ├── delete-resources.ps1           # Script to clean up all resources
 ├── port-forward-grafana.ps1       # Script to access Grafana locally
```

## 🚀 Deployment Guide
### 1️⃣ Prerequisites
Ensure you have the following installed:
- [Docker](https://www.docker.com/get-started)
- [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

### 2️⃣ Apply Manifests
Run the following command to deploy the experiment:
```powershell
cd scripts
./apply-manifests.ps1
```

### 3️⃣ Access Metrics and Logs
- **Prometheus Metrics**: Automatically scraped by Prometheus (port `9113`)
- **Grafana Dashboard**: Run the following command to access Grafana UI:
  ```powershell
  ./port-forward-grafana.ps1
  ```
  Then open `http://localhost:3000` in your browser.

### 4️⃣ Clean Up Resources
To delete all resources:
```powershell
cd scripts
./delete-resources.ps1
```

## 📊 Monitoring & Scaling
- **Prometheus Alert Rule**
  - Triggers a warning if the **latency exceeds 1s** for over a minute.
  - Alerts are displayed in Prometheus and Grafana dashboards.

- **Automatic Scaling Job**
  - Periodically increases **CPU & memory limits** of the NGINX pod.
  - Runs inside the cluster as a **Kubernetes Job**.

## 📌 Future Enhancements
🔹 Implement **Horizontal Pod Autoscaler (HPA)** for automatic scaling.
🔹 Configure **custom Grafana dashboards** for real-time visualization.
🔹 Extend to support **network traffic shaping** for more robust testing.

---
🚀 **Built for Kubernetes Performance Optimization!** 💡

