# NTUA ECE Embedded Systems Design Course

This repository showcases the laboratory assignments, low-level software implementations, and hardware acceleration designs I completed during the Embedded Systems Design course at the National Technical University of Athens (NTUA). Through this coursework, I developed practical expertise across the embedded systems engineering stack, spanning algorithm-level memory and loop optimizations, gem5 microarchitectural cache simulation, dynamic data structure refinement, High-Level Synthesis (HLS) hardware acceleration on Xilinx Zynq-7000 FPGA SoCs, bare-metal ARM assembly, and Linux kernel cross-compilation with custom system call integration.

## Laboratory Exercises & Assignments

### Lab 1: Algorithmic Loop Optimization & Microarchitectural Cache Simulation
*Code transformation on Renesas Synergy S7G2 and multi-level cache exploration via gem5.*

* **Key Tasks:**
  * **Embedded Target Profiling:** Analyzed hardware characteristics of the Renesas S7G2 microcontroller (240 MHz Cortex-M4, Flash Cache, SRAM). Instrumenting the DWT Cycle Counter (`DWT->CYCCNT`), profiled the Parallel Hierarchical One-Dimensional Search (PHODS) video motion estimation algorithm.
  * **Algorithmic Transformations:** Implemented loop unrolling, pointer arithmetic, invariant code motion, and variable privatization, cutting execution latency from ~1.82 ms down to ~0.74 ms. Performed Design Space Exploration (DSE) across square and rectangular block geometries ($B_x \times B_y$) to identify the optimal configuration minimizing processor cycles.
  * **gem5 Microarchitectural Exploration:** Configured full system simulation of an x86 core evaluating array traversal operations (`tables.c`). Parametrized L1 Instruction, L1 Data, and L2 cache hierarchies alongside loop unrolling factors ($UF \in [2, 32]$), plotting cycle counts, cache miss trajectories, and Pareto frontiers.
* **Tech Stack:** C, Python, gem5 Simulator, Renesas e2 Studio, Matplotlib.

### Lab 2: Dynamic Data Type Refinement (DDTR)
*Memory footprint and memory access optimization in networked embedded applications.*

* **Key Tasks:**
  * **Methodology Application:** Applied Dynamic Data Type Refinement (DDTR) methodologies across two standard network workloads: Deficit Round Robin (DRR) packet scheduling (evaluated against Dartmouth CRAWDAD campus traces) and Dijkstra’s shortest-path routing algorithm.
  * **Data Structure Exploration:** Evaluated Singly-Linked Lists (SLL), Doubly-Linked Lists (DLL), and Dynamic Arrays (`DYN_ARR`) across client nodes and packet buffers to establish performance trade-offs.
  * **Profiling Diagnostics:** Utilized Valgrind suites (`Lackey` for memory read/write access profiling and `Massif` for heap memory footprint analysis) to isolate optimal structures striking a balance between memory footprint and access counts.
* **Tech Stack:** C, Valgrind (Lackey, Massif), GCC, Linux.

### Lab 3: High-Level Synthesis (HLS) for Movie Recommendation on Zynq-7000
*FPGA hardware acceleration of K-Nearest Neighbors (KNN) Euclidean distance calculations using Vivado HLS / SDSoC.*

* **Key Tasks:**
  * **Workload Characterization:** Profiled a collaborative filtering recommendation engine executing on the ARM Cortex-A9 Processing System (PS) over the MovieLens dataset. Identified the Euclidean distance kernel (`calcDistancesHW`) as the primary execution bottleneck.
  * **Hardware Pipeline Design:** Shifted critical compute loops into the Programmable Logic (PL) of the Digilent Zybo board. Introduced HLS optimization pragmas (`#pragma HLS pipeline`, loop unrolling, array partitioning, and BRAM interface mapping).
  * **Performance & Resource Analysis:** Measured FPGA resource consumption (LUTs, FFs, BRAMs, DSP slices) against software baseline cycles, achieving substantial hardware speedup.
