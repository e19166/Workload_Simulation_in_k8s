import os
import time
import subprocess
from datetime import datetime

deployment_name = "test-app"
namespace = "default"
new_cpu = "650m"
new_memory = "720Mi"
local_port = 31413
service_name = "test-app-service"
service_port = 80

def scale_resources():
    print("Scaling resources...")
    os.system(f"kubectl set resources deployment {deployment_name} -n {namespace} "
              f"--limits=cpu={new_cpu},memory={new_memory} "
              f"--requests=cpu=500m,memory=512Mi")
    print(f"{datetime.now()}")
    time.sleep(10)  # Allow time for scaling
    print("Resources scaled.")

def restart_pod():
    print("Restarting the pod...")
    os.system(f"kubectl rollout restart deployment {deployment_name} -n {namespace}")
    print("Waiting for the pod to restart...")

def wait_for_pod_restart():
    print("Checking pod status...")
    # Wait until the pod is running and ready
    os.system(f"kubectl wait --for=condition=available --timeout=60s deployment/{deployment_name} -n {namespace}")
    print("Pod has restarted and is available.")

def port_forward():
    print(f"Starting port-forwarding for {service_name}...")
    try:
        subprocess.run(
            ["kubectl", "port-forward", f"svc/{service_name}", f"{local_port}:{service_port}", "-n", namespace],
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error during port-forwarding: {e}")
    except KeyboardInterrupt:
        print("Port-forwarding terminated.")

if __name__ == "__main__":
    scale_resources()
    restart_pod()
    wait_for_pod_restart()
    port_forward()
