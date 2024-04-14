library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

library work;
use work.file_io.all;

entity sine_lut is
  generic(  addr_width  :   positive := 8;
            dout_width   :   positive := 14);
  port (    addr    :   in  std_logic_vector(addr_width-1 downto 0);
            dout    :   out std_logic_vector(dout_width-1 downto 0)) ;
end sine_lut;

architecture sine_lut_arch of sine_lut is

constant file_name  : string    := "src/storage/sine_lut.txt";
constant lut_depth  : positive  := 256;

type word_array is array (0 to lut_depth-1) of std_logic_vector(dout_width-1 downto 0);
signal sine_lut   : word_array;


-- Load whole lut
function load_array (file_name: string) return word_array is
    variable memory  : word_array;        
begin
    for line_number in 1 to lut_depth loop
        memory(line_number-1) := load_word(line_number,dout_width,file_name);
    end loop;
    return memory;
end load_array;

begin

sine_lut <= load_array(file_name);

dout <= sine_lut(to_integer(unsigned(addr)));

end sine_lut_arch ; -- arch