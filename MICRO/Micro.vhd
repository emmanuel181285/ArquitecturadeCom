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
		HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR (6 downto 0)
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
		SIGNAL temp_B, temp_W, temp_R, W, MASK: STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL temp_RAM_ADDR: STD_LOGIC_VECTOR (6 downto 0);
		SIGNAL temp_RAM_DATIN, temp_RAM_DATOUT : STD_LOGIC_VECTOR (7 downto 0);
		SIGNAL temp_RAM_WR : STD_LOGIC;
		
		
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
											 



Box_RAM: ENTITY work.RAM PORT MAP (RAM_WR => temp_RAM_WR,
											  RAM_DATA_IN => temp_R,
											  RAM_DATA_OUT => temp_RAM_DATOUT,
											  RAM_ADDR => temp_RAM_ADDR,
											  --RAM_CLOCK => temp_RAM_CLK
											  CLK => CLK
											  );											 
											 
											 

											 
dpe:
PROCESS (state, IR,C, regPC,W,Temp_R, Temp_C, PC, regdata, RST)
	BEGIN
		IF RST = '0' THEN
			W <= "00000000";
			PC <= "0000";
			next_state <= State1;
		ELSE
		CASE state IS
			WHEN state1 =>
				  regPC <= PC;
				  IR <= regdata;
				  temp_Ci <= temp_C;
				  temp_RAM_WR <= '1';
				  next_state <= state2;
				  
			WHEN state2 =>
				  IF (IR(13 downto 12)= "11") THEN				
						temp_B <=  IR (7 downto 0);
				  ELSIF (IR (13 downto 12)= "00") THEN				 
						temp_B <= temp_RAM_DATOUT;
              ELSE
						temp_B <= "00000000";
				  END IF;              
				   
				  
				  IF (IR( 13 downto 12)= "00") THEN
						temp_w <= W;
						temp_B <= temp_RAM_DATOUT;
						temp_S <= IR(11 downto 8);
				  
				  
				  ELSIF (IR(13 downto 12) = "01") THEN
				      IF (IR(11 downto 10)= "00") THEN
								temp_S <= "0100";
						ELSIF (IR (11 downto 10) = "01") THEN
				            temp_S <= "0101";
						ELSE
				            temp_S <= IR (11 downto 8);
								PC <= regPC + "0001";
						END IF;		
						temp_W <= MASK;
						temp_B <= temp_RAM_DATOUT;
				  
				  ELSIF (IR(13 downto 12) = "11") THEN
						temp_W <= W;
						temp_B <= IR (7 downto 0);
						temp_S <= IR(11 downto 8);
				  END IF;  
				  
				  
				  
	
				  temp_S <= IR (11 downto 8);
				  temp_RAM_WR <= '1'; 
				  next_state <= state3;
			WHEN state3 =>			 
			    CASE IR (13 downto 12) IS
				  WHEN "11" => 
				               W <= temp_R;
							      temp_RAM_WR <= '1'; 
				  WHEN "00" => 				 
				     IF IR(7)= '0' THEN
				               W<= temp_R;
					            temp_RAM_WR <= '1';						
								
				     ELSE 
				        temp_RAM_WR <= '0';
				        
				    END IF;
			     WHEN OTHERS =>
				    temp_RAM_WR <= '1';
					 
				 
				 END CASE;
			  PC <= regPC + "0001"; 	 
			  C <= temp_C;     	  
			  next_state <= state1;
	END CASE;
 END IF;
END PROCESS dpe;


PC_LED <= regPC;
W_LED <= W;
TEMP_RAM_DATIN <=temp_R;
temp_RAM_ADDR <= IR (6 downto 0);
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

deco:

PROCESS(IR, MASK)
  BEGIN

      CASE (IR(11 downto 7)) IS
		  WHEN "00000" => MASK <= "11111110";                      --BCF
		  WHEN "00001" => MASK <= "11111101";
		  WHEN "00010" => MASK <= "11111011";
		  WHEN "00011" => MASK <= "11110111";
		  WHEN "00100" => MASK <= "11101111";
		  WHEN "00101" => MASK <= "11011111";
		  WHEN "00110" => MASK <= "10111111";
		  WHEN "00111" =>	MASK <= "01111111"; 
		  WHEN "01000"|"10000"|"11000" => MASK <= "00000001";      --BSF-BTFSS-BTFSC
		  WHEN "01001"|"10001"|"11001" => MASK <= "00000010";
		  WHEN "01010"|"10010"|"11010" => MASK <= "00000100";
		  WHEN "01011"|"10011"|"11011" => MASK <= "00001000";
		  WHEN "01100"|"10100"|"11100" => MASK <= "00010000";
		  WHEN "01101"|"10101"|"11101" => MASK <= "00100000";
		  WHEN "01110"|"10110"|"11110" => MASK <= "01000000";
		  WHEN "01111"|"10111"|"11111" => MASK <= "10000000";
	
		END CASE;
END PROCESS;

END ARCHITECTURE;
 
 