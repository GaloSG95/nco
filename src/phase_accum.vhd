library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accum is
  generic(  fsw_width   :   positive := 8);  
  port (    clk     :   in  std_logic;
            rst     :   in  std_logic;
            fsw     :   in  std_logic_vector(fsw_width-1 downto 0);
            addr    :   out std_logic_vector(fsw_width-1 downto 0));
end phase_accum;

architecture phase_accum_arch of phase_accum is

signal add_temp : unsigned(fsw_width-1 downto 0):=(others => '0');

begin

frequency_control : process(clk)
begin
    if clk'event and clk = '1' then
        if rst = '1' then
            add_temp <= (others => '0');
        else
            add_temp <= add_temp + unsigned(fsw); -- don't check for overflow
        end if ;
    end if ;
end process frequency_control;

addr <= std_logic_vector(add_temp);
    
end phase_accum_arch; -- arch