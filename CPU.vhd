-- CPU Completa --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.ULA_package.all;
USE work.reg4_package.all;
USE work.DECODER_package.all;
USE work.BUFF_package.all;

ENTITY CPU IS
	PORT (CLK		:		IN STD_LOGIC;			
			ENABLE	:		IN STD_LOGIC;
			OPREG		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			OPCODE	:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- 4 bits mais significativos indicam os registradores
			DATA		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CLEAR		:		IN STD_LOGIC;
			R1, R2, R3, R4	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			OVERFLOW	:		OUT STD_LOGIC);
END CPU;
			
ARCHITECTURE LOGIC OF CPU IS
	-- Barramento de dados --
	SIGNAL DBUS		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais do DECODER --
	SIGNAL REG1, REG2		:		STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL DECODE			:		STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL DDATA			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL S1, S2			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais dos registradores de propósito específico --
	SIGNAL RA_OUT, RB_OUT, RG_OUT	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais dos buffers --
	SIGNAL BA_OUT, BB_OUT, BG_OUT	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ENA, ENB, ENG				:		STD_LOGIC;
	
	-- Sinais da ULA --
	SIGNAL ULACODE			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ULA_OUT			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
--=====================================================================================================
	-- Inicializando máquina de estados --
	TYPE STATE_TYPE IS (IDLE, LOAD, SWAP1, SWAP2, SWAP3, SWAP4, SWAP5, SWAP6, SWAP7, SWAP8, SWAP9, SWAP10, ULA1, ULA2, ULA3, ULA4, ULA5, ULA6, ULA7, ULA8);
	SIGNAL W		:		STATE_TYPE;
	
	BEGIN
--=====================================================================================================
		-- INSTÂNCIAS
		
		-- DECODER --
		DEC: DECODER PORT MAP(CLK, REG1, REG2, CLEAR, ENABLE, DECODE, DDATA, S1, S2, R1, R2, R3, R4);
		
		-- ULA --
		ULAFINAL: ULA PORT MAP(ULACODE, BA_OUT, BB_OUT, ULA_OUT, OVERFLOW); 
		
		-- Registradores de propósito específico --
		A: reg4 PORT MAP(CLK, S1, CLEAR, RA_OUT);
		B: reg4 PORT MAP(CLK, S2, CLEAR, RB_OUT);
		G: reg4 PORT MAP(CLK, ULA_OUT, CLEAR, RG_OUT);
		
		-- Buffers --
		BA: BUFF PORT MAP(RA_OUT, ENA, BA_OUT);
		BB: BUFF PORT MAP(RB_OUT, ENB, BB_OUT);
		BG: BUFF PORT MAP(RG_OUT, ENG, BG_OUT);
--======================================================================================================
		-- Máquina de estados --
		
		PROCESS(CLK, ENABLE, OPCODE, CLEAR, OPREG)
		BEGIN
			IF ENABLE = '0' THEN
				W <= IDLE;
				
			ELSIF CLK'EVENT AND CLK = '1' THEN
			
				CASE W IS
				
					WHEN IDLE =>
						ENA <= '0';
						ENB <= '0';
						ENG <= '0';
						DECODE <= "000";
						
						IF ENABLE = '1' THEN
							
							IF OPCODE = "1000" THEN
								W <= LOAD;
							
							ELSIF OPCODE = "1001" THEN
								W <= SWAP1;
								
							ELSIF OPCODE = "0001" OR OPCODE = "0010" OR OPCODE = "0011" OR OPCODE = "0100" OR OPCODE = "0101" OR OPCODE = "0110" OR OPCODE = "0111" THEN
								W <= ULA1;
								
							END IF;
							
						ELSE
							W <= IDLE;
							
						END IF;
--=======================================================================================================================================================================
					-- LOAD
					WHEN LOAD =>
						REG2 <= OPREG(1 DOWNTO 0);
						DDATA <= DATA;
						DECODE <= "001";
						W <= IDLE;
						
--=======================================================================================================================================================================
					-- SWAP
					WHEN SWAP1 =>
						REG2(0) <= OPREG(0);
						REG2(1) <= OPREG(1);
						REG1(0) <= OPREG(2);
						REG1(1) <= OPREG(3);
						W <= SWAP2;
						
					WHEN SWAP2 =>
						DECODE <= "010";
						W <= SWAP3;
						
					WHEN SWAP3 =>
						W <= SWAP4;
					
					WHEN SWAP4 =>
						W <= SWAP5;
					
					WHEN SWAP5 =>
						W <= SWAP6;
					
					WHEN SWAP6 =>
						DECODE <= "011";
						W <= SWAP7;
						
					WHEN SWAP7 =>
						W <= SWAP8;
						
					WHEN SWAP8 =>
						W <= SWAP9;
						
					WHEN SWAP9 =>
						W <= SWAP10;
						
					WHEN SWAP10 =>
						DECODE <= "100";
						W <= IDLE;
						
					
--=======================================================================================================================================================================
					-- AND
					WHEN ULA1 =>
						REG2(0) <= OPREG(0);
						REG2(1) <= OPREG(1);
						REG1(0) <= OPREG(2);
						REG1(1) <= OPREG(3);
						W <= ULA2;
					
					WHEN ULA2 =>
						DECODE <= "101";
						W <= ULA3;
					
					WHEN ULA3 =>
						ENA <= '1';
						ENB <= '1';
						W <= ULA4;
						
					WHEN ULA4 =>
						ULACODE <= OPCODE;
						DECODE <= "000";
						W <= ULA5;
						
					WHEN ULA5 =>
						ENG <= '1';
						W <= ULA6;
					
					WHEN ULA6 =>
						DBUS <= BG_OUT;
						W <= ULA7;
						
					WHEN ULA7 =>
						DDATA <= DBUS;	
						W <= ULA8;
						
					WHEN ULA8 =>
						DECODE <= "111";
						W <= IDLE;
					
				END CASE;
				
			END IF;
			
		END PROCESS;
	
		
END LOGIC;