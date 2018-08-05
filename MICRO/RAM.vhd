library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_unsigned.all;

ENTITY RAM IS
  PORT (
			WE, CLK : IN  STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR (6 downto 0);
			datain : IN STD_LOGIC_VECTOR (7 downto 0);
			dataout : OUT STD_LOGIC_VECTOR (7 downto 0));
		  
END ENTITY;

ARCHITECTURE M_RAM OF RAM IS

	TYPE RAM_ARRAY IS ARRAY (128 downto 0) OF STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL RAM : RAM_ARRAY;
	
BEGIN
PROCESS (CLK)

	BEGIN 
		IF (rising_edge(CLK)) THEN
			IF (WE = '1') THEN
				dataout <= ram (conv_integer(addr));
			ELSIF (WE = '0') THEN
				RAM(conv_integer(addr)) <= datain;
			END IF;
	
		END IF;
END PROCESS;	
END ARCHITECTURE;
