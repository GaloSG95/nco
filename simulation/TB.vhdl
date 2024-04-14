library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture arch of tb is

component nco_lo
    generic(    fsw_width   :   positive := 8;
                phs_width   :   positive := 8;
                dout_width   :   positive := 14);  
    port (      clk     :   in  std_logic;
                rst     :   in  std_logic;
                fsw     :   in  std_logic_vector(fsw_width-1 downto 0);
                phase   :   in  std_logic_vector(phs_width-1 downto 0);
                sin_lo  :   out std_logic_vector(dout_width-1 downto 0);
                cos_lo  :   out std_logic_vector(dout_width-1 downto 0));
end component nco_lo;

signal clk_reg      : std_logic := '0';
signal rst_reg      : std_logic := '0';
signal fsw_reg      : std_logic_vector(7 downto 0);
signal phase_reg    : std_logic_vector(7 downto 0);
signal dout_sin     : std_logic_vector(13 downto 0);
signal dout_cos     : std_logic_vector(13 downto 0);


constant period     : time := 10 ns;                                        -- Fclk = 1/period;
constant fsw_5MHZ   : std_logic_vector(7 downto 0):="00001101";             -- Fout = (Fclk * fsw)/(2^(fsw_width))  
constant fsw_3_9MHZ : std_logic_vector(7 downto 0):="00000001";             -- minumum step (slowest frequency)     
constant phase_0    : std_logic_vector(7 downto 0):=(others => '0');        -- 0 phase offset
constant phase_90   : std_logic_vector(7 downto 0):="01000000";             -- One period = 256 samples, thus pi/2 = (2^8/4)
constant zero       : std_logic_vector(13 downto 0):=(others => '0');

begin

nco_lo_inst: nco_lo
  generic map(  fsw_width   =>  8,
                phs_width   =>  8,
                dout_width  =>  14)
  port map(     clk         =>  clk_reg,
                rst         =>  rst_reg,
                fsw         =>  fsw_reg,
                phase       =>  phase_reg,
                sin_lo      =>  dout_sin,
                cos_lo      =>  dout_cos);

-- generate clock
system_clock: process
begin
    wait for period/2;
    clk_reg <= not clk_reg;
end process;

-- generate rst
system_rst: process
begin
    wait for period;
    rst_reg <= '1';
    wait for period;
    rst_reg <= '0';
    wait;
end process;
    
-- Generate output stimuli
verification: process
begin
    fsw_reg     <= fsw_5MHZ;
    phase_reg   <= phase_0;
    wait until falling_edge(rst_reg);

    for idx in 0 to 20*4 loop               -- 1 period 20 samples, repeat 4 times
        wait until rising_edge(clk_reg);
        assert(dout_cos = zero) report "not zero" severity warning;
        assert(dout_sin = zero) report "not zero" severity warning;
    end loop ; -- identifier

    phase_reg   <= phase_90;

    for idx in 0 to 20*4 loop               -- 1 period 20 samples, repeat 4 times
        wait until rising_edge(clk_reg);
        assert(dout_cos = zero) report "not zero" severity warning;
        assert(dout_sin = zero) report "not zero" severity warning;
    end loop ; -- identifier

    fsw_reg     <= fsw_3_9MHZ;
    phase_reg   <= phase_0;

    for idx in 0 to 256*4 loop              -- 1 period 256 samples, repeat 4 times
        wait until rising_edge(clk_reg);
        assert(dout_cos = zero) report "not zero" severity warning;
        assert(dout_sin = zero) report "not zero" severity warning;
    end loop ; -- identifier

    phase_reg   <= phase_90;
    for idx in 0 to 256*4 loop              -- 1 period 256 samples, repeat 4 times
        wait until rising_edge(clk_reg);
        assert(dout_cos = zero) report "not zero" severity warning;
        assert(dout_sin = zero) report "not zero" severity warning;
    end loop ; -- identifier

    report "Testbench finished!" severity failure;
end process verification;


end architecture arch;