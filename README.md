# 8-bit-Synchronous-FIFO-Verilog
# Design and Verification of an 8-bit Synchronous FIFO

## Project Overview
Designed and verified a 16-entry, 8-bit synchronous FIFO using Verilog HDL and Xilinx Vivado 2024.2.

The FIFO operates using a single clock and supports sequential data storage and retrieval based on the First-In, First-Out principle.

## Features
- 8-bit data width and 16-entry storage depth
- Synchronous read and write operations
- Independent read and write pointers
- Full and empty flag generation
- Overflow and underflow protection
- Simultaneous read and write support
- Synchronous reset

## Tools Used
- **HDL:** Verilog
- **Simulation Tool:** Xilinx Vivado 2024.2
- **Verification:** Self-checking Verilog testbench

## Functional Verification
The following test scenarios were successfully verified through behavioral simulation:

1. Reset functionality
2. FIFO write and read operations
3. Full flag generation
4. Overflow protection
5. FIFO data ordering
6. Empty flag generation
7. Underflow protection
8. Simultaneous read and write operations

**Simulation Result: ALL FIFO TESTS PASSED**

## Conclusion
Successfully designed and functionally verified an 8-bit synchronous FIFO with 16 storage locations. Behavioral simulation confirmed correct FIFO ordering, status flag generation, and protection against invalid read/write operations under the tested conditions.
