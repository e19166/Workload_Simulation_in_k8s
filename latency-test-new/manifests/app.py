import time
import logging
from flask import Flask, request, g

# Create Flask app
app = Flask(__name__)

# Configure logging
logging.basicConfig(filename='log.txt', level=logging.INFO, 
                    format='%(asctime)s - %(message)s')

@app.before_request
def before_request():
    """Record the start time before processing the request"""
    g.start_time = time.time()

@app.after_request
def after_request(response):
    """Calculate the latency after the request is processed and log it"""
    latency = time.time() - g.start_time
    app.logger.info(f'Request ID: {request.remote_addr}, Latency: {latency:.6f} seconds')
    return response

@app.route('/')
def hello_world():
    """Route that returns a hello world message"""
    time.sleep(0.01)  # Introducing a slight delay for better latency measurement
    return 'Hello, World!'

if __name__ == "__main__":
    # Start the Flask application
    app.run(debug=True, host='0.0.0.0', port=8082)
