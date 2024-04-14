library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco_lo is
  generic(  fsw_width   :   positive := 8;
            phs_width   :   positive := 8;
            dout_width  :   positive := 14);  
  port (    clk     :   in  std_logic;
            rst     :   in  std_logic;
            fsw     :   in  std_logic_vector(fsw_width-1 downto 0);
            phase   :   in  std_logic_vector(phs_width-1 downto 0);
            sin_lo  :   out std_logic_vector(dout_width-1 downto 0);
            cos_lo  :   out std_logic_vector(dout_width-1 downto 0));
end nco_lo;

architecture nco_arch of nco_lo is

component phase_accum
generic(  fsw_width   :   positive := 8);  
port (    clk     :   in  std_logic;
          rst     :   in  std_logic;
          fsw     :   in  std_logic_vector(fsw_width-1 downto 0);
          addr    :   out std_logic_vector(fsw_width-1 downto 0));
end component phase_accum;

component cosine_lut
generic(    addr_width  :   positive := 8;
            dout_width  :   positive := 14);
port (      addr    :   in  std_logic_vector(addr_width-1 downto 0);
            dout    :   out std_logic_vector(dout_width-1 downto 0));
end component cosine_lut;

component sine_lut
generic(    addr_width  :   positive := 8;
            dout_width  :   positive := 14);
port (      addr    :   in  std_logic_vector(addr_width-1 downto 0);
            dout    :   out std_logic_vector(dout_width-1 downto 0));
end component sine_lut;

signal phase_temp   : unsigned(fsw_width-1 downto 0);
signal addr_reg     : std_logic_vector(7 downto 0);

begin

reset_proc: process(clk)
begin
  if rising_edge(clk) then
    if (rst = '1') then
      phase_temp <= (others => '0');
    else
      phase_temp <= unsigned(addr_reg) + unsigned(phase);
    end if;
  end if;
end process reset_proc;  

phase_accum_inst: phase_accum
  generic map(  fsw_width   => fsw_width)
  port map(     clk         =>  clk,
                rst         =>  rst,
                fsw         =>  fsw,
                addr        =>  addr_reg);  

cosine_lut_inst: cosine_lut
  generic map(  addr_width  =>  fsw_width,  
                dout_width  =>  dout_width)
  port map(     addr        =>  std_logic_vector(phase_temp),
                dout        =>  cos_lo);

sine_lut_inst: sine_lut
  generic map(  addr_width  =>  fsw_width,  
                dout_width  =>  dout_width)
  port map(     addr        =>  std_logic_vector(phase_temp),
                dout        =>  sin_lo);

end nco_arch ; -- arch
