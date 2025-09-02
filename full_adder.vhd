-- Full adder de 2 bits --

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
	PORT (CIN, X, Y	:		IN STD_LOGIC;		
			COUT, S		:		OUT STD_LOGIC);
END full_adder;

ARCHITECTURE LOGIC OF full_adder IS
	BEGIN
		S <= CIN XOR (X XOR Y);						
		COUT <= (X AND Y) OR (X AND CIN) OR (Y AND CIN);
END LOGIC;