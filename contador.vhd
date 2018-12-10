library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity contador is

   
   Port(

  		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_en : in STD_LOGIC;
		o_done : out STD_LOGIC
		
       );
end contador;

architecture	 Behavorial of contador is
	SIGNAL w_CONTAGEM	: STD_LOGIC_VECTOR(25 DOWNTO 0) := "00000000000000000000000000";
	SIGNAL w_CLEAR 	: STD_LOGIC;

		
	BEGIN
	PROCESS (i_CLK)
	BEGIN	
		IF FALLING_EDGE (i_CLK) THEN
			IF (i_RST = '0') THEN
				w_CLEAR    <= '0';
				o_done<='0';
			ELSE
		  IF (w_CONTAGEM = "10111110101111000010000000") THEN	
					w_CLEAR    <= '1';
					o_done<='1';
				ELSE
					w_CLEAR    <= '0';
					o_done<='0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	
	
			
	PROCESS (i_CLK)
	
	BEGIN	
		IF RISING_EDGE (i_CLK) THEN
			IF (i_RST = '0') THEN
				w_CONTAGEM <= (OTHERS => '0');
				
			ELSE
				IF (i_EN = '1') THEN
					IF (w_CLEAR = '1') THEN
						w_CONTAGEM <= (OTHERS => '0');
					
					ELSE
						w_CONTAGEM <= w_CONTAGEM + 1;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;			
	
		
		
end Behavorial;