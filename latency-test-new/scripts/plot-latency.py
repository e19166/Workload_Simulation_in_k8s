import pandas as pd
import matplotlib.pyplot as plt

# Path to the CSV file
csv_file = "latency_data.csv"

# Read the CSV file into a pandas DataFrame
data = pd.read_csv(csv_file)

# Extract the latency values and their corresponding action numbers
data["Latency"] = pd.to_numeric(data["Latency"], errors='coerce')
degrade_data = data[data["Action"].str.contains("Degrade Step")]
#continuous_latency_data = data[data["Action"].str.contains("Continuous Latency")]
before_scaling_data = data[data["Action"].str.contains("Before Scaling")]

# Extract continuous latency numbers and values
#continuous_latency_data["Latency Number"] = continuous_latency_data["Action"].str.extract(r"(\d+)", expand=False)

# Fill NaN values with a default number (e.g., 0 or -1) if necessary
#continuous_latency_data["Latency Number"] = continuous_latency_data["Latency Number"].fillna(-1).astype(int)

#continuous_latency_data = continuous_latency_data.sort_values(by="Latency Number")

# Extract "Before Scaling" latency data
before_scaling_data["Latency Number"] = before_scaling_data["Action"].str.extract(r"(\d+)", expand=False)

# Fill NaN values with a default number (e.g., 0 or -1) if necessary
before_scaling_data["Latency Number"] = before_scaling_data["Latency Number"].fillna(-1).astype(int)

before_scaling_data = before_scaling_data.sort_values(by="Latency Number")

# Plot the continuous latency
plt.figure(figsize=(12, 6))

# Plot "Before Scaling" latency
plt.plot(
    before_scaling_data["Latency Number"],
    before_scaling_data["Latency"],
    marker='s',
    color='green',
    linestyle='-.',
    linewidth=2,
    label="Before Scaling Latency"
)

# Plot continuous latency
""" plt.plot(
    continuous_latency_data["Latency Number"],
    continuous_latency_data["Latency"],
    marker='o',
    color='blue',
    linestyle='-',
    linewidth=2,
    label="Continuous Latency"
)
 """
# Plot degrade steps
degrade_data["Step Number"] = degrade_data["Action"].str.extract(r"(\d+)", expand=False).astype(int)
degrade_data = degrade_data.sort_values(by="Step Number")

plt.plot(
    degrade_data["Step Number"],
    degrade_data["Latency"],
    marker='x',
    color='red',
    linestyle='--',
    linewidth=2,
    label="Degrade Steps Latency"
)

# Add labels, title, and legend
plt.xlabel("Action Step", fontsize=12)
plt.ylabel("Latency (seconds)", fontsize=12)
plt.title("Latency Variations Before and After Memory Limit Decrement", fontsize=14)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(fontsize=10)
plt.xticks(fontsize=10)
plt.yticks(fontsize=10)

# Display the plot
plt.tight_layout()
plt.show()
