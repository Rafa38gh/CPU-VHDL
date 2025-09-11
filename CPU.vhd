-- CPU Completa --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.ULA_package.all;
USE work.reg4_package.all;
USE work.BUFF_package.all;

ENTITY CPU IS
	PORT (CLK		:		IN STD_LOGIC;			
			ENABLE	:		IN STD_LOGIC;
			OPREG		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			OPCODE	:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- 4 bits mais significativos indicam os registradores
			DATA		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CLEAR		:		IN STD_LOGIC;
			R1, R2, R3, R4	:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			OVERFLOW	:		OUT STD_LOGIC;
			CBUS		:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			EQ, GT, LT	:	OUT STD_LOGIC);
END CPU;
			
ARCHITECTURE FUNC OF CPU IS
	-- Barramento de dados --
	SIGNAL DBUS		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais dos registradores --
	SIGNAL R1_OUT, R2_OUT, R3_OUT, R4_OUT, A_OUT, G_OUT		:		STD_LOGIC_VECTOR(3 DOWNTO 0);	
	SIGNAL W1, W2, W3, W4, WA, WG							:		STD_LOGIC;
	
	-- Sinais dos buffers --
	SIGNAL EN1, EN2, EN3, EN4, ENA, ENG, EXTERN			:		STD_LOGIC;
	SIGNAL BA_OUT		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais da ULA --
	SIGNAL ULACODE			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ULA_OUT			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
--=====================================================================================================
	-- Inicializando máquina de estados --
	TYPE STATE_TYPE IS (IDLE, LOAD1, LOAD2, LOAD3, SWAP1, SWAP2, SWAP3, SWAP4, ULA1, ULA2, ULA3, ULA4, ULA5);
	SIGNAL W		:		STATE_TYPE;
	
	BEGIN
--=====================================================================================================
		-- INSTÂNCIAS
		
		-- Registradores --
		RE1: reg4 PORT MAP(CLK, DBUS, CLEAR, W1, R1_OUT);
		RE2: reg4 PORT MAP(CLK, DBUS, CLEAR, W2, R2_OUT);
		RE3: reg4 PORT MAP(CLK, DBUS, CLEAR, W3, R3_OUT);
		RE4: reg4 PORT MAP(CLK, DBUS, CLEAR, W4, R4_OUT);
		REA: reg4 PORT MAP(CLK, DBUS, CLEAR, WA, A_OUT);
		RG:  reg4 PORT MAP(CLK, ULA_OUT, CLEAR, WG, G_OUT); 
		
		-- Buffers --
		EXT: BUFF PORT MAP(DATA, EXTERN, DBUS);
		B1: BUFF PORT MAP(R1_OUT, EN1, DBUS);
		B2: BUFF PORT MAP(R2_OUT, EN2, DBUS);
		B3: BUFF PORT MAP(R3_OUT, EN3, DBUS);
		B4: BUFF PORT MAP(R4_OUT, EN4, DBUS);
		BA: BUFF PORT MAP(A_OUT, ENA, BA_OUT);
		BG: BUFF PORT MAP(G_OUT, ENG, DBUS);
		
		-- ULA --
		ULAFINAL: ULA PORT MAP(ULACODE, BA_OUT, DBUS, ULA_OUT, OVERFLOW, EQ, GT, LT); 
		
		CBUS <= DBUS;
		
		-- Mapeando saídas dos registradores --
		R1 <= R1_OUT;
		R2 <= R2_OUT;
		R3 <= R3_OUT;
		R4 <= R4_OUT;
		
