-- Comparador 4 bits --
-- Saída: EQ => 0011
--			 GT => 0010 
--			 LT => 0001

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY comp IS
	PORT (A		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			S		:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0));		-- Resultado da saída será armazenado no registrador
END comp;

ARCHITECTURE LOGIC OF comp IS
	SIGNAL X		:		STD_LOGIC_VECTOR(3 DOWNTO 0);				-- Verifica a igualdade de cada bit
	SIGNAL EQ, GT, LT	:	STD_LOGIC;
	
	BEGIN
		
		X(0) <= NOT (A(0) XOR B(0));
		X(1) <= NOT (A(1) XOR B(1));
		X(2) <= NOT (A(2) XOR B(2));
		X(3) <= NOT (A(3) XOR B(3));
		
		-- A = B
		EQ <= X(3) AND X(2) AND X(1) AND X(0);
		
		-- A > B
		GT <= (A(3) AND NOT B(3)) OR (X(3) AND A(2) AND NOT B(2)) OR (X(3) AND X(2) AND A(1) AND NOT B(1)) OR (X(3) AND X(2) AND X(1) AND A(0) AND NOT B(0));
	
		-- A < B
		LT <= (NOT A(3) AND B(3)) OR (X(3) AND NOT A(2) AND B(2)) OR (X(3) AND X(2) AND NOT A(1) AND B(1)) OR (X(3) AND X(2) AND X(1) AND NOT A(0) AND B(0));
		
		-- Resultado passado para o registrador
		S <=	"0011" WHEN EQ = '1' ELSE
				"0010" WHEN GT = '1' ELSE
				"0001" WHEN LT = '1';
END LOGIC;