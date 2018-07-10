library ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY ROM IS
PORT ( address : IN STD_LOGIC_VECTOR (3 downto 0);
		 data : OUT STD_LOGIC_VECTOR (13 downto 0)
	   );
END ENTITY;

ARCHITECTURE A_ROM OF ROM IS
BEGIN
	PROCESS (address)
		BEGIN
			CASE address IS
				WHEN "0000" => data <= "11100100001111"; --MOVLW R<=B
				WHEN "0001" => data <= "11110000001100"; --ADDLW 
				WHEN "0010" => data <= "11010111110000"; --IORLW
				WHEN "0011" => data <= "11011000000011"; --XORLW
				WHEN "0100" => data <= "11010011111111"; --ANDLW
				WHEN "0101" => data <= "11110001100100"; --ADDLW
				WHEN "0110" => data <= "11110100010100"; --SUBLW
				WHEN "0111" => data <= "11110001100100"; --ADDLW
				WHEN "1000" => data <= "11010100001100"; --IORLW
				WHEN "1001" => data <= "11010000000000"; --ANDLW
				WHEN "1010" => data <= "11100100010111"; --MOVLW
				WHEN others => data <= "11000000000000";
			END CASE;
	END PROCESS;
END ARCHITECTURE;
				
