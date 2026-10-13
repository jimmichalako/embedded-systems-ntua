#!/bin/bash

# Define the unrolling factors
UNROLLING_FACTORS=(2 4 8 16 32)

# Define the path to the gem5 executable and the config file
GEM5_EXEC="build/X86/gem5.opt"
CONFIG_FILE="configs/learning_gem5/part1/two_level.py"
BASE_EXECUTABLE="/gem5/tables_UF/tables_uf"

# Define cache sizes
L1I_SIZE="8kB"
L1D_SIZE="8kB"
L2_SIZE="128kB"

# Output CSV file
OUTPUT_CSV="simulation_results.csv"

# Create CSV file and write header
echo "Unrolling Factor,NumCycles" > $OUTPUT_CSV

# Run simulations for each unrolling factor
for UF in "${UNROLLING_FACTORS[@]}"; do
    echo "Running simulation for Unrolling Factor = $UF..."
    
    # Construct the executable path
    EXECUTABLE="${BASE_EXECUTABLE}${UF}.exe"
    
    # Run the simulation
    $GEM5_EXEC $CONFIG_FILE $EXECUTABLE --l1i_size=$L1I_SIZE --l1d_size=$L1D_SIZE --l2_size=$L2_SIZE
    
    # Extract the numCycles value from stats.txt
    NUM_CYCLES=$(grep "system.cpu.numCycles" m5out/stats.txt | awk '{print $2}')
    
    # Append the result to the CSV file
    echo "$UF,$NUM_CYCLES" >> $OUTPUT_CSV
    echo "Unrolling Factor $UF: NumCycles = $NUM_CYCLES"
done

echo "All simulations completed. Results saved in '$OUTPUT_CSV'."
