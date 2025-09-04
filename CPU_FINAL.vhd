LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.CPU_package.all;

ENTITY CPU_FINAL IS
	PORT (SW		:		IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			Clock_50	:	IN STD_LOGIC;
			HEX3		:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX2		:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX1		:	OUT STD_LOGIC_VECTOR(0 TO 6);
			HEX0		:	OUT STD_LOGIC_VECTOR(0 TO 6);
			LEDG8		:	OUT STD_LOGIC);
END CPU_FINAL;

ARCHITECTURE LOGIC OF CPU_FINAL IS
	SIGNAL ENABLE		:		STD_LOGIC;
	SIGNAL OPREG		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL OPCODE		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL DATA			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL CLEAR		:		STD_LOGIC;
	SIGNAL R1			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R2			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R3			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R4			:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL OVERFLOW	:		STD_LOGIC;
	
	BEGIN
		
		-- ENABLE --
		ENABLE <= SW(17);
		
		-- OPREG --
		OPREG(0) <= SW(9);
		OPREG(1) <= SW(10);
		OPREG(2) <= SW(11);
		OPREG(3) <= SW(12);
		
		-- OPCODE --
		OPCODE(0) <= SW(5);
		OPCODE(1) <= SW(6);
		OPCODE(2) <= SW(7);
		OPCODE(3) <= SW(8);
		
		-- DATA --
		DATA(0) <= SW(0);
		DATA(1) <= SW(1);
		DATA(2) <= SW(2);
		DATA(3) <= SW(3);
		
		-- CLEAR --
		CLEAR <= SW(16);
		
		-- OVERFLOW --
		LEDG8 <= OVERFLOW;
		
--=====================================================================

		-- CPU --
		CPUFINAL: CPU PORT MAP(Clock_50, ENABLE, OPREG, OPCODE, DATA, CLEAR, R1, R2, R3, R4, OVERFLOW);
		
--=====================================================================

		-- DISPLAY --
		WITH R1 SELECT
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
			
		WITH R2 SELECT
			HEX2 <= 	"0000001" when "0000",
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
		
		WITH R3 SELECT
			HEX1 <= 	"0000001" when "0000",
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
						
		WITH R4 SELECT
			HEX0 <= 	"0000001" when "0000",
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