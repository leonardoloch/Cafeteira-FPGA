library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity maquina is

   
   Port(

  		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_en : in STD_LOGIC;-- no caso ta sendo equivalendo ao botao prepara
		i_tipo_cafe : in STD_LOGIC_vector(2 downto 0);
		i_tipo_copo : in STD_LOGIC;
		i_acucar : in STD_LOGIC;				
		i_done : in std_logic; -- é aviso pelo contador que passou 1s
		i_trava : in std_logic; -- é avisado pela dispensa que acabou algum sache
		o_cont : out std_logic ;-- avisa o contador para começar a contar	
		
		o_display1 : out STD_LOGIC_vector(6 downto 0);
		o_display2  : out STD_LOGIC_vector(6 downto 0);
		o_display3 :out STD_LOGIC_vector(6 downto 0);
		o_display4  :out STD_LOGIC_vector(6 downto 0);
		
		o_led_tipo_cafe : out STD_LOGIC_vector(2 downto 0);
		o_led_acucar: out STD_LOGIC;
		o_led_copo : out std_logic ;
		
		o_dispensa :  out STD_LOGIC_vector(3 downto 0);	-- avisando que foi usado um sache
		o_saida : out STD_LOGIC_vector(4 downto 0)	--onde ligaria para fazer funcionar 
	
	
       );
end maquina;

architecture	 Behavorial of maquina is
	type w_state_Type is (st_idle,st_escolha_cafe,st_escolha_copo,st_escolha_acucar,st_done);
		attribute syn_enconding : string;
		attribute syn_enconding  of w_state_Type : type is "safe";
		signal w_state :   w_state_Type;
		signal w_saida : STD_LOGIC_vector(4 downto 0);
		signal w_dispensa : std_logic_vector(3 downto 0);
		signal cont : std_logic_vector(3 downto 0);
		signal w_led_acucar : std_logic;
		signal w_led_copo : std_logic;
		signal w_done : std_logic;
		signal w_led_cafe : std_logic_vector(2 downto 0);
		signal w_buffer : std_logic_vector(4 downto 0);
		
		
		
		
		
	
