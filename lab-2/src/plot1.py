import pandas as pd
import matplotlib.pyplot as plt

# Data
data = {
    "DRR Combinations": [
        "SLL_CL SLL_PK", "DLL_CL SLL_PK", "DYN_ARR_CL SLL_PK",
        "SLL_CL DLL_PK", "DLL_CL DLL_PK", "DYN_ARR_CL DLL_PK",
        "SLL_CL DYN_ARR_PK", "DLL_CL DYN_ARR_PK", "DYN_ARR_CL DYN_ARR_PK"
    ],
    "mem_accesses": [
        71866499, 71878478, 72365158, 72538713, 72550487, 73050190, 
        470919951, 470934985, 471667914
    ],
    "mem_footprint (KB)": [
        798.8, 823.0, 760.2, 980.3, 983.3, 928.5, 
        1111.0, 1128.0, 1075.0
    ]
}

# Convert to DataFrame
df = pd.DataFrame(data)

# Plotting
fig, ax1 = plt.subplots(figsize=(12, 6))

# Bar plot for mem_accesses
ax1.bar(df["DRR Combinations"], df["mem_accesses"], color='blue', alpha=0.6, label='Memory Accesses')
ax1.set_ylabel('Memory Accesses', color='blue')
ax1.set_xlabel('DRR Combinations')

# Set xticks and xticklabels
ax1.set_xticks(range(len(df["DRR Combinations"])))
ax1.set_xticklabels(df["DRR Combinations"], rotation=45, ha='right')
ax1.tick_params(axis='y', labelcolor='blue')

# Line plot for memory footprint on secondary y-axis
ax2 = ax1.twinx()
ax2.plot(df["DRR Combinations"], df["mem_footprint (KB)"], color='red', marker='o', label='Memory Footprint (KB)')
ax2.set_ylabel('Memory Footprint (KB)', color='red')
ax2.tick_params(axis='y', labelcolor='red')

# Adding title and legend
fig.suptitle('Memory Accesses and Footprint Across DRR Combinations')
ax1.legend(loc='upper left')
ax2.legend(loc='upper right')

plt.tight_layout()
plt.show()
