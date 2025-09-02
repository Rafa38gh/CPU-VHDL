LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.REG4_package.all;
USE work.ULA_package.all;
USE work.BUFF_package.all;

ENTITY CPU IS
	PORT (DATA		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CLK		:	IN STD_LOGIC;
			ENABLE	:	IN STD_LOGIC;
			RESET		:	IN STD_LOGIC;
			F			:	IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			REG1_OUT	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Saída de R1 mostrada na placa --
			REG2_OUT	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Saída de R2 mostrada na placa --
			REG3_OUT	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0));		-- Saída de R3 mostrada na placa --
END CPU;

ARCHITECTURE LOGIC OF CPU IS

	SIGNAL MAIN_BUS	:	STD_LOGIC_VECTOR(3 DOWNTO 0);		-- BUS --
	
--==============================================================================================
	
	-- Sinais dos registradores (não contém G_IN pois esse é a saída da ULA) --
	SIGNAL R1_IN	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R2_IN	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R3_IN	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL A_IN		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	SIGNAL R1_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R2_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R3_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL A_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL G_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	
--==============================================================================================
	
	-- Sinais dos buffers --
	SIGNAL CTRL1		:	STD_LOGIC;		-- Buffer do registrador 1 --
	SIGNAL CTRL2		:	STD_LOGIC;		-- Buffer do registrador 2 --
	SIGNAL CTRL3		:	STD_LOGIC;		-- Buffer do registrador 3 --
	SIGNAL CTRLD		:	STD_LOGIC;		-- Buffer do DATA --
	
	SIGNAL BUFF1_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BUFF2_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BUFF3_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL BUFFD_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);

--==============================================================================================
	
	-- Sinais da ULA (não contém X pois esse é a saída do registrador A) --
	SIGNAL ADDSUB	:	STD_LOGIC;							-- SOMA = 0, SUB = 1 --
	SIGNAL Y			:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL S			:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL COUT		:	STD_LOGIC;
	
--==============================================================================================
	
	-- Inicializando máquina de estados --
	TYPE STATE_TYPE IS (IDLE, LOADR11, LOADR12, LOADR13, LOADR21, LOADR22, LOADR23, LOADR31, LOADR32, LOADR33, ADD1, ADD2, ADD3, ADD4, ADD5, ADD6, ADD7, ADD8, ADD9, SUB1, SUB2, SUB3, SUB4, SUB5, SUB6, SUB7, SUB8, SUB9, SWAP1, SWAP2, SWAP3, SWAP4, SWAP5, SWAP6, SWAP7, SWAP8, SWAP9);
	SIGNAL W		:	STATE_TYPE;
	
--==============================================================================================
	
	BEGIN
		
		-- Registradores --
		R1: REG4 PORT MAP(REG_IN => R1_IN, CLK => CLK, CLEAR => RESET, REG_OUT => R1_OUT);
		R2: REG4 PORT MAP(REG_IN => R2_IN, CLK => CLK, CLEAR => RESET, REG_OUT => R2_OUT);
		R3: REG4 PORT MAP(REG_IN => R3_IN, CLK => CLK, CLEAR => RESET, REG_OUT => R3_OUT);
		A:  REG4 PORT MAP(REG_IN => A_IN, CLK => CLK, CLEAR => RESET, REG_OUT => A_OUT);
		G:  REG4 PORT MAP(REG_IN => S, CLK => CLK, CLEAR => RESET, REG_OUT => G_OUT);
		
		-- Buffers --
		BUFFER1: BUFF PORT MAP(BUFF_IN => R1_OUT, CTRL => CTRL1, BUFF_OUT => BUFF1_OUT);
		BUFFER2: BUFF PORT MAP(BUFF_IN => R2_OUT, CTRL => CTRL2, BUFF_OUT => BUFF2_OUT);
		BUFFER3: BUFF PORT MAP(BUFF_IN => R3_OUT, CTRL => CTRL3, BUFF_OUT => BUFF3_OUT);
		BUFFERD: BUFF PORT MAP(BUFF_IN => DATA, CTRL => CTRLD, BUFF_OUT => BUFFD_OUT);
		
		-- ULA --
		ULAFINAL: ULA PORT MAP(CIN => ADDSUB, X => A_OUT, Y => Y, S => S, COUT => COUT);
		
--==============================================================================================
		
		-- Saídas --
		REG1_OUT <= R1_OUT;
		REG2_OUT <= R2_OUT;
		REG3_OUT <= R3_OUT;
		
--==============================================================================================
		
		-- Máquina de estados --
		
		PROCESS(CLK, ENABLE, RESET, F)
		BEGIN
			IF RESET = '1' THEN
				R1_IN <= "0000";
				R2_IN <= "0000";
				R3_IN <= "0000";
				A_IN <= "0000";
				
				W <= IDLE;
			
			ELSIF CLK'EVENT AND CLK = '1' THEN
					
				CASE W IS
					
					WHEN IDLE =>
						ADDSUB <= '0';
						CTRL1 <= '0';
						CTRL2 <= '0';
						CTRL3 <= '0';
						CTRLD <= '0';
					
						IF ENABLE = '1' THEN
						
							IF F = "101" THEN
								W <= LOADR11;
							
							ELSIF F = "110" THEN
								W <= LOADR21;
							
							ELSIF F = "111" THEN
								W <= LOADR31;
							
							ELSIF F = "010" THEN
								W <= ADD1;
								
							ELSIF F = "001" THEN
								W <= SUB1;
							
							ELSIF F = "011" THEN
								W <= SWAP1;
							
							END IF;
						 
						ELSE
							W <= IDLE;
						
						END IF;
						
