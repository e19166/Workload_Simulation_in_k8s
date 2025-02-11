# app.py
from flask import Flask
import time
import os

app = Flask(__name__)

@app.route('/cpu')
def cpu_intensive_task():
    start_time = time.time()
    for _ in range(1000):  # Simulate CPU load
        _ = 2**10  
    return f"Task completed in {time.time() - start_time} seconds"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
