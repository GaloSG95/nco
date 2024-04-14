#!/bin/bash

# Specify path to source files
src=src

# Specify path to work library
work=work

# Specify path to testbench
sim=simulation

# Specify path to package directory
package=package


# Compile specified files into work library using VHDL 2002 standard
vcom -work $work -2002 -explicit -stats=all $package/file_io.vhdl $sim/TB.VHDL $src/nco.vhd $src/phase_accum.vhd $src/cosine_lut.vhd $src/sine_lut.vhd
