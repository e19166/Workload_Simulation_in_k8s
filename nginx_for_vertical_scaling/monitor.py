import time
import requests
from datetime import datetime

url = "http://localhost:8080"  
output_file = "latency_log.txt"

def monitor_latency():
    with open(output_file, "w") as f:
        while True:
            try:
                start = time.time()
                response = requests.get(url, timeout=5)
                latency = time.time() - start
                f.write(f"{datetime.now()}, {response.status_code}, {latency}\n")
                print(f"{datetime.now()} - Status: {response.status_code}, Latency: {latency}s")
            except requests.exceptions.RequestException as e:
                f.write(f"{datetime.now()}, ERROR, {str(e)}\n")
                print(f"{datetime.now()} - ERROR: {str(e)}")
            time.sleep(1)

if __name__ == "__main__":
    monitor_latency()
