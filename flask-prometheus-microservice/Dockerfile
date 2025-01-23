FROM python:3.9-slim

# Install Flask and Prometheus client
RUN pip install flask prometheus_client

# Copy the application code
COPY app.py /app/app.py

# Set the working directory
WORKDIR /app

# Expose the necessary ports
EXPOSE 5000
EXPOSE 8000

# Start the application
CMD ["python", "app.py"]
