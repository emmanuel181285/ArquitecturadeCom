library ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

ENTITY Micro IS
PORT (CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		C_OUT : OUT STD_LOGIC;
		Z_OUT : OUT STD_LOGIC;
		Cin_LED:OUT STD_LOGIC;
		W_LED :OUT STD_LOGIC_VECTOR (7 downto 0);
		PC_LED:OUT STD_LOGIC_VECTOR (3 downto 0);
		HEX0 : OUT STD_LOGIC_VECTOR (6 downto 0); 
		HEX1 : OUT STD_LOGIC_VECTOR (6 downto 0);
		HEX2 : OUT STD_LOGIC_VECTOR (6 downto 0);
		HEX3 : OUT STD_LOGIC_VECTOR (6 downto 0)
	   );
END ENTITY;

ARCHITECTURE A_Micro OF Micro IS
	TYPE State_Type IS (State1, State2, State3);
		
		SIGNAL State : State_Type := State1;
		SIGNAL Next_State : State_Type;
	
		
		SIGNAL C : STD_LOGIC := '0'; 
		SIGNAL W_E : STD_LOGIC := '0';
		SIGNAL Zout : STD_LOGIC := '0';  
		SIGNAL Temp_C : STD_LOGIC := '0'; 
		SIGNAL Temp_Ci : STD_LOGIC := '0'; 
		SIGNAL W : STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL IR: STD_LOGIC_VECTOR (13 downto 0);
		SIGNAL mask : STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL Temp_S: STD_LOGIC_VECTOR (3 downto 0);  
		SIGNAL Reg_PC: STD_LOGIC_VECTOR (3 downto 0);
		SIGNAL Temp_B : STD_LOGIC_VECTOR (7 downto 0); 
		SIGNAL Temp_W : STD_LOGIC_VECTOR (7 downto 0); 
		SIGNAL Temp_R : STD_LOGIC_VECTOR (7 downto 0); 
		SIGNAL Data_In : STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL Address : STD_LOGIC_VECTOR (6 downto 0);	
		SIGNAL Data_Out : STD_LOGIC_VECTOR (7 downto 0); 
		SIGNAL Reg_Data : STD_LOGIC_VECTOR (13 downto 0);
		SIGNAL PC : STD_LOGIC_VECTOR (3 downto 0) := "0000";
		
		
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
											  datain => Data_In,
											  dataout => Data_Out,
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
				temp_Ci <= temp_C;
				W_E <= '1';			
				Next_State <= State2;
				
			WHEN State2 =>		
				IF (IR(13 downto 12) = "11") THEN
					Temp_B <= IR (7 downto 0);
				ELSIF (IR(13 downto 12) = "00") or (IR(13 downto 12) = "01") THEN	
					Temp_B <= Data_Out;
			   ELSE
					temp_B <= "00000000";
				END IF;
				IF (IR(13 downto 12) = "01") THEN
					IF (IR(11 downto 10) = "00") THEN
					 temp_S <= "0100";
					ELSIF (IR(11 downto 10) = "01") THEN
					 temp_S <= "0101";
					END IF;
				ELSE
					 temp_S <= IR(11 downto 8);
				END IF;
				IF (IR(13 downto 12) = "00") or (IR(13 downto 12) = "11") THEN
					temp_W <= W;
				ELSIF (IR(11 downto 10) = "01") THEN
					 temp_W <= mask;
				END IF; 
				Address <= IR (6 downto 0);
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
--				ELSIF	(IR (13 downto 12) = "01") THEN
--					IF IR(11) = '0' THEN
--						W_E <= '1'
--					ELSE
						
				ELSE 
					W_E <= '1';
				END IF;
				PC <= Reg_PC + "0001";
				C <= temp_C;
				Next_State <= State1;
		END CASE;
		END IF;
END PROCESS;   
PC_LED <= Reg_PC;
W_LED <= W;
Data_In <= temp_R;
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
PROCESS (IR)
	BEGIN
		CASE IR(11 downto 7) IS 
			WHEN "00000" => mask <= "11111110";
			WHEN "00001" => mask <= "11111101";
			WHEN "00010" => mask <= "11111011";
			WHEN "00011" => mask <= "11110111";
			WHEN "00100" => mask <= "11101111";
			WHEN "00101" => mask <= "11011111";
			WHEN "00110" => mask <= "10111111";
			WHEN "00111" => mask <= "01111111";
			WHEN "01000" => mask <= "00000001";
			WHEN "01001" => mask <= "00000010";
			WHEN "01010" => mask <= "00000100";
			WHEN "01011" => mask <= "00001000";
			WHEN "01100" => mask <= "00010000";
			WHEN "01101" => mask <= "00100000";
			WHEN "01110" => mask <= "01000000";
			WHEN "01111" => mask <= "10000000";
			WHEN "10000" => mask <= "00000001";
			WHEN "10001" => mask <= "00000010";
			WHEN "10010" => mask <= "00000100";
			WHEN "10011" => mask <= "00001000";
			WHEN "10100" => mask <= "00010000";
			WHEN "10101" => mask <= "00100000";
			WHEN "10110" => mask <= "01000000";
			WHEN "10111" => mask <= "10000000";
			WHEN "11000" => mask <= "00000001";
			WHEN "11001" => mask <= "00000010";
			WHEN "11010" => mask <= "00000100";
			WHEN "11011" => mask <= "00001000";
			WHEN "11100" => mask <= "00010000";
			WHEN "11101" => mask <= "00100000";
			WHEN "11110" => mask <= "01000000";
			WHEN "11111" => mask <= "10000000";
		END CASE;
END PROCESS;

END ARCHITECTURE;