* **Tech Stack:** C/C++, Vivado HLS, Xilinx SDSoC, Zynq-7000 SoC (ARM + FPGA).

### Lab 4: HLS Acceleration of GAN Inference for Image Reconstruction
*Hardware-software co-design accelerating Generative Adversarial Network forward propagation on MNIST digits.*

* **Key Tasks:**
  * **GAN Generator Acceleration:** Offloaded the compute-intensive `forward_propagation` matrix transformations of a GAN generator restoring occluded lower halves of handwritten MNIST digits to FPGA programmable logic.
  * **Design Space Exploration & Quantization:** Evaluated varying fixed-point and integer bit-width precisions ($8$-bit vs. alternate bit representations) to analyze the trade-off between resource utilization, cycle latency, and reconstructed output accuracy.
  * **Image Reconstruction Fidelity:** Quantified image generation fidelity across software and hardware pipelines by calculating Max Pixel Error and Peak Signal-to-Noise Ratio (PSNR) in Python.
* **Tech Stack:** C/C++, Vivado HLS, SDSoC, Python, Jupyter Notebook, Zynq-7000 (Zybo).

### Lab 5: Low-Level ARM Assembly & Inter-System Serial Communication
*Direct ARMv7 instruction set programming and terminal character stream transformations.*

* **Key Tasks:**
  * **ARM Assembly Routine (`ask1.s`):** Programmed an interactive string conversion routine from scratch in ARM assembly using Linux software interrupts (`swi 0`, `sys_read`, `sys_write`), implementing ASCII classification, case swapping, and custom numerical permutation rules.
  * **Host-Guest Serial I/O Interface:** Constructed a POSIX serial communication protocol connecting a Linux host system with an emulated QEMU ARM guest through virtual pseudoterminals (`/dev/pts/x` to `ttyAMA0`). Configured raw terminal attributes using `termios` (baud rate 9600, 8-N-1 canonical format) to transmit payload streams and parse character frequency distributions.
* **Tech Stack:** ARMv7 Assembly, C, QEMU, Linux `termios`, POSIX System Calls.

### Lab 6: Cross-Compilation Toolchains & Linux Kernel System Call Implementation
*Custom embedded Linux toolchain generation and kernel-space system call authoring.*

* **Key Tasks:**
  * **Toolchain Engineering:** Built and verified a custom cross-compilation toolchain for `arm-cortexa9_neon-linux-gnueabihf` targets using `crosstool-NG`, comparing operational output against Linaro pre-compiled toolchains.
  * **Kernel Customization & Syscall Addition:** Extended the Linux kernel source tree by registering a custom system call (`sys_greet`, syscall entry `386`). Updated system call dispatch tables (`syscall_32.tbl`), core prototypes (`syscalls.h`), and kernel Makefiles.
  * **Userspace Verification:** Recompiled and deployed the updated kernel on QEMU ARM, writing user-space test harnesses (`test.c`) to validate kernel-space invocation, errno handling, and message logging via `dmesg`.
* **Tech Stack:** C, Linux Kernel Internals, crosstool-NG, Linaro Toolchain, QEMU ARM.

## Technologies Used

* **Languages:** C, C++, ARMv7 Assembly, Python, Bash
* **Hardware & Platforms:** Renesas Synergy S7G2, Digilent Zybo (Xilinx Zynq-7000 SoC ARM Cortex-A9 / Artix-7 PL)
* **Simulation & Toolchains:** gem5 Simulator, QEMU, Vivado HLS, Xilinx SDSoC, crosstool-NG, Linaro
* **Profiling & Diagnostic Tools:** Valgrind (Lackey, Massif), DWT Cycle Counter, e2 Studio
* **Core Concepts:** Embedded System Design, HW/SW Co-Design, Loop Optimization, Memory Hierarchy & Cache Modeling, Dynamic Data Type Refinement, High-Level Synthesis (HLS), Fixed-Point Quantization, Serial I/O Protocols, Linux Kernel Development
