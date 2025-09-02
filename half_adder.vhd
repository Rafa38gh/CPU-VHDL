-- Half adder de 2 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY half_adder IS
	PORT (X, Y		:		IN STD_LOGIC;
			COUT, S	:		OUT STD_LOGIC);
END half_adder;

ARCHITECTURE LOGIC OF half_adder IS
	BEGIN
		S <= X XOR Y;
		COUT <= X AND Y;
END LOGIC;