--======================================================================================================
		-- Máquina de estados --
		
		PROCESS(CLK, ENABLE, OPCODE, CLEAR, OPREG)
		BEGIN
			IF CLEAR = '1' THEN
				W <= IDLE;
				
			ELSIF CLK'EVENT AND CLK = '1' THEN
			
				CASE W IS
					
					WHEN IDLE =>
						-- Desabilita os buffers --
						EXTERN <= '0';
						EN1 <= '0';
						EN2 <= '0';
						EN3 <= '0';
						EN4 <= '0';
						ENA <= '0';
						ENG <= '0';
						
						-- Desabilita a escrita dos registradores --
						W1 <= '0';
						W2 <= '0';
						W3 <= '0';
						W4 <= '0';
						WA <= '0';
						WG <= '0';
						
						-- Desabilita as operações da ULA --
						ULACODE <= "0000";
						
						IF ENABLE = '1' THEN
							
							IF OPCODE = "1000" THEN
								W <= LOAD1;
								
							ELSIF OPCODE = "1001" THEN
								W <= SWAP1;
							
							ELSIF OPCODE = "0001" OR OPCODE = "0010" OR OPCODE = "0011" OR OPCODE = "0100" OR OPCODE = "0101" OR OPCODE = "0110" OR OPCODE = "0111" THEN
								W <= ULA1;
								
							END IF;
							
						END IF;

--===============================================================================================
					-- LOAD --
					WHEN LOAD1 =>
						-- Desabilita os buffers --
						EN1 <= '0';
						EN2 <= '0';
						EN3 <= '0';
						EN4 <= '0';
						ENA <= '0';
						ENG <= '0';
						
						-- Desabilita a escrita dos registradores --
						W1 <= '0';
						W2 <= '0';
						W3 <= '0';
						W4 <= '0';
						WA <= '0';
						WG <= '0';
					
						EXTERN <= '1';
						W <= LOAD2;
					
					WHEN LOAD2 =>
						EXTERN <= '1';
					
						CASE OPREG(1 DOWNTO 0) IS
							WHEN "00" =>  -- R1
								W1 <= '1';
							WHEN "01" =>  -- R2
								W2 <= '1';
							WHEN "10" =>  -- R3
								W3 <= '1';
							WHEN "11" =>  -- R4
								W4 <= '1';
							WHEN OTHERS =>
								W1 <= '0';
								W2 <= '0';
								W3 <= '0';
								W4 <= '0';
								WA <= '0';
								WG <= '0';
						
						END CASE;
						W <= LOAD3;
						
						WHEN LOAD3 =>
							IF ENABLE = '0' THEN
								W <= IDLE;
								
							ELSE
								W <= LOAD3;
							END IF;
						
--===============================================================================================
					-- SWAP --
					WHEN SWAP1 =>
						EN1 <= '0';
						EN2 <= '0';
						EN3 <= '0';
						EN4 <= '0';
						W1 <= '0';
						W2 <= '0';
						W3 <= '0';
						W4 <= '0';
						WA <= '0';
						WG <= '0';


						CASE OPREG(3 DOWNTO 2) IS
						
							WHEN "00" => 
								EN1 <= '1'; 
								W4 <= '1';  -- R1 - R4
								
							WHEN "01" => 
								EN2 <= '1'; 
								W4 <= '1';  -- R2 - R4
								
							WHEN "10" => 
								EN3 <= '1'; 
								W4 <= '1';  -- R3 - R4
								
							WHEN OTHERS => NULL;
						
						END CASE;
						W <= SWAP2;

					WHEN SWAP2 =>
						EN1 <= '0'; 
						EN2 <= '0'; 
						EN3 <= '0'; 
						EN4 <= '0';
						W1 <= '0'; 
						W2 <= '0'; 
						W3 <= '0'; 
						W4 <= '0';
						WA <= '0';
						WG <= '0';

						CASE OPREG(3 DOWNTO 2) IS  -- Primeiro registrador
						  WHEN "00" =>
								CASE OPREG(1 DOWNTO 0) IS  -- Segundo registrador
								
									 WHEN "00" => 
										EN1 <= '1'; 
										W1 <= '1';
										
									 WHEN "01" => 
										EN2 <= '1'; 
										W1 <= '1';
										
									 WHEN "10" => 
										EN3 <= '1'; 
										W1 <= '1';
										
									 WHEN "11" => 
										EN4 <= '1'; 
										W1 <= '1';
										
									 WHEN OTHERS => NULL;
								END CASE;
								
						  WHEN "01" =>
								CASE OPREG(1 DOWNTO 0) IS
								
									 WHEN "00" => 
										EN1 <= '1'; 
										W2 <= '1';
										
									 WHEN "01" => 
										EN2 <= '1'; 
										W2 <= '1';
										
									 WHEN "10" => 
										EN3 <= '1'; 
										W2 <= '1';
										
									 WHEN "11" => 
										EN4 <= '1'; 
										W2 <= '1';
										
									 WHEN OTHERS => NULL;
								END CASE;
								
						  WHEN "10" =>
								CASE OPREG(1 DOWNTO 0) IS
								
									 WHEN "00" => 
										EN1 <= '1'; 
										W3 <= '1';
										
									 WHEN "01" => 
										EN2 <= '1'; 
										W3 <= '1';
										
									 WHEN "10" => 
										EN3 <= '1'; 
										W3 <= '1';
										
									 WHEN "11" => 
										EN4 <= '1'; 
										W3 <= '1';
										
									 WHEN OTHERS => NULL;
								END CASE;
								
						  WHEN OTHERS => NULL;
						END CASE;

						W <= SWAP3;

					WHEN SWAP3 =>
						EN1 <= '0'; 
						EN2 <= '0'; 
						EN3 <= '0'; 
						EN4 <= '0';
						W1 <= '0'; 
						W2 <= '0'; 
						W3 <= '0'; 
						W4 <= '0';
						WA <= '0';
						WG <= '0';

						CASE OPREG(1 DOWNTO 0) IS  -- Segundo registrador
							WHEN "00" => 
								W1 <= '1'; 
								EN4 <= '1';  -- R4 - R1
								
							WHEN "01" => 
								W2 <= '1'; 
								EN4 <= '1';  -- R4 - R2
								
							WHEN "10" => 
								W3 <= '1'; 
								EN4 <= '1';  -- R4 - R3
							WHEN OTHERS => NULL;
						
						END CASE;
						W <= SWAP4;
					
					WHEN SWAP4 =>
						IF ENABLE = '0' THEN
							W <= IDLE;
						ELSE
							W <= SWAP4;
						END IF;
					
						
