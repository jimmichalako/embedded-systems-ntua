import pandas as pd
from paretoset import paretoset

# Load data from CSV
df = pd.read_csv("exhaustive_search_results_PO.csv")

# Ensure column names are as expected for consistency
df.columns = ["L1I_cache_size", "L1D_cache_size", "L2_cache_size", "unrolling_factor", "exec_time_cc", "total_mem_kB"]

# Find Pareto optimal solutions (minimizing both exec_time_cc and total_mem_kB)
is_pareto = paretoset(df[["exec_time_cc", "total_mem_kB"]], sense=["min", "min"])

# Filter the Pareto optimal solutions
pareto_optimal_solutions = df[is_pareto]

# Print the Pareto optimal solutions
print("Pareto Optimal Solutions:")
print(pareto_optimal_solutions)