--============================================================================
							
					-- LOAD R1 --
					WHEN LOADR11 =>
						CTRLD <= '1';
						W <= LOADR12;
					
					WHEN LOADR12 =>
						MAIN_BUS <= BUFFD_OUT;
						W <= LOADR13;
						
					WHEN LOADR13 =>
						R1_IN <= MAIN_BUS;
						W <= IDLE;
						
--============================================================================
						
					-- LOAD R2 --	
					WHEN LOADR21 =>
						CTRLD <= '1';
						W <= LOADR22;
						
					WHEN LOADR22 =>
						MAIN_BUS <= BUFFD_OUT;
						W <= LOADR23;
						
					WHEN LOADR23 =>
						R2_IN <= MAIN_BUS;
						W <= IDLE;
					
--============================================================================
					
					-- LOAD R3 --
					WHEN LOADR31 =>
						CTRLD <= '1';
						W <= LOADR32;
						
					WHEN LOADR32 =>
						MAIN_BUS <= BUFFD_OUT;
						W <= LOADR33;
						
					WHEN LOADR33 =>
						R3_IN <= MAIN_BUS;
						W <= IDLE;
						
--============================================================================
					
					-- ADD R1 + R2 --
					WHEN ADD1 =>
						ADDSUB <= '0';
						CTRL1 <= '1';
						W <= ADD2;
					
					WHEN ADD2 =>
						MAIN_BUS <= BUFF1_OUT;
						W <= ADD3;
					
					WHEN ADD3 =>
						A_IN <= MAIN_BUS;
						W <= ADD4;
					
					WHEN ADD4 =>
						CTRL2 <= '1';
						W <= ADD5;
					
					WHEN ADD5 =>
						MAIN_BUS <= BUFF2_OUT;
						W <= ADD6;
					
					WHEN ADD6 =>
						Y <= MAIN_BUS;
						W <= ADD7;
						
					WHEN ADD7 =>
						MAIN_BUS <= "0000";
						W <= ADD8;
					
					WHEN ADD8 =>
						MAIN_BUS <= G_OUT;
						W <= ADD9;
					
					WHEN ADD9 =>
						R3_IN <= MAIN_BUS;
						W <= IDLE;
						
--============================================================================
					
					-- SUB R1 - R2 --
					WHEN SUB1 =>
						ADDSUB <= '1';
						CTRL1 <= '1';
						W <= SUB2;
					
					WHEN SUB2 =>
						MAIN_BUS <= BUFF1_OUT;
						W <= SUB3;
					
					WHEN SUB3 =>
						A_IN <= MAIN_BUS;
						W <= SUB4;
					
					WHEN SUB4 =>
						CTRL2 <= '1';
						W <= SUB5;
					
					WHEN SUB5 =>
						MAIN_BUS <= BUFF2_OUT;
						W <= SUB6;
					
					WHEN SUB6 =>
						Y <= MAIN_BUS;
						W <= SUB7;
						
					WHEN SUB7 =>
						MAIN_BUS <= "0000";
						W <= SUB8;
					
					WHEN SUB8 =>
						MAIN_BUS <= G_OUT;
						W <= SUB9;
					
					WHEN SUB9 =>
						R3_IN <= MAIN_BUS;
						W <= IDLE;
						
--============================================================================
						
					-- SWAP R1 R2 --
					WHEN SWAP1 =>
						CTRL1 <= '1';
						W <= SWAP2;
					
					WHEN SWAP2 =>
						MAIN_BUS <= BUFF1_OUT;
						W <= SWAP3;
						
					WHEN SWAP3 =>
						R3_IN <= MAIN_BUS;
						W <= SWAP4;
						
					WHEN SWAP4 =>
						CTRL2 <= '1';
						W <= SWAP5;
					
					WHEN SWAP5 =>
						MAIN_BUS <= BUFF2_OUT;
						W <= SWAP6;
						
					WHEN SWAP6 =>
						R1_IN <= MAIN_BUS;
						W <= SWAP7;
						
					WHEN SWAP7 =>
						CTRL3 <= '1';
						W <= SWAP8;
						
					WHEN SWAP8 =>
						MAIN_BUS <= BUFF3_OUT;
						W <= SWAP9;
						
					WHEN SWAP9 =>
						R2_IN <= MAIN_BUS;
						W <= IDLE;
					
--============================================================================	
					
					-- OTHERS --
					WHEN OTHERS =>
						W <= IDLE;
					
				END CASE;
			END IF;
		END PROCESS;
						
		
END LOGIC;
		