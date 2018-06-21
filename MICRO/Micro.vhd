library ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY Micro IS
PORT (W_LED : OUT STD_LOGIC_VECTOR (7 downto 0);
		C_OUT , Z_OUT : OUT STD_LOGIC;
		PC_LED : OUT STD_LOGIC_VECTOR (3 downto 0);
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		HEX0 : OUT STD_LOGIC_VECTOR (6 downto 0)
	   );
END ENTITY;

ARCHITECTURE A_Micro OF Micro IS
	TYPE state_type IS (state1, state2, state3);
		
		SIGNAL state : state_type := state1;
		SIGNAL next_state : state_type;
		SIGNAL PC : STD_LOGIC_VECTOR (3 downto 0) := "0000";
		SIGNAL IR, regdata : STD_LOGIC_VECTOR (13 downto 0);
		SIGNAL temp_S, regPC: STD_LOGIC_VECTOR (3 downto 0);
		SIGNAL Zout, C, temp_C, temp_Ci : STD_LOGIC;
		SIGNAL temp_B, temp_W, temp_R, W: STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL temp_RAM_ADDR: STD_LOGIC_VECTOR (6 downto 0);
		SIGNAL temp_RAM_DATIN, temp_RAM_DATOUT : STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL temp_RAM_WR, temp_RAM_CLK: STD_LOGIC;
		
		
Begin

Box_ALU : ENTITY work.ALU PORT MAP (A => temp_W, 
												B => temp_B, 
												OP => temp_S, 
												R => temp_R, 
												Zo => Zout,
												Co => temp_C, 
												Ci => temp_Ci);
												
Box_ROM: ENTITY work.ROM PORT MAP (address => regPC,
											 data => regdata);
											 



Box_RAM: ENTITY work.RAM PORT MAP (RAM_ADDR => temp_RAM_ADDR,
											  RAM_DATA_IN => temp_RAM_DATIN,
											  RAM_DATA_OUT => temp_RAM_DATOUT,
											  RAM_WR => temp_RAM_WR,
											  RAM_CLOCK => temp_RAM_CLK
											  );											 
											 
											 

											 
dpe:
PROCESS (state, IR, regPC, PC, regdata, RST)
	BEGIN
		IF RST = '0' THEN
			W <= "00000000";
			PC <= "0000";
		ELSE
		CASE state IS
			WHEN state1 =>
				regPC <= PC;
				IR <= regdata;
				next_state <= state2;
			WHEN state2 =>
				--temp_B <= IR (7 downto 0);
				--temp_S <= IR (11 downto 8);
				IF IR (13 downto 12)= "11" THEN
				temp_B <=  IR (7 downto 0);
				ELSIF IR (13 downto 12)= "00" THEN
				temp_RAM_DATIN <= IR (7 downto 0);
				temp_B <= temp_RAM_DATIN;
				END IF;
				temp_W <= W;
				PC <= regPC + "0001";
				next_state <= state3;
			WHEN state3 =>
			   IF IR(7)= '0' THEN
				W <= temp_R;
				ELSIF IR(7)= '0' THEN
				Temp_RAM_DATIN <= IR (7 downto 0);
				temp_RAM_DATIN <= temp_R;
				END IF;
				C <= temp_C;
				next_state <= state1;
		END CASE;
		END IF;
END PROCESS dpe;
ds:
PROCESS(state)
  BEGIN
		CASE state IS
			WHEN state1 =>
				HEX0 <= "1111001";
			WHEN state2 =>
			   HEX0 <= "0100100";
			WHEN state3 =>
				HEX0 <= "0110000";
		END CASE;
END PROCESS;
      
PC_LED <= regPC;
W_LED <= W;
C_OUT <= C;
Z_OUT <= Zout;

ff:
PROCESS (CLK, RST, next_state)
	BEGIN
		IF RST = '0' THEN
			state <= state1;
		ELSIF CLK' event AND CLK = '0' THEN
			state <= next_state;
		END IF;				
END PROCESS ff;


END ARCHITECTURE;
 
 