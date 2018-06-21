library ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;


ENTITY ALU IS
PORT ( Ci : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		 OP : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		 R : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		 Zo : OUT STD_LOGIC;
		 Co: OUT STD_LOGIC
		 );		 
END ENTITY ALU;

ARCHITECTURE M_ALU OF ALU IS
SIGNAL SR : STD_LOGIC_VECTOR (8 downto 0);
SIGNAL R1 : STD_LOGIC_VECTOR (7 downto 0);
BEGIN
	PROCESS (OP, A,B,R1,SR, Ci)
		BEGIN
				
				Zo <= '0';
				Co <= '0';
				IF (OP ="0000") THEN
					R1 <= "00000000";
				ELSIF (OP = "0001") THEN
					R1 <= "00000000";
	--RLA
				ELSIF (OP ="0010") THEN
					R1(0) <= Ci;
					R1(1) <= B(0);
					R1(2) <= B(1);
					R1(3) <= B(2);
					R1(4) <= B(3);
					R1(5) <= B(4);
					R1(6) <= B(5);
					R1(7) <= B(6);
					Co <= B(7);
	--RRA
				ELSIF (OP = "0011") THEN
					Co <= B(0);
					R1(0) <= B(1);
					R1(1) <= B(2);
					R1(2) <= B(3);
					R1(3) <= B(4);
					R1(4) <= B(5);
					R1(5) <= B(6);
					R1(6) <= B(7);
					R1(7) <= Ci;
				ELSIF (OP = "0100") THEN
					R1 <= (A AND B);
				ELSIF (OP = "0101") THEN
					R1 <= (A OR B);
				ELSIF (OP = "0110") THEN
					R1 <= (A XOR B);
				ELSIF (OP = "0111") THEN
					R1 <= (NOT B);
				ELSIF (OP = "1000") THEN
					R1 <= A;
				ELSIF (OP = "1001") THEN
					R1 <= B;
				ELSIF (OP = "1010") THEN
					SR <= ('0'& B) + "00001";
					R1 <= SR(7 downto 0);
					Co <= SR(8);
				ELSIF (OP = "1011") THEN
					SR <= ('0'& B) - "00001";
					R1 <= SR(7 downto 0);
					Co <= SR(8);
				ELSIF (OP = "1100") THEN
					SR	<= ('0' & A)+('0' & B) + ("0000000" & Ci);
					R1 <= SR (7 downto 0);
					Co <= SR(8);
				ELSIF (OP = "1101") THEN
					SR <= ('0' & A) - ('0' & B) - ("0000000" & Ci);
					R1 <= SR (7 downto 0);
					Co <= SR(8);	
				ELSIF (OP = "1110") THEN
					R1 <= "11111111";
				ELSIF (OP = "1111") THEN
					R1 <= "11111111";
				END IF;
				IF (R1 = "00000000") THEN
					Zo <= '1';
				END IF;		
	R <= R1;			
	END PROCESS;
	
END ARCHITECTURE;
