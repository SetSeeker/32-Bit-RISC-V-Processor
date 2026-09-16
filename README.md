# 32-Bit RISC-V Processor

A custom 32-bit RISC-V processor designed in Verilog and optimized for FPGA deployment. This project encompasses the complete core architecture, including data path modeling, control unit logic, and timing optimizations necessary for executing the RISC-V instruction set.

## Repository Structure
* **`src/`**: Synthesizable core hardware modules (ALU, PC, MAR, buses, etc.).
* **`tb/`**: Testbenches and GTKWave configuration files (`.gtkw`) for verification.
* **`mem/`**: Memory initialization files (`.hex`) containing machine code instructions.
* **`quartus/`**: Intel Quartus Prime project files for FPGA synthesis and routing.

## macOS Native Simulation Environment
Standard FPGA toolchains are often restricted to Windows or Linux. To bypass these OS restrictions for course tutorials, this project features a custom macOS simulation setup utilizing **Icarus Verilog (iverilog)** and **GTKWave**. 

The environment is automated via a custom VS Code `tasks.json` execution pipeline, allowing the Verilog testbenches to compile, simulate, and render waveforms natively on macOS without requiring a virtual machine.

## Toolchain & Technologies
* **Hardware Description Language**: Verilog
* **Simulation & Verification**: Icarus Verilog (`vvp`), GTKWave
* **Synthesis & Routing**: Intel Quartus Prime
