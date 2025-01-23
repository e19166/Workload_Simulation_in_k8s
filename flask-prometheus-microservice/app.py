from flask import Flask, request
from prometheus_client import Counter, Gauge, generate_latest, REGISTRY, Histogram
import psutil
import time
from threading import Thread

app = Flask(__name__)

# Define metrics with proper registration
REQUESTS = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint'],
    registry=REGISTRY
)

cpu_usage_gauge = Gauge(
    'app_cpu_usage_percent',
    'CPU usage percentage of the application',
    registry=REGISTRY
)

memory_usage_gauge = Gauge(
    'app_memory_usage_bytes',
    'Memory usage of the application in bytes',
    registry=REGISTRY
)

request_latency = Histogram(
    'http_request_latency_seconds',
    'Latency of HTTP requests',
    ['method', 'endpoint'],
    registry=REGISTRY
)

def update_metrics():
    while True:
        try:
            cpu_usage = psutil.cpu_percent()
            memory_usage = psutil.virtual_memory().used
            
            # Update gauges with new values
            cpu_usage_gauge.set(cpu_usage)
            memory_usage_gauge.set(memory_usage)
            
            print(f"Updated metrics - CPU: {cpu_usage}% | Memory: {memory_usage} bytes")
            time.sleep(5)
        except Exception as e:
            print(f"Error updating metrics: {e}")
            time.sleep(5)

@app.before_request
def start_timer():
    request.start_time = time.time()
    try:
        REQUESTS.labels(request.method, request.path).inc()
    except Exception as e:
        print(f"Error incrementing request counter: {e}")

@app.after_request
def record_latency(response):
    try:
        elapsed_time = time.time() - request.start_time
        request_latency.labels(request.method, request.path).observe(elapsed_time)
    except Exception as e:
        print(f"Error recording latency: {e}")
    return response

@app.route("/")
def hello():
    return "Hello, World!"

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain'}

if __name__ == "__main__":
    # Start the metrics update thread before running the app
    metrics_thread = Thread(target=update_metrics, daemon=True)
    metrics_thread.start()
    
    # Run the Flask app with metrics endpoint
    app.run(host="0.0.0.0", port=5000)