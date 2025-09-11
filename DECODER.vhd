-- Registradores de propósito geral --
-- Decoder que gerencia o uso dos registradores --

-- OPCODES do DECODER
-- 001 - LOAD/WRITE Carrega o dado em DATA no registrador
-- 010 - SWAP1
-- 011 - SWAP2
-- 100 - SWAP3
-- 101 - REG_OUT
-- 111 - LOAD R4 -- Específico para uso da FSM

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.reg4_package.all;

ENTITY DECODER IS
	PORT (CLK				:		IN STD_LOGIC;
			REG1, REG2		:		IN STD_LOGIC_VECTOR(1 DOWNTO 0);		-- Define os registradores a serem usados
			CLEAR				:		IN STD_LOGIC;
			ENABLE			:		IN STD_LOGIC;
			OPCODE			:		IN STD_LOGIC_VECTOR(2 DOWNTO 0);		-- Gerencia o tipo de operação
			DATA				:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Dados para escrita
			S1, S2			:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			R1, R2,R3, R4	:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END DECODER;

ARCHITECTURE LOGIC OF DECODER IS
	SIGNAL R1_IN, R2_IN, R3_IN, R4_IN		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R1_OUT, R2_OUT, R3_OUT, R4_OUT	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL W1, W2, W3, W4						:		STD_LOGIC;
	
	BEGIN
		-- Registradores --
		RE1: reg4 PORT MAP(CLK, R1_IN, CLEAR, W1, R1_OUT);
		RE2: reg4 PORT MAP(CLK, R2_IN, CLEAR, W2, R2_OUT);
		RE3: reg4 PORT MAP(CLK, R3_IN, CLEAR, W3, R3_OUT);
		RE4: reg4 PORT MAP(CLK, R4_IN, CLEAR, W4, R4_OUT);		-- R4 recebe resultados da ULA e serve de auxiliar para o SWAP, não é usado pelo usuário
		
		-- DECODER --
		R1 <= R1_OUT;
		R2 <= R2_OUT;
		R3 <= R3_OUT;
		R4 <= R4_OUT;
		
		PROCESS(OPCODE, REG1, REG2, CLK, ENABLE, CLEAR)
		BEGIN
			IF CLEAR = '1' THEN
			  R1_IN <= (others => '0');
			  R2_IN <= (others => '0');
			  R3_IN <= (others => '0');
			  R4_IN <= (others => '0');
			  S1 <= (others => '0');
			  S2 <= (others => '0');
		
			ELSIF rising_edge(CLK) THEN
				IF ENABLE = '1' THEN
					CASE OPCODE IS
						WHEN "001" =>		-- LOAD
							
							CASE REG2 IS
								WHEN "01" =>
									R1_IN <= DATA;
								
								WHEN "10" =>
									R2_IN <= DATA;
									
								WHEN "11" =>
									R3_IN <= DATA;
								
								WHEN OTHERS => NULL;
							
							END CASE;
							
						WHEN "010" =>		-- SWAP1
							
							CASE REG1 IS
								WHEN "01" =>
									R4_IN <= R1_OUT;
								
								WHEN "10" =>
									R4_IN <= R2_OUT;
									
								WHEN "11" =>
									R4_IN <= R3_OUT;
									
								WHEN OTHERS => NULL;
								
							END CASE;
						
						WHEN "011" =>		-- SWAP2
						
							CASE REG2 IS
								WHEN "01" =>
								
									CASE REG1 IS
										WHEN "10" =>
											R2_IN <= R1_OUT;
										
										WHEN "11" =>
											R3_IN <= R1_OUT;
										
										WHEN OTHERS => NULL;
									
									END CASE;
								
								WHEN "10" =>
									
									CASE REG1 IS
										WHEN "01" =>
											R1_IN <= R2_OUT;
										
										WHEN "11" =>
											R3_IN <= R2_OUT;
										
										WHEN OTHERS => NULL;
										
									END CASE;
								
								WHEN "11" =>
									
									CASE REG1 IS
										WHEN "01" =>
											R1_IN <= R3_OUT;
											
										WHEN "10" =>
											R2_IN <= R3_OUT;
										
										WHEN OTHERS => NULL;
											
									END CASE;
								
								WHEN OTHERS => NULL;
								
							END CASE;
						
						WHEN "100" =>		-- SWAP3
							CASE REG2 IS
							
								WHEN "01" =>
									R1_IN <= R4_OUT;
								
								WHEN "10" =>
									R2_IN <= R4_OUT;
									
								WHEN "11" =>
									R3_IN <= R4_OUT;
								
								WHEN OTHERS => NULL;
								
							END CASE;
						
						WHEN "101" =>		-- REG OUT
							
							CASE REG1 IS
								
								WHEN "01" =>
									S1 <= R1_OUT;
									
								WHEN "10" =>
									S1 <= R2_OUT;
									
								WHEN "11" =>
									S1 <= R3_OUT;
									
								WHEN OTHERS => NULL;
								
							END CASE;
							
							CASE REG2 IS
								
								WHEN "01" =>
									S2 <= R1_OUT;
								
								WHEN "10" =>
									S2 <= R2_OUT;
									
								WHEN "11" =>
									S2 <= R3_OUT;
								
								WHEN OTHERS => NULL;
								
							END CASE;
						
						WHEN "111" =>		-- R4 IN
							R4_IN <= DATA;
						
						WHEN OTHERS => NULL;
						
					END CASE;
					
				END IF;
			END IF;
			
		END PROCESS;
		
END LOGIC;