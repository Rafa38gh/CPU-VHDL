-- Multiplicador 2x2 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.half_adder_package.all;

ENTITY mult IS
	PORT (A, B		:		IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			P			:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0));		-- Saída de 4 bits
END mult;

ARCHITECTURE LOGIC OF mult IS
	-- Sinais parciais --
	SIGNAL PP		:		STD_LOGIC_VECTOR(3 DOWNTO 1);
	SIGNAL S1, C1	:		STD_LOGIC;
	
	BEGIN
		-- Produtos parciais --
		P(0) <= A(0) AND B(0);		-- Bit menos significativo
		PP(1) <= A(1) AND B(0);
		PP(2) <= A(0) AND B(1);
		PP(3) <= A(1) AND B(1);
		
		-- Somando produtos parciais --
		STAGE0 : half_adder PORT MAP(PP(1), PP(2), C1, P(1));
		STAGE1 : half_adder PORT MAP(C1, PP(3), P(3), P(2));		-- COUT soma com o bit mais significativo
END LOGIC;