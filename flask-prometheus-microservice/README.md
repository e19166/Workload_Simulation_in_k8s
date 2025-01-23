from flask import Flask
from prometheus_client import Counter, start_http_server
import time

app = Flask(__name__)

# Create a metric to track requests
REQUESTS = Counter('http_requests_total', 'Total number of HTTP requests')

@app.route('/')
def hello():
    REQUESTS.inc()  # Increment the request counter
    return "Hello, World!"

if __name__ == "__main__":
    # Start Prometheus metrics server on port 8000
    start_http_server(8000)
    app.run(host="0.0.0.0", port=5000)
