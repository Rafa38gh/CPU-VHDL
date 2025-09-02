LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE half_adder_package IS
	COMPONENT half_adder
		PORT
		(
			X		:	 IN STD_LOGIC;
			Y		:	 IN STD_LOGIC;
			COUT		:	 OUT STD_LOGIC;
			S		:	 OUT STD_LOGIC
		);
	END COMPONENT;
END PACKAGE;