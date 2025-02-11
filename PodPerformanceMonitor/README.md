# Flask Application with CPU Intensive Task and Load Testing

This project demonstrates how to deploy a Flask application with a CPU-intensive task on Kubernetes, expose it via a service, and perform load testing using Locust. The application simulates a CPU-heavy operation and measures how it performs under load. 

## Project Overview

- **Flask Application**: A simple Flask app with an endpoint `/cpu` that performs a CPU-intensive task.
- **Kubernetes Deployment**: Deploy the Flask app on Kubernetes, with resource requests and limits set for CPU.
- **Service Exposure**: Expose the Flask app through a Kubernetes service with a NodePort or LoadBalancer.
- **Load Testing**: Use Locust to perform load testing on the `/cpu` endpoint and measure its performance under simulated user load.

## Components

### 1. Flask Application (`app.py`)

The Flask application contains a CPU-intensive task. The `/cpu` endpoint simulates a heavy computation task (calculating powers of 2) and returns the time taken to complete the task.

```python
from flask import Flask
import time

app = Flask(__name__)

@app.route('/cpu')
def cpu_intensive_task():
    start_time = time.time()
    for _ in range(1000):  # Simulate CPU load
        _ = 2**10  
    return f"Task completed in {time.time() - start_time} seconds"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### 2. Dockerfile

The Dockerfile creates a container image for the Flask app. It installs Python, copies the `app.py` file into the container, and runs the Flask app.

```dockerfile
FROM python:3.9
WORKDIR /app
COPY app.py /app
RUN pip install flask
CMD ["python", "app.py"]
```

### 3. Kubernetes Deployment (`deployment.yaml`)

The Kubernetes deployment defines the Flask app container's resource requests and limits. The application is exposed on port 82 through a NodePort or LoadBalancer service.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: flask-app
          image: wishula/my-flask-app:latest
          resources:
            requests:
              cpu: "250m"  # 250 millicores (0.25 vCPU)
            limits:
              cpu: "500m"   # 500 millicores (0.5 vCPU)
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
spec:
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 82      # Expose service on port 80
      targetPort: 5000  # Forward to Flask app's container port
  type: NodePort  # Change to NodePort or LoadBalancer if needed
```

### 4. Load Testing with Locust (`locustfile.py`)

The `locustfile.py` script is used for load testing the `/cpu` endpoint. Locust will simulate multiple users hitting the `/cpu` endpoint to test how the Flask app performs under load.

```python
from locust import HttpUser, task, between

class LoadTest(HttpUser):
    wait_time = between(1, 3)

    @task
    def cpu_test(self):
        self.client.get("/cpu")
```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/k8s-flask-cpu-load-test.git
cd k8s-flask-cpu-load-test
```

### 2. Build and Push Docker Image

```bash
docker build -t wishula/my-flask-app:latest .
docker push wishula/my-flask-app:latest
```

### 3. Deploy the Application to Kubernetes

```bash
kubectl apply -f deployment.yaml
```

### 4. Install Locust for Load Testing

```bash
pip install locust
```

### 5. Run Load Testing with Locust

```bash
locust -f locustfile.py
```

Open a browser and navigate to `http://localhost:8089` to start the load test.

### 6. Monitor Application Logs

```bash
kubectl logs -f <pod-name>
```

## How It Works

- **Flask Application**: The `/cpu` endpoint performs a CPU-intensive task (calculating powers of 2) and returns the time it took to complete the task.
- **Kubernetes Deployment**: The Flask app is deployed with specific CPU resource requests and limits, ensuring that it can scale or be constrained based on Kubernetes settings.
- **Service Exposure**: The application is exposed using a Kubernetes service, which can be accessed externally using a NodePort or LoadBalancer.
- **Load Testing with Locust**: Locust simulates multiple users hitting the `/cpu` endpoint, allowing you to test how the Flask app performs under load.

## Example Output

The `/cpu` endpoint will return a response like:

```
Task completed in 0.032 seconds
```

## Future Improvements

- **Horizontal Pod Autoscaling**: Integrate Kubernetes Horizontal Pod Autoscaler (HPA) to dynamically scale the application based on CPU usage.
- **Performance Monitoring**: Use tools like Prometheus and Grafana to monitor performance metrics and visualize scaling and resource usage.
- **Error Handling**: Improve error handling in the Flask app to handle unexpected situations gracefully.

## Contact

For any questions or suggestions, feel free to reach out:

- **Email**: e19166@eng.pdn.ac.lk
- **GitHub**: [@e19166](https://github.com/e19166)