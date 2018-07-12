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
			   WHEN "0000" => data <= "11100100010100"; -- 0000
				WHEN "0001" => data <= "00100010000101"; -- 0001
				WHEN "0010" => data <= "11100100001111"; -- 0010
				WHEN "0011" => data <= "00100010000110"; -- 0011
				WHEN "0100" => data <= "11110000001010"; -- 0100
				WHEN "0101" => data <= "00100010000111"; -- 0101
				WHEN "0110" => data <= "11110000010100"; -- 0110
				WHEN "0111" => data <= "00100010001000"; -- 0111
				WHEN "1000" => data <= "00100110000111"; -- 1000
				WHEN "1001" => data <= "00110000000111"; -- 1001
				WHEN "1010" => data <= "00100100000111"; -- 1010
				WHEN "1011" => data <= "00110010000110"; -- 1011
				WHEN "1100" => data <= "00100100000110"; -- 1100
				WHEN others => data <= "11000000000000";
			END CASE;
	END PROCESS;
END ARCHITECTURE;
				














