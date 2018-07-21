library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.ALL;


entity RAM is
port(
 
 RAM_ADDR: in std_logic_vector(6 downto 0); 
 RAM_DATA_IN: in std_logic_vector(7 downto 0);
 RAM_WR: in std_logic; 
 --RAM_CLOCK: in std_logic; 
 CLK : in std_logic;
 RAM_DATA_OUT: out std_logic_vector(7 downto 0) 
);
end RAM;

architecture A_RAM of RAM is

type RAM_ARRAY is array (0 to 127 ) of std_logic_vector (7 downto 0);

signal RAM : RAM_ARRAY;

  
begin
process(CLK)
			begin
				if(rising_edge(CLK)) then
								if (RAM_WR='1') then
								RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
			               elsif (RAM_WR='0') then
								RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN;
								
			               end if;
			   end if;
end process;

end A_RAM;