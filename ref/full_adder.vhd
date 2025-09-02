-- Full adder de 1 bit --

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
	PORT (CIN, X, Y	:	IN STD_LOGIC;		-- CIN controla a operação
			COUT, S		:	OUT STD_LOGIC);
END full_adder;

ARCHITECTURE LOGIC OF full_adder IS
	BEGIN
		S <= CIN XOR (X XOR Y);		-- Inverte Y baseado em CIN
		COUT <= (X AND Y) OR (X AND CIN) OR (Y AND CIN);
END LOGIC;