# 🚀 E-Commerce & Kubernetes Performance Projects

Welcome to this **multi-project repository**, which contains a collection of powerful microservices-based e-commerce applications and Kubernetes performance testing projects. Each project is designed with scalability, observability, and real-world use cases in mind. 🚀

## 📌 Table of Contents
- [📖 Overview](#-overview)
- [🛒 E-Commerce Microservices](#-e-commerce-microservices)
- [📊 Kubernetes Performance & Monitoring](#-kubernetes-performance--monitoring)
- [📈 Kubernetes Latency Monitoring & Scaling](#-kubernetes-latency-monitoring--scaling)
- [🔥 Flask CPU-Intensive Task & Load Testing](#-flask-cpu-intensive-task--load-testing)
- [🛠 Setup & Deployment](#-setup--deployment)
- [🔍 Future Enhancements](#-future-enhancements)
- [🤝 Contributing](#-contributing)
- [📩 Contact](#-contact)

---

## 📖 Overview
This repository is a collection of **microservices-based** and **cloud-native** projects, focused on:
✅ **E-commerce Systems** - Order processing, payment, and inventory management with microservices.  
✅ **Kubernetes Performance Testing** - Latency measurements and monitoring with Prometheus and Grafana.  
✅ **Scalable & Containerized Architectures** - All services are Dockerized and can be deployed using Kubernetes.  
✅ **Monitoring & Load Testing** - Implemented with Prometheus, Grafana, and Locust.  

Each project is modular, allowing independent deployment and scaling. Let's dive into the details! 🚀

---

## 🛒 E-Commerce Microservices
This is a **microservices-based e-commerce system** that enables users to place orders, process payments, and manage product inventories.

### 🏗️ Architecture
The system consists of the following microservices:
1️⃣ **Order Service** - Handles order creation and status management. (Port: `8080`)  
2️⃣ **Product Service** - Manages product inventory. (Port: `8081`)  
3️⃣ **Payment Service** - Processes payments and validates transactions. (Port: `8082`)  

All services interact via RESTful APIs and are **containerized using Docker**.

### 🔧 Technologies Used
- **Golang / Java (Spring Boot)** - Backend microservices
- **PostgreSQL** - Database
- **Docker & Kubernetes** - Containerization & orchestration
- **Prometheus & Grafana** - Monitoring & Observability

### 🚀 How to Run
```sh
git clone https://github.com/your-repo.git && cd your-repo
docker-compose up --build
docker ps
```
Access APIs:
- **Order Service**: `http://localhost:8080/api/orders`
- **Product Service**: `http://localhost:8081/api/products`
- **Payment Service**: `http://localhost:8082/api/payments`

---

## 📊 Kubernetes Performance & Monitoring
### 🚀 Flask App with Prometheus & Load Testing
A simple **Flask web application** integrated with **Prometheus monitoring** for real-time metric collection and visualization.

✅ **Metrics**: CPU, memory, request count, latency  
✅ **Load Testing**: Locust-based performance evaluation  
✅ **Deployment**: Kubernetes (Minikube, k3s, cloud clusters)  

### 🔧 How to Run
```sh
pip install flask prometheus_client locust
python app.py
locust -f locustfile.py --host=http://localhost:5000
```

---

## 📈 Kubernetes Latency Monitoring & Scaling
This project demonstrates how to monitor and analyze the effect of **resource scaling on latency** in a Kubernetes environment.

✅ **Deploys an NGINX application** in a Kubernetes cluster  
✅ **Scales CPU & memory resources** dynamically  
✅ **Monitors latency** via HTTP requests  
✅ **Logs latency data** for further analysis  

### 🚀 Deployment Steps
```sh
kubectl apply -f deployment.yaml
pip install requests
python monitor_latency.py
python scale_resources.py
```

---

## 🔥 Flask CPU-Intensive Task & Load Testing
This project deploys a **Flask application with a CPU-intensive task** in Kubernetes and uses **Locust for load testing**.

✅ **Flask app** simulating a CPU-heavy task  
✅ **Kubernetes Deployment** with CPU resource limits  
✅ **Service Exposure** via NodePort/LoadBalancer  
✅ **Load Testing** using Locust  

### 🚀 How to Run
```sh
kubectl apply -f deployment.yaml
pip install locust
locust -f locustfile.py
```

---

## 🛠 Setup & Deployment
### 1️⃣ Prerequisites
Ensure you have the following installed:
- **Docker & Kubernetes (kubectl, minikube, or k3s)**
- **Java 17** (for Spring Boot projects)
- **Go (1.18+)** (for Golang microservices)
- **Python 3.9+** (for Flask & monitoring tools)

### 2️⃣ Running the Applications
For **Docker-based deployment**:
```sh
docker-compose up --build
```
For **Kubernetes-based deployment**:
```sh
kubectl apply -f deployment.yaml
```

---

## 🔍 Future Enhancements
🔹 Implement **API Gateway** for centralized request handling  
🔹 Add **gRPC support** for efficient service communication  
🔹 Improve **observability** with OpenTelemetry  
🔹 Introduce **message queues (RabbitMQ/Kafka)** for event-driven architectures  
🔹 **Auto-scaling**: Implement Kubernetes HPA for CPU-intensive apps  
🔹 **Visualization**: Use Grafana/Kibana for performance insights  

---

## 🤝 Contributing
Contributions are always welcome! 🚀 If you have an idea or a bug fix:
1. Fork the repo 🍴
2. Create a new branch 🛠
3. Commit changes & push 📤
4. Submit a PR 🔄

---

## 📩 Contact
👤 **Wishula Jayathunga**  
📧 Email: e19166@eng.pdn.ac.lk  
💻 GitHub: [@e19166](https://github.com/e19166)

---

🚀 **Happy Coding!** 🎯

