FROM python:3.9-slim

# Install necessary packages
RUN pip install flask prometheus_client

# Copy the Flask app code
COPY app.py /app.py

# Expose the app on port 8080
EXPOSE 8080

# Run the app
CMD ["python", "/app.py"]
