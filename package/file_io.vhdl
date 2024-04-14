library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

package file_io IS

    function load_word(LINE_NUMBER: positive; WL: positive; file_name: string) return std_logic_vector;
    
end package file_io;


package body file_io is

    function to_std_logic (char : character) return std_logic is
        variable result : std_logic;
        begin
            case char is
                when '0'    => result := '0';
                when '1'    => result := '1';
                when 'x'    => result := '0';
                when others => assert (false) report "no valid binary character read" severity failure;
            end case;
        return result;
    end to_std_logic;
      
    function load_word(LINE_NUMBER: positive; WL: positive; file_name: string) return std_logic_vector is
        file object_file : text open read_mode is file_name; 
        variable L       : line;
        variable memory  : std_logic_vector(WL-1 downto 0);
        variable char    : character;
        
        begin
            -- move down
            for CURRENT_LINE in 0 to LINE_NUMBER-1 loop 
                if not endfile(object_file) then
                    readline(object_file, L);
                end if;
            end loop;
        
            -- read horizontaly
            for idx in WL-1 downto 0 loop
                read(L, char);
                memory(idx) := to_std_logic(char);
            end loop;     
        return memory;
    end load_word;


end package body;