begin
		-- led vao ir direto da entrada , logo que a chave for modificada o led ja mudara de estado
		w_led_acucar<=i_acucar;
		w_led_copo<=i_tipo_copo;
		w_led_cafe<=i_tipo_cafe;
		
		
		u_machine : process(i_clk,i_rst)
		variable cont : integer := 0;
		begin
			
			if (i_rst='0') then--inicializando sinais
				cont:=0;
				o_dispensa<="0000";--inicializando com o mesmo valor que na dispensa
				w_saida<=(others=>'0');
				w_state<=st_idle;	--estado inicial ,o de espera			
				o_saida <="00000";
				o_display1<="0000000";
				o_display2<="0000000";
				o_display3<="0000000";
				o_display4<="0000000";				
				w_buffer<="00000";--uma vez lido a entrada e validado a maquina vai produzir o cafe que foi selecionado msm o usuario mudar
			elsif rising_edge(i_clk) then
				case w_state is
					when st_idle =>
						o_display4<="1000000";
						o_display3<="1000111";
						o_display2<="0001000";
						o_display1<="1111111";	
						if (i_en='0' and i_trava='0') then 
							if (i_tipo_cafe="100" or i_tipo_cafe="010" or i_tipo_cafe="001") then
										w_buffer(0)<=i_tipo_cafe(0);-- a maquina nao vai ler a entrada e sim um buffer da ultima entrada 
										w_buffer(1)<=i_tipo_cafe(1);
										w_buffer(2)<=i_tipo_cafe(2);
										w_buffer(3)<=i_tipo_copo;
										w_buffer(4)<=i_acucar;										
										o_display1<="1001110";
										o_display2<="1111001";
										o_display3<="0001000";
										o_display4<="1000001";
										w_state <=st_escolha_cafe;	
							end if;
						end if;
				  when st_escolha_cafe =>
						
						if (w_buffer(0)='1') then 
							w_done<='1';
							w_saida(4) <='1';
								if (i_done='1') then
									cont :=0;	
									w_done<='0';	
									w_saida(4) <='0';
									if (w_dispensa(3)='1')then
										w_dispensa(3)<='0';
									else w_dispensa(3)<='1';
									end if;
									w_state <=st_escolha_copo;
								end if;
													
						elsif(w_buffer(1)='1') then 
							w_saida(3) <='1';
							
							w_done<='1';							
							if (i_done='1') then
								cont:=cont+1;
								if(cont=2) then
									cont :=0;
									w_done<='0';	
									
									w_saida(3)<='0';	
									if (w_dispensa(2)='1')then
										w_dispensa(2)<='0';
									else w_dispensa(2)<='1';
									end if;
									w_state <=st_escolha_copo;
								end if;
							end if;
						
						elsif(w_buffer(2)='1') then 
							w_saida(2) <='1';
							
							w_done<='1';							
							if (i_done='1') then
								cont:=cont+1;
								if(cont=3) then
									cont :=0;
									w_done<='0';	
									
									w_saida(2)<='0';	
									if (w_dispensa(1)='1')then
										w_dispensa(1)<='0';
									else w_dispensa(1)<='1';
									end if;
									w_state <=st_escolha_copo;
								end if;
							end if;					
						end if;
							  
					
					when st_escolha_copo =>
						if (w_buffer(3)='1') then
							w_saida(1) <='1';
							w_done<='1';
							
							if (i_done='1') then
								cont :=cont+1;
								
								if(cont=10) then 
									w_done<='0';
									cont:=0;
									
									w_saida(1)<='0';
									w_state<=st_escolha_acucar;
								end if;
							end if;
							
						else
							w_saida(1) <='1';
							w_done<='1';
							
							if (i_done='1') then
								cont :=cont+1;
								
								if(cont=8) then 
									
									w_done<='0';
									cont:=0;
									w_saida(1)<='0';
									w_state<=st_escolha_acucar;
								end if;
							end if;
						end if;
					when st_escolha_acucar =>
						if (w_buffer(4)='1') then
							w_saida(0) <='1';
							w_done<='1';
							
							if (i_done='1') then
								cont :=0;
								
								if (w_dispensa(0)='1')then
											w_dispensa(0)<='0';
								else w_dispensa(0)<='1';
								end if;		
							
											w_done<='0';
											w_state <=st_done;
										
									
							end if;	
						
						else		
							w_state <=st_done;	
						end if;
					when st_done=>
									
								o_display4<="0100001";
								o_display3<="1000000";
								o_display2<="1001000";
								o_display1<="0000110";
								w_done<='1';
							
									if (i_done='1') then
										cont :=cont+1;
										if(cont=2) then
											cont:=0;	
											w_done<='0';
											w_state <=st_idle;
										end if;
									end if;
					when others =>
						w_state <=st_idle;
				end case;
				o_dispensa<=w_dispensa;
				o_saida<=w_saida;
			end if;			
		end process u_machine;	
		
		led :process(i_clk,i_rst)
		begin
			if (i_rst='0') then
				o_led_acucar<='1';
				o_led_tipo_cafe<="111";
				o_led_copo<='1';
			elsif rising_edge(i_clk) then
					if (w_led_acucar='1') then 
						o_led_acucar<='1';
					else
						o_led_acucar<='0';
					end if;
					
					if (w_led_cafe(2)='1') then 
						o_led_tipo_cafe(2)<='1';
					else 
						o_led_tipo_cafe(2)<='0';
					end if;
					
					if (w_led_cafe(1)='1') then 
						o_led_tipo_cafe(1)<='1';
					else 
						o_led_tipo_cafe(1)<='0';
					end if;
					
					if (w_led_cafe(0)='1') then 
						o_led_tipo_cafe(0)<='1';
					else 
						o_led_tipo_cafe(0)<='0';
					end if;
					
					if (w_led_copo='1') then 
						o_led_copo<='1';
					else 
						o_led_copo<='0';
					end if;
				end if;
			end process led;
			
	o_cont<=w_done;
		
	
		
		
end Behavorial;