--===============================================================================		
					-- ULA --
					WHEN ULA1 =>
						CASE OPREG(3 DOWNTO 2) IS
							
							WHEN "00" =>
								EN1 <= '1';
								WA <= '1';
							
							WHEN "01" =>
								EN2 <= '1';
								WA <= '1';
							
							WHEN "10" =>
								EN3 <= '1';
								WA <= '1';
							
							WHEN OTHERS => NULL;
						END CASE;
						W <= ULA2;
						
					WHEN ULA2 =>
						EXTERN <= '0';
						EN1 <= '0';
						EN2 <= '0';
						EN3 <= '0';
						EN4 <= '0';
						ENA <= '0';
						
						W1 <= '0';
						W2 <= '0';
						W3 <= '0';
						WA <= '0';
						WG <= '0';
						
						W <= ULA3;
					
					WHEN ULA3 =>
				
						CASE OPREG(1 DOWNTO 0) IS
							
							WHEN "00" =>
								EN1 <= '1';
								ENA <= '1';
								WG <= '1';
								ULACODE <= OPCODE;
							
							WHEN "01" =>
								EN2 <= '1';
								ENA <= '1';
								WG <= '1';
								ULACODE <= OPCODE;
							
							WHEN "10" =>
								EN3 <= '1';
								ENA <= '1';
								WG <= '1';
								ULACODE <= OPCODE;
							
							WHEN OTHERS => NULL;
						END CASE;
						W <= ULA4;
						
					WHEN ULA4 =>
						EXTERN <= '0';
						EN1 <= '0';
						EN2 <= '0';
						EN3 <= '0';
						EN4 <= '0';
						ENA <= '0';
						
						W1 <= '0';
						W2 <= '0';
						W3 <= '0';
						WA <= '0';
						WG <= '0';
						
						
						ENG <= '1';
						W4 <= '1';
					
						W <= ULA5;
					
					WHEN ULA5 =>
						IF ENABLE = '0' THEN
							W <= IDLE;
						ELSE
							W <= ULA5;
						END IF;
								
											
					WHEN OTHERS =>
						W <= IDLE;
						
					
				END CASE;
				
			END IF;
			
		END PROCESS;
		
END FUNC;