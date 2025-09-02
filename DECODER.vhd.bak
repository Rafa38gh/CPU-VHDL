-- Registradores de propósito geral --
-- Decoder que gerencia o uso dos registradores --

-- OPCODES do DECODER
-- 001 - LOAD/WRITE Carrega o dado em DATA no registrador
-- 010 - SWAP1
-- 011 - SWAP2
-- 100 - SWAP3
-- 101 - REG_OUT

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.reg4_package.all;

ENTITY DECODER IS
	PORT (REG1, REG2		:		IN STD_LOGIC_VECTOR(1 DOWNTO 0);		-- Define os registradores a serem usados
			CLEAR				:		IN STD_LOGIC;
			OPCODE			:		IN STD_LOGIC_VECTOR(2 DOWNTO 0);		-- Gerencia o tipo de operação
			DATA				:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Dados para escrita
			S1, S2			:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END DECODER;

ARCHITECTURE LOGIC OF DECODER IS
	SIGNAL R1_IN, R2_IN, R3_IN, R4_IN		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R1_OUT, R2_OUT, R3_OUT, R4_OUT	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	BEGIN
		-- Registradores --
		R1: reg4 PORT MAP(R1_IN, CLEAR, R1_OUT);
		R2: reg4 PORT MAP(R2_IN, CLEAR, R2_OUT);
		R3: reg4 PORT MAP(R3_IN, CLEAR, R3_OUT);
		R4: reg4 PORT MAP(R4_IN, CLEAR, R4_OUT);		-- R4 recebe resultados da ULA e serve de auxiliar para o SWAP, não é usado pelo usuário
		
		-- DECODER --
		PROCESS(OPCODE, REG1, REG2)
		BEGIN
			IF OPCODE = "001"	THEN	-- LOAD
				IF REG2 = "01" THEN
					R1_IN <= DATA;
				
				ELSIF REG2 = "10" THEN
					R2_IN <= DATA;
				
				ELSIF REG2 = "11" THEN
					R3_IN <= DATA;
				END IF;
			
			
			ELSIF OPCODE = "010" THEN	-- SWAP1
				IF REG1 = "01" THEN
					R4_IN <= R1_OUT;
				
				ELSIF REG1 = "10" THEN
					R4_IN <= R2_OUT;
				
				ELSIF REG1 = "11" THEN
					R4_IN <= R3_OUT;
				END IF;
				
			
			ELSIF OPCODE = "011" THEN -- SWAP2
				IF REG2 = "01" THEN
					IF REG1 = "10" THEN
						R2_IN <= R1_OUT;
					ELSIF REG1 = "11" THEN
						R3_IN <= R1_OUT;
					END IF;
					
				ELSIF REG2 = "10" THEN
					IF REG1 = "01" THEN
						R1_IN <= R2_OUT;
					ELSIF REG1 = "11" THEN
						R3_IN <= R2_OUT;
					END IF;
				
				ELSIF REG2 = "11" THEN
					IF REG1 = "01" THEN
						R1_IN <= R3_OUT;
					ELSIF REG1 = "10" THEN
						R2_IN <= R3_OUT;
					END IF;
				END IF;
			
			ELSIF OPCODE = "100" THEN	-- SWAP3
				IF REG2 = "01" THEN
					R1_IN <= R4_OUT;
					
				ELSIF REG2 = "10" THEN
					R2_IN <= R4_OUT;
				
				ELSIF REG2 = "11" THEN
					R3_IN <= R4_OUT;
				END IF;
			
			ELSIF OPCODE = "101" THEN	-- REG OUT
				IF REG1 = "01" THEN
					S1 <= R1_OUT;
				ELSIF REG1 = "10" THEN
					S1 <= R2_OUT;
				ELSIF REG1 = "11" THEN
					S1 <= R3_OUT;
				END IF;
				
				IF REG2 = "01" THEN
					S2 <= R1_OUT;
				ELSIF REG2 = "10" THEN
					S2 <= R2_OUT;
				ELSIF REG2 = "11" THEN
					S2 <= R3_OUT;
				END IF;
				
			END IF;
		END PROCESS;
		
END LOGIC;