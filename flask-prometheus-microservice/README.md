# Flask App with Prometheus Monitoring and Load Testing

## Overview
This project is a simple Flask web application integrated with Prometheus monitoring, running inside a Docker container and deployed on Kubernetes. It provides:

- **HTTP endpoints** (`/` and `/metrics`)
- **Prometheus monitoring** for CPU, memory, request count, and latency
- **Locust load testing** for performance evaluation
- **Containerization** using Docker
- **Kubernetes deployment** with Prometheus scraping enabled

---

## Features
✅ **Flask API**: Simple HTTP web server with Prometheus instrumentation  
✅ **Prometheus Integration**: Collects metrics like CPU, memory usage, request count, and latency  
✅ **Multi-threaded Metrics Collection**: Runs a background thread to update system metrics  
✅ **Load Testing with Locust**: Simulates user requests for performance testing  
✅ **Dockerized**: Runs as a container for easy deployment  
✅ **Kubernetes Deployment**: Supports scaling and Prometheus auto-scraping  

---

## Architecture

```
 +--------------------+       +------------------+        +------------------+
 |  Flask Web App    | ----> |  Prometheus      | ---->  |  Grafana Dashboard |
 +--------------------+       +------------------+        +------------------+
        |                                        
        |-----> Kubernetes Deployment
        |-----> Locust Load Testing
```

---

## Installation & Setup

### 1️⃣ Prerequisites
Ensure you have the following installed:
- Python 3.9+
- Docker
- Kubernetes (minikube, k3s, or a cloud cluster)
- Prometheus & Grafana (optional)

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/your-repo/flask-prometheus-app.git
cd flask-prometheus-app
```

### 3️⃣ Install Dependencies
```bash
pip install flask prometheus_client psutil locust
```

### 4️⃣ Run the Flask App Locally
```bash
python app.py
```

### 5️⃣ Build and Run with Docker
```bash
docker build -t flask-prometheus-app .
docker run -p 5000:5000 flask-prometheus-app
```

### 6️⃣ Deploy to Kubernetes
```bash
kubectl apply -f deployment.yaml
kubectl get pods
```

---

## API Endpoints

### 1️⃣ Root Endpoint
```
GET /
Response: "Hello, World!"
```

### 2️⃣ Metrics Endpoint (For Prometheus)
```
GET /metrics
Response: Prometheus-formatted metrics
```

---

## Monitoring with Prometheus
1. **Start Prometheus**
2. Add the following scrape config to `prometheus.yml`:
   ```yaml
   scrape_configs:
     - job_name: 'flask-app'
       static_configs:
         - targets: ['flask-app.default.svc.cluster.local:5000']
   ```
3. **Access Prometheus UI**: `http://localhost:9090`

---

## Load Testing with Locust

### Start Locust
```bash
locust -f locustfile.py --host=http://localhost:5000
```
### Run Load Test
1. Open `http://localhost:8089`
2. Enter user count and spawn rate
3. Click **Start Swarming**

---

## Future Enhancements
✅ Add more detailed logs with structured logging  
✅ Implement distributed tracing with OpenTelemetry  
✅ Extend monitoring with additional custom metrics  
✅ Deploy with Helm charts for better manageability  

---

## Contributors
👤 **Wishula Jayathunga** - *Developer & Maintainer*  
📧 Contact: `e19166@eng.pdn.ac.lk`

---

🚀 **Happy Monitoring!** 🚀

