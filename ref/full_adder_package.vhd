LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE full_adder_package IS
	COMPONENT full_adder
		PORT
		(
			CIN		:	 IN STD_LOGIC;
			X		:	 IN STD_LOGIC;
			Y		:	 IN STD_LOGIC;
			COUT		:	 OUT STD_LOGIC;
			S		:	 OUT STD_LOGIC
		);
	END COMPONENT;
END PACKAGE;