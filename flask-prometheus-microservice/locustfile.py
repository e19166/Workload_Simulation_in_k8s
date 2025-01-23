from locust import HttpUser, task, between

class FlaskAppUser(HttpUser):
    # Wait between 1 and 3 seconds between tasks
    wait_time = between(1, 3)
    
    @task(2)  # Weight of 2 means this task runs twice as often
    def visit_root(self):
        # Record custom metrics in the response
        with self.client.get("/") as response:
            if response.status_code == 200:
                # You can add custom metrics for Prometheus here
                pass
    
    @task(1)
    def visit_metrics(self):
        with self.client.get("/metrics") as response:
            if response.status_code == 200:
                pass