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
			   WHEN "0000" => data <= "11100100010100"; --MOVLW
				WHEN "0001" => data <= "00100010000101"; --MOVWF
				WHEN "0010" => data <= "11100100000000"; --MOVLW
				WHEN "0011" => data <= "00100100000101"; --MOVWF
				
				
				
				
				
				
--				WHEN "0000" => data <= "11100100010100"; --MOVLW
--				WHEN "0001" => data <= "00100010000101"; --MOVWF
--				WHEN "0010" => data <= "11100100001111"; --MOVLW
--				WHEN "0011" => data <= "00100010000110"; --MOVWF
--				WHEN "0100" => data <= "11110000001010"; --ADDLW
--				WHEN "0101" => data <= "00100010000111"; --MOVWF
--				WHEN "0110" => data <= "11110000010100"; --ADDLW
--				WHEN "0111" => data <= "00100010001000"; --MOVWF
--				WHEN "1000" => data <= "00100100000111"; --MOVF
--				WHEN "1001" => data <= "00110000000111"; --ADDWF
--				WHEN "1010" => data <= "00100100000111"; --MOVF
--				WHEN "1011" => data <= "00110010000110"; --ADDWF
--				WHEN "1100" => data <= "00100100000110"; --MOVF
				WHEN others => data <= "11000000000000";
			END CASE;
	END PROCESS;
END ARCHITECTURE;
				
