#!/usr/bin/env python3

import pandas as pd
import subprocess
import time
import os

# Define parameter ranges
l1d_sizes = ["2kB", "4kB", "8kB", "16kB", "32kB", "64kB"]
l1i_sizes = ["2kB", "4kB", "8kB", "16kB", "32kB", "64kB"]
l2_sizes = ["128kB", "256kB", "512kB", "1024kB"]
unrolling_factors = [2, 4, 8, 16, 32]

# DataFrame to store results in the required format
df = pd.DataFrame(columns=[
    'L1I_cache_size', 'L1D_cache_size', 'L2_cache_size', 
    'unrolling_factor', 'exec_time_cc', 'total_mem_kB'
])

# Track time taken for exhaustive search
start_time = time.time()

# Iterate over all configurations
for l1d in l1d_sizes:
    for l1i in l1i_sizes:
        for l2 in l2_sizes:
            for uf in unrolling_factors:
                # Construct command
                command = [
                    "build/X86/gem5.opt",
                    "configs/learning_gem5/part1/two_level.py",
                    f"/gem5/tables_UF/tables_uf{uf}.exe",
                    f"--l1i_size={l1i}",
                    f"--l1d_size={l1d}",
                    f"--l2_size={l2}"
                ]

                # Print the configuration and command for clarity
                print(f"\nRunning configuration: L1D={l1d}, L1I={l1i}, L2={l2}, Unrolling Factor={uf}")
                print(f"Command: {' '.join(command)}")

                # Run gem5 command and capture output
                try:
                    result = subprocess.run(command, capture_output=True, text=True, check=True)
                    
                    # Print the output from the gem5 command
                    print("Command Output:")
                    print(result.stdout)  # Shows the stdout output from the gem5 command

                    # Path to the stats file
                    stats_file_path = "m5out/stats.txt"  # Adjust if necessary
                    
                    # Check if stats file exists
                    if not os.path.exists(stats_file_path):
                        print(f"Stats file not found for config L1D={l1d}, L1I={l1i}, L2={l2}, UF={uf}")
                        continue

                    # Read the cycle count from stats.txt
                    exec_time_cc = None
                    with open(stats_file_path, 'r') as stats_file:
                        for line in stats_file:
                            if "system.cpu.numCycles" in line:  # Updated keyword
                                exec_time_cc = int(line.split()[1])  # Parse the cycle count
                                print(f"Execution time (system.cpu.numCycles): {exec_time_cc}")
                                break

                    # Check if execution time was found; skip if not found
                    if exec_time_cc is None:
                        print(f"Execution time (system.cpu.numCycles) not found in stats for config L1D={l1d}, L1I={l1i}, L2={l2}, UF={uf}")
                        continue

                    # Calculate total memory in KB
                    total_mem_kb = int(l1d[:-2]) + int(l1i[:-2]) + int(l2[:-2])
                    print(f"Total memory for configuration: {total_mem_kb} KB")

                    # Append the result in the required format
                    temp = {
                        'L1I_cache_size': l1i,
                        'L1D_cache_size': l1d,
                        'L2_cache_size': l2,
                        'unrolling_factor': str(uf),
                        'exec_time_cc': str(exec_time_cc),
                        'total_mem_kB': str(total_mem_kb)
                    }
                    df.loc[len(df)] = temp

                except subprocess.CalledProcessError as e:
                    print(f"Error running command for config L1D={l1d}, L1I={l1i}, L2={l2}, UF={uf}")
                    print(e.output)

# Calculate and print execution time
execution_time = time.time() - start_time
print(f"\nTotal time for exhaustive search: {execution_time:.2f} seconds")

# Save results to CSV in the required format
df.to_csv("exhaustive_search_results_PO.csv", index=False)
print("\nResults saved to exhaustive_search_results_PO.csv")

