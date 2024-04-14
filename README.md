# Numerically Controlled Oscillator


*NCO* module implemented in VHDL. Environment tailored for functional verification with QuestaSim through the command line.

    .
    ├── src                     # Source files
    │   ├──  storage
    │   │   ├── cosine_lut.txt  # binary data for cosine lut
    │   │   ├── sine_lut.txt    # binary data for sine lut
    │   ├──  cosine_lut.vhd     # cosine look-up table
    │   ├──  sine_lut.vhd       # sine look-up table
    │   ├──  phase_accum.vhd    # NCO's phase accumulator
    │   ├──  nco.vhd            # Numerically Controlled Oscillator (Top module)
    ├── simulation
    │   ├── TB.vhdl             # Testbench
    │   ├── sim.do              # QuestaSim TCL
    ├── scripts
    │   ├── compilation.sh      # Compile source files, in herarchical order
    │   ├── sim_questa.sh       # Simulation in GUI mode
    ├── package
    │   ├── file_io.vhdl        # VHDL packge used to read text file
    └── README.md               # README file

## Simulation

The simulation script compiles and calls QuestaSim in GUI mode. The Test bench demostrate frequency, and phase control of the DUT.

```bash
source script/sim_questa.sh
```
