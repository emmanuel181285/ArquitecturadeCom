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
		Cin_LED : OUT STD_LOGIC;
		HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR (6 downto 0)
	   );
END ENTITY;

ARCHITECTURE A_Micro OF Micro IS
	TYPE State_Type IS (State1, State2, State3);
		
		SIGNAL State : State_Type := State1;
		SIGNAL Next_State : State_Type;
	
		SIGNAL PC : STD_LOGIC_VECTOR (3 downto 0) := "0000";
		SIGNAL IR, Reg_Data : STD_LOGIC_VECTOR (13 downto 0);
		SIGNAL Temp_S, Reg_PC: STD_LOGIC_VECTOR (3 downto 0);
		SIGNAL Zout, C, Temp_C, Temp_Ci, W_E : STD_LOGIC := '0';
		SIGNAL Temp_B, Temp_W, Temp_R, Data_In, Data_Out, W: STD_LOGIC_VECTOR (7 downto 0):= "00000000";
		SIGNAL Address : STD_LOGIC_VECTOR (6 downto 0);
Begin

Box_ALU : ENTITY work.ALU PORT MAP (A => Temp_W, 
												B => Temp_B, 
												OP => Temp_S, 
												R => Temp_R, 
												Zo => Zout,
												Co => Temp_C, 
												Ci => Temp_Ci);
												
Box_ROM: ENTITY work.mem PORT MAP (address => Reg_PC,
											  data => Reg_Data);
											  
Box_RAM: ENTITY work.RAM PORT MAP (WE => W_E,
											  datain => temp_R,
											  dataout => Data_Out,
											  --data => temp_R,
											  --q => Data_Out,
											  addr => Address,
											  CLK => CLK);
dpe:
PROCESS (state, IR,C, Reg_PC, W, Temp_R, Temp_C, PC, Reg_Data, RST)
	BEGIN
		IF RST = '0' THEN
			W <= "00000000";
			PC <= "0000";
			Next_State <= State1;
		ELSE 
		
		CASE State IS
			WHEN State1 =>
				Reg_PC <= PC;
				IR <= Reg_Data;
				--temp_Ci <= temp_C;
				W_E <= '1';			
				Next_State <= State2;
				
			WHEN State2 =>
				IF (IR(13 downto 12) = "11") THEN
					Temp_B <= IR (7 downto 0);
				ELSIF (IR(13 downto 12) = "00") THEN	
					Temp_B <= Data_Out;
			   ELSE
					temp_B <= "00000000";
				END IF;
				Temp_W <= W;
				Temp_S <= IR (11 downto 8);
				W_E <= '1';
				Next_State <= State3;
				
			WHEN State3 =>
				IF (IR (13 downto 12) = "11") THEN
					W <= Temp_R;
					W_E <= '1';
				ELSIF (IR (13 downto 12) = "00") THEN
					IF IR(7) = '0' THEN
						W <= temp_R;
						W_E <= '1';
					ELSE
						W_E <= '0';
					END IF;
				ELSE 
					W_E <= '1';
				END IF;
				PC <= Reg_PC + "0001";
				--C <= temp_C;
				Next_State <= State1;
				
		END CASE;
		END IF;
END PROCESS;
      
PC_LED <= Reg_PC;
W_LED <= W;
C_OUT <= C;
Z_OUT <= Zout;
ds:
PROCESS(state)
  BEGIN
		CASE state IS
			WHEN state1 =>
				HEX0 <= "1111001";
				HEX1 <= "1111111";
				HEX2 <= "1111111";
				HEX3 <= "1111111";
			WHEN state2 =>
			   HEX0 <= "0100100";
				HEX1 <= "1111111";
				HEX2 <= "1111111";
				HEX3 <= "1111111";
			WHEN state3 =>
				HEX0 <= "0110000";
				HEX1 <= "1111111";
				HEX2 <= "1111111";
				HEX3 <= "1111111";
			
		END CASE;
END PROCESS;

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
