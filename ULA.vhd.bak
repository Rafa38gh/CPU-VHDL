-- ULA Completa --
-- Realiza operações com base no opcode recebido --

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.ripple_carry_package.all;
USE work.mult_package.all;
USE work.comp_package.all;

ENTITY ULA IS
	PORT (OPCODE		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Controla a operação a ser realizada --
			A, B			:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			S				:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			OVERFLOW		:		OUT STD_LOGIC);
END ULA;

ARCHITECTURE LOGIC OF ULA IS
	-- Sinais do ripple carry --
	SIGNAL CIN			:		STD_LOGIC;
	SIGNAL X, Y, RS	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL COUT			:		STD_LOGIC;
	
	-- Sinais do multiplicador --
	SIGNAL MA, MB		:		STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL P				:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Sinais do comparador --
	SIGNAL CA, CB, CS	:		STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	
	BEGIN
		-- Instâncias --
		SUMSUB: ripple_carry PORT MAP(CIN, X, Y, RS, COUT);
		MULTI: mult PORT MAP(MA, MB, P);
		COM: comp PORT MAP(CA, CB, CS);
		
		PROCESS(OPCODE, A, B, RS, COUT, CS, P)
		BEGIN
			IF OPCODE = "0001" THEN
				S <= A AND B;
			
			ELSIF OPCODE = "0010" THEN
				S <= A OR B;
				
			ELSIF OPCODE = "0011" THEN
				S <= NOT B;
				
			ELSIF (OPCODE = "0100") OR (OPCODE = "0101") THEN
				CIN <= OPCODE(0);
				X <= A;
				Y <= B;
				S <= RS;
				OVERFLOW <= COUT;
				
			ELSIF OPCODE = "0110" THEN
				MA(0) <= A(0);
				MA(1) <= A(1);
				MB(0) <= B(0);
				MB(1) <= B(1);
				S	<= P;
				
			ELSIF OPCODE = "0111" THEN
				CA <= A;
				CB <= B;
				S	<= CS;
			
			END IF;
		END PROCESS;			
		
END LOGIC;