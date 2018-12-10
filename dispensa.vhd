library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity dispensa is

   
   Port(

  		i_dispensa : in STD_LOGIC_vector(3 downto 0);
		i_rst : in STD_LOGIC;
		i_reposicao : in STD_LOGIC;
		i_clk : in STD_LOGIC;
		o_led_aviso : out std_LOGIC;
		o_aviso : out STD_LOGIC	
       );
end dispensa;

architecture	 Behavorial of dispensa is
	
	
	signal w_dispensa : STD_LOGIC_vector(3 downto 0);
begin
		
		process(i_rst,i_reposicao,i_clk)
			variable cont_cafe : integer := 10;
			variable cont_leite : integer := 10;
			variable cont_chocolate : integer := 10;
			variable cont_acucar : integer := 10;
			begin
				if(i_rst='0') then
					cont_cafe:=10;
					cont_leite:=10;
					cont_chocolate:=10;
					cont_acucar:=10;	
					o_led_aviso<='0';
					o_aviso<='0';
					w_dispensa<="0000";					
				elsif rising_edge(i_clk) then
						if (w_dispensa(3)=(not i_dispensa(3)))then
							cont_cafe:=cont_cafe-1;
							w_dispensa(3)<=i_dispensa(3);	
						end if;
						if (w_dispensa(2)=(not i_dispensa(2)))then
										w_dispensa(2)<=i_dispensa(2);
										cont_cafe:=cont_cafe-1;
										cont_leite:=cont_leite-1;
						end if;
						if (w_dispensa(1)=(not i_dispensa(1)))then
								w_dispensa(1)<=i_dispensa(1);
								cont_cafe:=cont_cafe-1;
								cont_leite:=cont_leite-1;
								cont_chocolate:=cont_acucar-1;
						end if;
						if (w_dispensa(1)=(not i_dispensa(1)))then
								cont_acucar:=cont_acucar - 1;
								w_dispensa(0)<=i_dispensa(0);
								
						end if;			
				
						if(cont_cafe=0) then
							if(i_reposicao='0')then
								cont_cafe:=10;	
								o_aviso<='0';
								o_led_aviso<='0';	
							else
								o_aviso<='1';
								o_led_aviso<='1';
							end if;	
						end if;
						if(cont_leite=0) then
							if(i_reposicao='0')then
								cont_leite:=10;	
								o_aviso<='0';
								o_led_aviso<='0';	
							else
								o_aviso<='1';
								o_led_aviso<='1';
							end if;	
						end if;
						if(cont_chocolate=0) then
							if(i_reposicao='0')then
								cont_chocolate:=10;	
								o_aviso<='0';
								o_led_aviso<='0';	
							else
								o_aviso<='1';
								o_led_aviso<='1';
							end if;	
						end if;
						if(cont_acucar=0) then
							if(i_reposicao='0')then
								cont_acucar:=10;	
								o_aviso<='0';
								o_led_aviso<='0';	
							else
								o_aviso<='1';
								o_led_aviso<='1';
							end if;	
						end if;				
						
			  end if;			
		end process;
		
end Behavorial;