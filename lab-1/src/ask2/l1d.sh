#!/bin/bash

# Define the L1 Data Cache Sizes
L1D_SIZES=("2kB" "4kB" "8kB" "16kB" "32kB" "64kB")

# Define the path to the gem5 executable and the config file
GEM5_EXEC="build/X86/gem5.opt"
CONFIG_FILE="configs/learning_gem5/part1/two_level.py"
EXECUTABLE="/gem5/tables_UF/tables.exe"

# Define other cache sizes
L1I_SIZE="8kB"
L2_SIZE="128kB"

# Output CSV file
OUTPUT_CSV="l1d_simulation_results.csv"

# Create CSV file and write header
echo "L1D Size,NumCycles,OverallMissRate" > $OUTPUT_CSV

# Run simulations for each L1D size
for L1D_SIZE in "${L1D_SIZES[@]}"; do
    echo "Running simulation for L1D Size = $L1D_SIZE..."
    
    # Run the simulation
    $GEM5_EXEC $CONFIG_FILE $EXECUTABLE --l1i_size=$L1I_SIZE --l1d_size=$L1D_SIZE --l2_size=$L2_SIZE
    
    # Extract the numCycles value from stats.txt
    NUM_CYCLES=$(grep "system.cpu.numCycles" m5out/stats.txt | awk '{print $2}')
    
    # Extract the overall miss rate from stats.txt
    OVERALL_MISS_RATE=$(grep "system.cpu.dcache.overallMissRate::cpu.data" m5out/stats.txt | awk '{print $2}')
    
    # Append the results to the CSV file
    echo "$L1D_SIZE,$NUM_CYCLES,$OVERALL_MISS_RATE" >> $OUTPUT_CSV
    echo "L1D Size $L1D_SIZE: NumCycles = $NUM_CYCLES, OverallMissRate = $OVERALL_MISS_RATE"
done

echo "All simulations completed. Results saved in '$OUTPUT_CSV'."
