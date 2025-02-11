# Java Order Service with Spring Boot and Kubernetes

This project is a simple Spring Boot-based RESTful order service that supports creating, retrieving, and listing orders. It is containerized using Docker and deployed on Kubernetes, with Prometheus monitoring enabled to scrape metrics from the service.

## Project Overview

The Java Order Service provides endpoints to:

- **Create an order**: POST a new order with customer details and amount.
- **Retrieve an order**: Get details of a specific order by its ID.
- **List all orders**: Get a list of all orders in the system.

This service is fully containerized and deployed on Kubernetes with resource management and Prometheus monitoring.

## Technologies Used

- **Spring Boot**: For building the backend REST API.
- **JPA (Java Persistence API)**: For interacting with the database and managing order entities.
- **Docker**: To containerize the Java application for deployment.
- **Kubernetes**: For orchestration and scaling of the service.
- **Prometheus**: For scraping metrics from the service.

## Endpoints

### 1. Create Order

- **URL**: `/orders`
- **Method**: `POST`
- **Request Body**: 
    ```json
    {
        "customerName": "John Doe",
        "amount": 100.50
    }
    ```
- **Response**: 
    ```json
    {
        "id": 1,
        "customerName": "John Doe",
        "amount": 100.50
    }
    ```

### 2. Get Order by ID

- **URL**: `/orders/{id}`
- **Method**: `GET`
- **Response**:
    ```json
    {
        "id": 1,
        "customerName": "John Doe",
        "amount": 100.50
    }
    ```

### 3. List All Orders

- **URL**: `/orders`
- **Method**: `GET`
- **Response**:
    ```json
    [
        {
            "id": 1,
            "customerName": "John Doe",
            "amount": 100.50
        },
        {
            "id": 2,
            "customerName": "Jane Smith",
            "amount": 200.75
        }
    ]
    ```

## Project Structure

```
java-order-service/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── java_order_service/
│   │   │               ├── controller/
│   │   │               │   └── OrderController.java
│   │   │               ├── entity/
│   │   │               │   └── Order.java
│   │   │               ├── exception/
│   │   │               │   └── GlobalExceptionHandler.java
│   │   │               ├── repository/
│   │   │               │   └── OrderRepository.java
│   │   │               └── JavaOrderServiceApplication.java
├── Dockerfile
├── deployment.yaml
└── service.yaml
```

## Docker Setup

The project uses Docker to package the Spring Boot application into a container. 

### Dockerfile

```dockerfile
FROM openjdk:17-jdk-slim
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### Build Docker Image

To build and run the Docker image, follow these steps:

1. Build the JAR file from your Spring Boot project:
   ```bash
   ./mvnw clean package
   ```

2. Build the Docker image:
   ```bash
   docker build -t dockerhub-username/order-service:1.0 .
   ```

3. Run the Docker container:
   ```bash
   docker run -p 8081:8081 dockerhub-username/order-service:1.0
   ```

The application will be accessible on `http://localhost:8081`.

## Kubernetes Deployment

The application is deployed on Kubernetes with resource management and Prometheus monitoring enabled.

### Kubernetes Deployment Configuration

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8083"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: order-service
  template:
    metadata:
      labels:
        app: order-service
    spec:
      containers:
      - name: order-service
        image: wishula/order-service:1.0
        ports:
        - containerPort: 8081
        resources:
          requests:
            memory: "256Mi"
            cpu: "256m"
          limits:
            memory: "512Mi"
            cpu: "400m"
```

### Kubernetes Service Configuration

```yaml
apiVersion: v1
kind: Service
metadata:
  name: order-service
spec:
  type: NodePort
  selector:
    app: order-service
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 8081
    nodePort: 30009
```

### Deploy to Kubernetes

1. Apply the deployment configuration:
   ```bash
   kubectl apply -f deployment.yaml
   ```

2. Apply the service configuration:
   ```bash
   kubectl apply -f service.yaml
   ```

Your service will be available via the NodePort `30009` on your Kubernetes cluster.

## Prometheus Monitoring

Prometheus is configured to scrape metrics from the order service:

```yaml
prometheus.io/scrape: "true"
prometheus.io/port: "8083"
```

This allows Prometheus to collect metrics about the service, such as request counts, response times, and resource usage.

## Error Handling

Global exceptions are managed by the `GlobalExceptionHandler.java` class to ensure proper error messages are returned to the user when issues occur during request processing.

## Future Improvements

- **Error Handling Enhancements**: Add more specific exception handling and user-friendly error messages.
- **Horizontal Pod Autoscaling**: Configure Kubernetes Horizontal Pod Autoscaler (HPA) to scale the service based on CPU and memory usage.
- **Database Integration**: Integrate a database (e.g., MySQL or PostgreSQL) to persist order data.
- **Prometheus Dashboards**: Create Grafana dashboards to visualize Prometheus metrics.

## Contact

For any questions or suggestions, feel free to reach out:

- **Email**: e19166@eng.pdn.ac.lk
- **GitHub**: [@e19166](https://github.com/e19166)