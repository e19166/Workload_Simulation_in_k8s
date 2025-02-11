# 🛒 E-Commerce Microservices Project

## 📌 Overview
This project is a microservices-based e-commerce system that enables order placement, payment processing, and inventory management. The system is designed for scalability, resilience, and flexibility using containerized services.

## 🏗️ Architecture
The application consists of three main microservices:

1. **Order Service (port: 8080)**
   - Handles order creation and manages order status.
   - Calls the Product Service to update stock.
   - Communicates with the Payment Service to process payments.

2. **Product Service (port: 8081)**
   - Manages product inventory.
   - Exposes APIs to fetch product details and update stock after an order.

3. **Payment Service (port: 8082)**
   - Processes payments for orders.
   - Verifies order details before confirming payment.

All services interact via RESTful APIs and are containerized using Docker.

## 🛠️ Technologies Used
- **Golang** - Backend microservices
- **PostgreSQL** - Database for orders and products
- **Docker & Docker Compose** - Containerization and service orchestration
- **Kubernetes** *(Optional)* - For deploying microservices in a cluster
- **Prometheus & Grafana** *(Optional)* - Monitoring and observability

## 🚀 Getting Started
### Prerequisites
Ensure you have the following installed:
- Docker & Docker Compose
- Go (1.18+)
- PostgreSQL

### 🔧 Setup & Run
1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-repo/ecommerce-microservices.git
   cd ecommerce-microservices
   ```

2. **Start services using Docker Compose:**
   ```sh
   docker-compose up --build
   ```

3. **Verify running containers:**
   ```sh
   docker ps
   ```

4. **Access API Endpoints:**
   - Order Service: `http://localhost:8080/api/orders`
   - Product Service: `http://localhost:8081/api/products`
   - Payment Service: `http://localhost:8082/api/payments`

## 📌 API Endpoints
### Order Service
- **Create Order** (POST) → `/api/orders`
- **Get Order by ID** (GET) → `/api/orders/{id}`

### Product Service
- **Get Product by ID** (GET) → `/api/products/{id}`
- **Update Stock** (PUT) → `/api/products/{id}/stock`

### Payment Service
- **Process Payment** (POST) → `/api/payments`

## 📊 Monitoring (Optional)
To enable observability, integrate Prometheus and Grafana:
1. Start Prometheus & Grafana:
   ```sh
   docker-compose -f monitoring.yml up -d
   ```
2. Open Grafana: `http://localhost:3000`
3. Connect Prometheus as a data source and visualize metrics.

## 🏆 Future Enhancements
- Implement an API Gateway for centralized routing.
- Add gRPC support for high-performance communication.
- Enable distributed tracing with OpenTelemetry.

## 💡 Contributing
Feel free to fork the repo and submit PRs. Contributions are welcome!


🚀 Happy Coding! 🎉

