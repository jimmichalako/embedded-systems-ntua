import pandas as pd
import matplotlib.pyplot as plt

# Data
data = {
    "Dijkstra Implementations": [
        "SLL", "DLL", "DYN_ARR"
    ],
    "mem_accesses": [
        102254663, 102433847, 149469215
    ],
    "mem_footprint (KB)": [
        356.4, 471.2, 360.6
    ]
}

# Convert to DataFrame
df = pd.DataFrame(data)

# Plotting
fig, ax1 = plt.subplots(figsize=(12, 6))

# Bar plot for mem_accesses
ax1.bar(df["Dijkstra Implementations"], df["mem_accesses"], color='blue', alpha=0.6, label='Memory Accesses')
ax1.set_ylabel('Memory Accesses', color='blue')
ax1.set_xlabel('Dijkstra Implementations')

# Set xticks and xticklabels
ax1.set_xticks(range(len(df["Dijkstra Implementations"])))
ax1.set_xticklabels(df["Dijkstra Implementations"], rotation=45, ha='right')
ax1.tick_params(axis='y', labelcolor='blue')

# Line plot for memory footprint on secondary y-axis
ax2 = ax1.twinx()
ax2.plot(df["Dijkstra Implementations"], df["mem_footprint (KB)"], color='red', marker='o', label='Memory Footprint (KB)')
ax2.set_ylabel('Memory Footprint (KB)', color='red')
ax2.tick_params(axis='y', labelcolor='red')

# Adding title and legend
fig.suptitle('Memory Accesses and Footprint Across Dijkstra Implementations')
ax1.legend(loc='upper left')
ax2.legend(loc='upper right')

plt.tight_layout()
plt.show()