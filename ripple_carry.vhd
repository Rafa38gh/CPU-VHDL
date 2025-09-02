-- Somador/Subtrator 4 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.full_adder_package.all;

ENTITY ripple_carry IS
	PORT (CIN	:		IN STD_LOGIC;							-- Define o tipo de operação (soma/subtração)
			X		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Y		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			S		:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			COUT	:		OUT STD_LOGIC);
END ripple_carry;

ARCHITECTURE LOGIC OF ripple_carry IS
	SIGNAL C		:		STD_LOGIC_VECTOR(2 DOWNTO 0);		-- Armazena o COUT de cada full adder
	SIGNAL TMP	:		STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Transforma Y em complemento de 2 para subtração
	
	BEGIN
		TMP(0) <= CIN XOR Y(0);
		TMP(1) <= CIN XOR Y(1);
		TMP(2) <= CIN XOR Y(2);
		TMP(3) <= CIN XOR Y(3);
		
		STAGE0: full_adder PORT MAP(CIN, X(0), TMP(0), C(0), S(0));
		STAGE1: full_adder PORT MAP(C(0), X(1), TMP(1), C(1), S(1));
		STAGE2: full_adder PORT MAP(C(1), X(2), TMP(2), C(2), S(2));
		STAGE3: full_adder PORT MAP(C(2), X(3), TMP(3), COUT, S(3));
		
END LOGIC;