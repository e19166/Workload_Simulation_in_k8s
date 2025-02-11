
# Kubernetes Vertical Scaling Latency Measurement

This project aims to measure and analyze the impact of vertical scaling on latency in a Kubernetes environment. By deploying a simple Nginx application and using a Flask app to log request latencies, the project continuously scales the application’s CPU and memory resources and measures latency throughout the process.

## Overview

This project includes:

- **Kubernetes Deployment**: An Nginx application deployed with a NodePort service.
- **Flask App**: A Flask-based app that logs request latency and stores it in a log file.
- **PowerShell Script**: A script that automates the process of measuring latency before, during, and after the vertical scaling of the application’s resources.
- **CSV Log Output**: The latency data is stored in a CSV file for further analysis.

The goal of the project is to understand how reducing resource limits (CPU and memory) affects the latency of the application and to detect any potential resource throttling.

## Features

- **Vertical Scaling**: The CPU and memory limits are progressively reduced.
- **Latency Measurement**: Latency before, during, and after scaling is measured for each step.
- **Throttling Detection**: The system checks for CPU throttling after each resource adjustment.
- **CSV Output**: The latency data is saved to a CSV file, providing an easy way to analyze results over time.
- **Pod Health Check**: Ensures that the Kubernetes pods are healthy and running before and after scaling.

## Project Components

### 1. **Kubernetes Deployment**
The Nginx container is deployed using a Kubernetes `Deployment` and exposed via a `NodePort` service. This application will act as the target for latency measurements.

### 2. **Flask Application**
A simple Flask application is used to simulate user requests. It records the latency for each request and logs it to a file. The application runs on port `8082` in the container.

### 3. **PowerShell Script**
The PowerShell script performs the following actions:
- **Initial Latency Measurement**: It measures the latency before any scaling occurs.
- **Scaling Process**: It progressively reduces CPU and memory limits and measures latency after each scaling step.
- **CSV Logging**: The latency for each step is logged into a CSV file for easy tracking.
- **Health Check**: The script checks whether the pod is healthy and not in a `Pending` or `Terminating` state.

### 4. **Throttling Detection**
During the scaling process, the script checks if the CPU usage exceeds the specified limits. If throttling is detected, the script stops further testing.

## Prerequisites

- **Kubernetes Cluster**: A working Kubernetes cluster to deploy the application.
- **kubectl**: A Kubernetes CLI tool to interact with the cluster.
- **PowerShell**: For running the PowerShell script to manage latency testing and scaling.
- **Flask & Prometheus Client**: Required Python packages for the Flask app.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/k8s-latency-scaling.git
   cd k8s-latency-scaling
   ```

2. **Deploy the Application**:
   Apply the Kubernetes YAML configuration to deploy the app:
   ```bash
   kubectl apply -f manifests/app-deployment.yaml
   ```

3. **Install Flask**:
   Make sure Flask and other dependencies are installed:
   ```bash
   pip install flask prometheus_client
   ```

4. **Run the PowerShell Script**:
   Execute the PowerShell script to start the latency measurement process:
   ```powershell
   .\measure-latency.ps1
   ```

## How It Works

- The application starts with initial resource settings for CPU and memory.
- The PowerShell script measures the latency of the application before any scaling.
- CPU and memory limits are progressively decreased in steps.
- Latency is measured after each step and recorded.
- The script detects if the pod becomes throttled due to resource limits.
- The results are saved in a CSV file for analysis.

## Example CSV Output

| Action        | Latency (Seconds) |
|---------------|-------------------|
| Initial Latency | 0.050000          |
| Before Scaling  | 0.060000          |
| Step 1          | 0.070000          |
| Step 2          | 0.080000          |
| ...             | ...               |

## Conclusion

This project provides insights into the relationship between resource allocation and application latency in Kubernetes environments. The data collected can be used to optimize CPU and memory allocations for minimizing latency while maintaining performance.

## Future Work

- **Auto-scaling Integration**: Implementing auto-scaling based on latency thresholds.
- **Advanced Metrics**: Adding more detailed metrics like CPU and memory usage over time.
- **Visualization**: Create graphs and dashboards for better data visualization.

## Acknowledgments

- The Kubernetes community for creating and maintaining Kubernetes.
- The Flask and Prometheus teams for their fantastic libraries.

## Contact

For any questions or suggestions, feel free to reach out to:

- **Email**: e19166@eng.pdn.ac.lk
- **GitHub**: [@e19166](https://github.com/e19166)

