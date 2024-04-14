#!/bin/bash

# Specify path to source files
src=src

# Specify path to work library
work=work

# Specify path to simulation files
sim=simulation

# Specify path to package directory
package=package

# Compile specified source files into work library using VHDL 2002 standard
vcom -work $work -2002 -explicit -stats=all $package/file_io.vhdl $sim/TB.VHDL $src/nco.vhd $src/phase_accum.vhd $src/cosine_lut.vhd $src/sine_lut.vhd
# Optimization
vopt TB +acc=rn -o tb_opt
# Simulate testbench and invoke Modelsim GUI
vsim -gui -nolog -lib $work -do $sim/sim.do tb_opt

# Delete output WLF-file
rm -r vsim.wlf