library ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY mem IS
PORT ( address : IN STD_LOGIC_VECTOR (3 downto 0);
		 data : OUT STD_LOGIC_VECTOR (13 downto 0)
	   );
END ENTITY;

ARCHITECTURE a_mem OF mem IS
BEGIN
	PROCESS (address)
		BEGIN
			CASE address IS
				WHEN "0000" => data <= "11100100001111";
				WHEN "0001" => data <= "11110000001100";
				WHEN "0010" => data <= "11010111110000";
				WHEN "0011" => data <= "11011000000011";
				WHEN "0100" => data <= "11010011111111";
				WHEN "0101" => data <= "11110001100100";
				WHEN "0110" => data <= "11110111001000";
				WHEN "0111" => data <= "11110001100100";
				WHEN "1000" => data <= "11010100001100";
				WHEN "1001" => data <= "11010000000000";
				WHEN "1010" => data <= "11100100010111";
				WHEN others => data <= "11000000000000";
			END CASE;
	END PROCESS;
END ARCHITECTURE;
				
