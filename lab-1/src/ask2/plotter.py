import pandas as pd
import matplotlib.pyplot as plt
from paretoset import paretoset

# Function to plot line plot for Unrolling Factor vs. NumCycles
def plot_unrolling_factor_cycles():
    df = pd.read_csv('simulation_results.csv')
    plt.figure(figsize=(10, 6))
    plt.plot(df['Unrolling Factor'], df['NumCycles'], marker='o', color='green', linestyle='-')
    plt.xlabel('Unrolling Factor')
    plt.ylabel('Total Number of Cycles')
    plt.title('Unrolling Factor vs. Total Number of Cycles')
    plt.grid(True)
    plt.savefig("unrolling_factor_vs_cycles.png", format="png")
    plt.show()

# Function to plot line plot for L1D Cache Size vs. NumCycles
def plot_l1d_cache_size_cycles():
    df = pd.read_csv('l1d_simulation_results.csv')
    plt.figure(figsize=(10, 6))
    plt.plot(df['L1D Size'], df['NumCycles'], marker='o', color='green', linestyle='-')
    plt.xlabel('L1D Cache Size')
    plt.ylabel('Total Number of Cycles')
    plt.title('L1D Cache Size vs. Total Number of Cycles')
    plt.grid(True)
    plt.savefig("l1d_cache_size_vs_cycles.png", format="png")
    plt.show()

# Function to plot line plot for L1D Cache Size vs. Miss Rate
def plot_l1d_cache_size_miss_rate():
    df = pd.read_csv('l1d_simulation_results.csv')
    plt.figure(figsize=(10, 6))
    plt.plot(df['L1D Size'], df['OverallMissRate'], marker='o', color='green', linestyle='-')
    plt.xlabel('L1D Cache Size')
    plt.ylabel('Overall Miss Rate')
    plt.title('L1D Cache Size vs. Overall Miss Rate')
    plt.grid(True)
    plt.savefig("l1d_cache_size_vs_miss_rate.png", format="png")
    plt.show()

# Function to plot Pareto frontier for Exhaustive Search Results
def plot_pareto_exhaustive_search():
    df = pd.read_csv('exhaustive_search_results_PO.csv')
    df['total_cache_memory_kB'] = (
        df['L1I_cache_size'].str.replace('kB', '').astype(int) +
        df['L1D_cache_size'].str.replace('kB', '').astype(int) +
        df['L2_cache_size'].str.replace('kB', '').astype(int)
    )
    
    # Pareto set
    pareto_mask = paretoset(df[['exec_time_cc', 'total_cache_memory_kB']], sense=['min', 'min'])
    pareto_front = df[pareto_mask]
    
    plt.figure(figsize=(10, 6))
    plt.scatter(df['total_cache_memory_kB'], df['exec_time_cc'], color='lightgray', label='All Points')
    plt.scatter(pareto_front['total_cache_memory_kB'], pareto_front['exec_time_cc'], color='green', label='Pareto Frontier')
    plt.xlabel('Total Cache Memory (kB)')
    plt.ylabel('Total Cycles')
    plt.title('Pareto Frontier: Total Cache Memory vs. Total Cycles (Exhaustive Search)')
    plt.legend()
    plt.grid(True)
    plt.savefig("pareto_frontier_exhaustive_search.png", format="png")
    plt.show()

# Function to plot Pareto frontier for GenOptimizer Results
def plot_pareto_genoptimizer():
    df = pd.read_csv('genOptimizer_PO.csv')
    df['total_cache_memory_kB'] = (
        df['L1I_cache_size'].str.replace('kB', '').astype(int) +
        df['L1D_cache_size'].str.replace('kB', '').astype(int) +
        df['L2_cache_size'].str.replace('kB', '').astype(int)
    )
    
    # Pareto set
    pareto_mask = paretoset(df[['exec_time_cc', 'total_cache_memory_kB']], sense=['min', 'min'])
    pareto_front = df[pareto_mask]
    
    plt.figure(figsize=(10, 6))
    plt.scatter(df['total_cache_memory_kB'], df['exec_time_cc'], color='lightgray', label='All Points')
    plt.scatter(pareto_front['total_cache_memory_kB'], pareto_front['exec_time_cc'], color='green', label='Pareto Frontier')
    plt.xlabel('Total Cache Memory (kB)')
    plt.ylabel('Total Cycles')
    plt.title('Pareto Frontier: Total Cache Memory vs. Total Cycles (GenOptimizer)')
    plt.legend()
    plt.grid(True)
    plt.savefig("pareto_frontier_genoptimizer.png", format="png")
    plt.show()

# Main function to run all plots
def main():
    plot_unrolling_factor_cycles()
    plot_l1d_cache_size_cycles()
    plot_l1d_cache_size_miss_rate()
    plot_pareto_exhaustive_search()
    plot_pareto_genoptimizer()

if __name__ == '__main__':
    main()
