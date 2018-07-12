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
			   WHEN "0000" => data <= "00100100010100";
				WHEN "0001" => data <= "11100010000101";
				WHEN "0010" => data <= "00100100001111";
				WHEN "0011" => data <= "11100010000110";
				WHEN "0100" => data <= "00110000001010";
				WHEN "0101" => data <= "11100010000111";
				WHEN "0110" => data <= "00110000010100";
				WHEN "0111" => data <= "11100010001000";
				WHEN "1000" => data <= "11100100000111";
				WHEN "1001" => data <= "11110000000111";
				WHEN "1010" => data <= "11100100000111";
				WHEN "1011" => data <= "11100100000101";
				WHEN "1100" => data <= "11100110001000";
				WHEN others => data <= "00000000000000";
			END CASE;
	END PROCESS;
END ARCHITECTURE;
				














