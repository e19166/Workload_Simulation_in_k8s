import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.ndimage import gaussian_filter1d

# Load the data
file_path = "D:/Research/MiccroServices/java-order-service/java-order-service/k8s-resource-test/results/latency_data_7.csv"
df = pd.read_csv(file_path, names=["Timestamp", "Latency"], parse_dates=["Timestamp"])

# Sort data by timestamp (if not already sorted)
df = df.sort_values(by="Timestamp")

# Apply Gaussian smoothing for a smooth trend line
smooth_latency = gaussian_filter1d(df["Latency"], sigma=5)  # Adjust sigma for smoothness

# Plot the original latency data
plt.figure(figsize=(20, 10))
plt.plot(df["Timestamp"], df["Latency"], marker="o", linestyle="-", color="b", label="Raw Latency (ms)", alpha=0.5)

# Plot the smoothed curve
plt.plot(df["Timestamp"], smooth_latency, linestyle="-", color="r", linewidth=2, label="Smoothed Trend")

# Formatting
plt.xlabel("Time")
plt.ylabel("Latency (ms)")
plt.title("Latency vs Time with Trend Line(Resource update applied: CPU 0.125 and 0.25, Memory 128Mi and 0.25Gi)")
plt.xticks(rotation=45)
plt.legend()
plt.grid(True)

# Show the graph
plt.show()
