LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.CPU_package.all;

ENTITY CPU_FINAL IS
	PORT (SW		:	IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			Clock_50	:	IN STD_LOGIC;
			HEX6	:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX4	:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX3	:	OUT STD_LOGIC_VECTOR(0 TO 6));
END CPU_FINAL;

ARCHITECTURE LOGIC OF CPU_FINAL IS
	SIGNAL DATA		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL F			:	STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL RESET	:	STD_LOGIC;
	SIGNAL ENABLE	:	STD_LOGIC;
	
	SIGNAL REG1_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);		-- O valor do registrador R1 será mostrado no display HEX6 --
	SIGNAL REG2_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);		-- O valor do registrador R2 será mostrado no display HEX4 --
	SIGNAL REG3_OUT	:	STD_LOGIC_VECTOR(3 DOWNTO 0);		-- O valor do registrador R3 será mostrado no display HEX3 --
	
BEGIN

	-- DATA --
	DATA(3) <= SW(3);
	DATA(2) <= SW(2);
	DATA(1) <= SW(1);
	DATA(0) <= SW(0);
	
	-- FUNCTION --
	F(2) <= SW(6);
	F(1) <= SW(5);
	F(0) <= SW(4);
	
	-- ENABLE --
	ENABLE <= SW(7);
	
	-- RESET --
	RESET <= SW(8);
	
--=============================================================
	-- CPU --
	CPUFINAL: CPU PORT MAP(DATA => DATA, CLK => Clock_50, ENABLE => ENABLE, RESET => RESET, F => F, REG1_OUT => REG1_OUT, REG2_OUT => REG2_OUT, REG3_OUT => REG3_OUT);

--=============================================================
	-- DISPLAY --
	WITH REG1_OUT SELECT
	
		HEX6 <= 	"0000001" when "0000",
					"1001111" when "0001",
					"0010010" when "0010",
					"0000110" when "0011",
					"1001100" when "0100",
					"0100100" when "0101",
					"0100000" when "0110",
					"0001111" when "0111",
					"0000000" when "1000",
					"0000100" when "1001",
					"0001000" when "1010",
					"1100000" when "1011",
					"0110001" when "1100",
					"1000010" when "1101",
					"0110000" when "1110",
					"0111000" when "1111",
					"1111111" when others;
					
	WITH REG2_OUT SELECT
	
		HEX4 <= 	"0000001" when "0000",
					"1001111" when "0001",
					"0010010" when "0010",
					"0000110" when "0011",
					"1001100" when "0100",
					"0100100" when "0101",
					"0100000" when "0110",
					"0001111" when "0111",
					"0000000" when "1000",
					"0000100" when "1001",
					"0001000" when "1010",
					"1100000" when "1011",
					"0110001" when "1100",
					"1000010" when "1101",
					"0110000" when "1110",
					"0111000" when "1111",
					"1111111" when others;
					
	WITH REG3_OUT SELECT
	
		HEX3 <= 	"0000001" when "0000",
					"1001111" when "0001",
					"0010010" when "0010",
					"0000110" when "0011",
					"1001100" when "0100",
					"0100100" when "0101",
					"0100000" when "0110",
					"0001111" when "0111",
					"0000000" when "1000",
					"0000100" when "1001",
					"0001000" when "1010",
					"1100000" when "1011",
					"0110001" when "1100",
					"1000010" when "1101",
					"0110000" when "1110",
					"0111000" when "1111",
					"1111111" when others;

	
END LOGIC;