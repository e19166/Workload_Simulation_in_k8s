# Kubernetes Resource Scaling and Latency Monitoring

This project demonstrates how to monitor and analyze the effect of resource scaling on the latency of a web application running in a Kubernetes environment. It uses a simple Nginx deployment, scales its CPU and memory resources, and tracks the latency of requests made to the service. The latency data is logged to a file for further analysis, allowing you to observe the performance impact of resource adjustments.

## Overview

This project is designed to:

- **Deploy a simple Nginx application** in a Kubernetes cluster.
- **Scale resources (CPU and memory)** for the application dynamically.
- **Monitor latency** by sending HTTP requests to the application.
- **Log latency data** to a file, capturing both request latency and errors.
- **Automate the entire process** of scaling resources, restarting pods, and monitoring latency.

The project includes the following components:

1. **Kubernetes Deployment**: Deploys an Nginx application in a Kubernetes cluster and exposes it via a service.
2. **Resource Scaling**: Scales the application's CPU and memory requests and limits.
3. **Latency Monitoring**: Continuously monitors the latency of HTTP requests made to the application and logs the results.
4. **Port-Forwarding**: Uses Kubernetes port-forwarding to access the application locally for latency testing.

## Features

- **Automatic Resource Scaling**: Dynamically adjusts CPU and memory resources for the Nginx deployment.
- **Latency Measurement**: Measures the time taken for HTTP requests to complete, logging the results.
- **Real-time Logging**: Latency data and errors are logged with timestamps for easy analysis.
- **Seamless Kubernetes Integration**: Utilizes `kubectl` commands for resource scaling, pod management, and port-forwarding.
- **Error Handling**: Catches and logs any errors during latency measurement or resource scaling.

## Project Structure

- **Kubernetes Deployment**: A `Deployment` resource that runs Nginx and exposes it via a `Service`.
- **Python Latency Monitoring Script**: A script that repeatedly sends requests to the application and logs the latency.
- **Resource Scaling Script**: A script that scales the CPU and memory resources of the Kubernetes deployment and restarts the pods.

### Kubernetes Manifest (`deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
      - name: app-container
        image: nginx
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: test-app-service
spec:
  selector:
    app: test-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```
# Installation
## 1. Clone the Repository
```bash
git clone https://github.com/yourusername/k8s-latency-scaling.git
cd k8s-latency-scaling
```
## 2. Deploy the Application
Apply the Kubernetes manifests to deploy the Nginx application and expose it as a service:

```bash
kubectl apply -f deployment.yaml
```
## 3. Install Dependencies for Latency Monitoring
Ensure that Python and the requests module are installed for latency monitoring:

```bash
pip install requests
```
## 4. Run the Latency Monitoring Script
The latency monitoring script continuously sends HTTP requests to the Nginx application and logs the latency:

```bash
python monitor_latency.py
```
## 5. Scale Resources
Run the resource scaling script to adjust the CPU and memory requests and limits of the Nginx deployment:

```bash
python scale_resources.py
```
## 6. Port Forwarding
Use Kubernetes port-forwarding to access the application locally and measure latency:

```bash
python port_forward.py
```
# How It Works
1. Initial Deployment: The Nginx application is deployed with specific CPU and memory resource limits.
2. Latency Measurement: The Python script sends HTTP requests to the application every 0.5 seconds and logs the response latency, including the HTTP status code and any errors encountered.
3. Resource Scaling: The script dynamically adjusts the CPU and memory resources of the Nginx application using Kubernetes commands (kubectl set resources), allowing you to observe how resource scaling impacts application latency.
4. Pod Restart: After scaling the resources, the application pods are restarted to apply the new resource configurations.
5. Port Forwarding: Port-forwarding is used to allow the local machine to communicate with the Kubernetes service, enabling continuous latency monitoring.

## Example Latency Log
The latency logs are saved in a text file with timestamps, HTTP status codes, and latency data:

```yaml
2025-02-11 15:42:01, 200, 0.023
2025-02-11 15:42:01, 200, 0.021
2025-02-11 15:42:02, 500, 0.035
```
# Conclusion
This project provides insights into the performance impact of resource scaling on Kubernetes applications. By analyzing the latency data, you can understand how scaling resources affects application performance and optimize your resource allocation strategies.

# Future Improvements
* Auto-scaling: Integrate Kubernetes Horizontal Pod Autoscaler (HPA) to automatically adjust resources based on latency.
* Visualization: Implement tools like Grafana or Kibana for visualizing latency and resource usage trends.
* Advanced Metrics: Add more detailed monitoring for CPU, memory, and network usage during scaling.

# Acknowledgments
1. Kubernetes for its robust container orchestration capabilities.
2. The requests library for simplifying HTTP requests.
3. The Kubernetes community for making it easier to scale and manage applications at scale.

# Contact
For any questions or suggestions, feel free to reach out:
```pgsql
Email: e19166@eng.pdn.ac.lk
GitHub: @e19166
```
