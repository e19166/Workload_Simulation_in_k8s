# E-Commerce Microservices System

## 📌 Overview
This project is a **microservices-based e-commerce system** built using **Spring Boot** and **Kubernetes**. It enables users to place orders, process payments, and manage product inventories in a distributed environment. The system consists of three main microservices:

- **Order Service** 📦 - Handles order creation and status management.
- **Payment Service** 💰 - Manages order payments and transaction statuses.
- **Product Service** 🏪 - Manages product details and stock levels.

Each service communicates via **RESTful APIs** and runs independently within **Docker containers**, deployed on **Kubernetes**.

---
## 🚀 Features
✅ Microservices architecture with independent scalability  
✅ REST API for seamless communication between services  
✅ Dockerized services for easy deployment  
✅ Kubernetes deployment for scalability and resilience  
✅ Efficient stock and order management  
✅ Payment processing simulation  
✅ Lightweight H2 in-memory database for testing  

---
## 🏗️ System Architecture
```
+------------------+       +------------------+       +------------------+
|  Order Service  | <---> | Product Service | <---> | Payment Service  |
+------------------+       +------------------+       +------------------+
```
Each service has its own database and interacts with others via HTTP requests.

---
## 📂 Project Structure
```
/order-service
  ├── src/main/java/com/example/order_service
  │   ├── controller/OrderController.java
  │   ├── model/Order.java
  │   ├── repository/OrderRepository.java
  ├── Dockerfile
  ├── deployment.yaml
  └── service.yaml

/payment-service
  ├── src/main/java/com/example/payment_service
  │   ├── controller/PaymentController.java
  │   ├── model/Payment.java
  │   ├── repository/PaymentRepository.java
  ├── Dockerfile
  ├── deployment.yaml
  └── service.yaml

/product-service
  ├── src/main/java/com/example/product_service
  │   ├── controller/ProductController.java
  │   ├── model/Product.java
  │   ├── repository/ProductRepository.java
  ├── Dockerfile
  ├── deployment.yaml
  └── service.yaml
```
---
## 🛠️ Setup & Deployment
### 1️⃣ Prerequisites
Ensure you have the following installed:
- **Java 17**
- **Maven**
- **Docker**
- **Kubernetes (kubectl & minikube)**

### 2️⃣ Build & Package
```sh
mvn clean package
```
### 3️⃣ Dockerize Services
```sh
docker build -t dockerhub-username/order-service:1.0.0 -f order-service/Dockerfile .
docker build -t dockerhub-username/payment-service:1.0.0 -f payment-service/Dockerfile .
docker build -t dockerhub-username/product-service:1.0.0 -f product-service/Dockerfile .
```
### 4️⃣ Deploy to Kubernetes
```sh
kubectl apply -f order-service/deployment.yaml
kubectl apply -f order-service/service.yaml
kubectl apply -f payment-service/deployment.yaml
kubectl apply -f payment-service/service.yaml
kubectl apply -f product-service/deployment.yaml
kubectl apply -f product-service/service.yaml
```
### 5️⃣ Access Services
- Order Service: `http://localhost:30008/api/orders`
- Payment Service: `http://localhost:30007/api/payments`
- Product Service: `http://localhost:30006/api/products`

---
## 📝 API Endpoints
### Order Service
- `POST /api/orders` - Create a new order
- `GET /api/orders/{id}` - Get order details

### Payment Service
- `POST /api/payments` - Process payment
- `GET /api/payments/{id}` - Get payment details

### Product Service
- `POST /api/products` - Add new product
- `GET /api/products/{id}` - Get product details
- `PUT /api/products/{id}/stock?quantity={num}` - Update stock

---
## 📌 Future Enhancements
🔹 Implement authentication and authorization  
🔹 Integrate a message queue (RabbitMQ/Kafka) for event-driven communication  
🔹 Improve observability with Prometheus & Grafana  
🔹 Implement database persistence with PostgreSQL  

---
## 👨‍💻 Author
**Wishula Jayathunga**  
📧 e19166@eng.pdn.ac.lk  

🚀 Happy Coding! 🎯

