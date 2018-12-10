library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity cafeteira is

   
   Port(

  		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_en : in STD_LOGIC;
		i_reposicao : in STD_LOGIC;--botao para indicar q a reposicao foi feita
		i_tipo_cafe : in STD_LOGIC_vector(2 downto 0);
		i_tipo_copo : in STD_LOGIC;
		i_acucar : in STD_LOGIC;
		
		i_sensor_temp :in STD_LOGIC;-- sensor de temperatura
		o_resistecia_led : out std_logic;-- caso a temperatura nao for igual a 90 graus o led acende 
		
		----------------------display 7 segmentos------------
		o_display1 : out STD_LOGIC_vector(6 downto 0);	
		o_display2 : out STD_LOGIC_vector(6 downto 0);
		o_display3 : out STD_LOGIC_vector(6 downto 0);	
		o_display4 : out STD_LOGIC_vector(6 downto 0);
		------------------------leds--------------------------
		o_led_aviso : out STD_LOGIC;
		o_led_tipo_cafe : out STD_LOGIC_vector(2 downto 0);
		o_led_acucar: out STD_LOGIC;
		o_saida : out STD_LOGIC_vector(4 downto 0)	;
		o_led_copo : out std_logic 
		
       );
end cafeteira;

architecture	 Behavorial of cafeteira is
	component maquina is

   
   Port(

  		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_en : in STD_LOGIC;
		i_tipo_cafe : in STD_LOGIC_vector(2 downto 0);
		i_tipo_copo : in STD_LOGIC;
		i_acucar : in STD_LOGIC;		
		i_done : in std_logic;
		i_trava : in std_logic;
		o_cont : out std_logic ;		
		o_display1 : out STD_LOGIC_vector(6 downto 0);
		o_display2  : out STD_LOGIC_vector(6 downto 0);
		o_display3 :out STD_LOGIC_vector(6 downto 0);
		o_display4  :out STD_LOGIC_vector(6 downto 0);
		o_led_tipo_cafe : out STD_LOGIC_vector(2 downto 0);
		o_led_acucar: out STD_LOGIC;
		o_led_copo : out std_logic ;
		o_dispensa :  out STD_LOGIC_vector(3 downto 0);	
		o_saida : out STD_LOGIC_vector(4 downto 0)	
		
       );
end component;
component contador is   
   Port(
  		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_en : in STD_LOGIC;
		o_done : out STD_LOGIC
		
       );
end component;
component dispensa is   
   Port(
  		i_dispensa : in STD_LOGIC_vector(3 downto 0);
		i_rst : in STD_LOGIC;
		i_reposicao : in STD_LOGIC;
		o_led_aviso : out STD_LOGIC	;
		i_clk : in std_LOGIC;
		o_aviso : out STD_LOGIC	
       );
end component;
 signal w_done : std_LOGIC;
 signal w_cont : std_LOGIC;
 signal w_trava : std_LOGIC;
 signal w_sensor_temp : std_LOGIC;
 signal w_1dispensa : STD_LOGIC_vector(3 downto 0);
 

begin
		
		
		u01: contador    
			Port map(

  		i_clk =>i_clk,
		i_rst =>i_rst,
		i_en =>w_cont,
		o_done =>w_done
		
       );
		u02: Maquina   
   Port map(
  		i_clk =>i_clk,
		i_rst =>i_rst,
		i_en =>i_en,
		i_tipo_cafe=>i_tipo_cafe,
		i_tipo_copo =>i_tipo_copo,
		i_acucar =>i_acucar,			
		i_done =>w_done,
		i_trava =>w_trava,
		o_cont =>w_cont,
		o_display1 =>o_display1,
		o_display2  =>o_display2,
		o_display3 =>o_display3,
		o_display4  =>o_display4,
		o_dispensa=>w_1dispensa,
		o_saida =>o_saida,
		o_led_tipo_cafe =>o_led_tipo_cafe,
		o_led_acucar=>o_led_acucar,
		o_led_copo =>o_led_copo
		
		
		
       );
    u03: dispensa  
   Port map(
  		i_dispensa=>w_1dispensa,
		i_rst =>i_rst,
		i_reposicao=>i_reposicao,
		i_clk=>i_clk,
		o_led_aviso=>o_led_aviso,
		o_aviso =>w_trava
       );
		 
	w_sensor_temp<=i_sensor_temp;
	o_resistecia_led<=w_sensor_temp;-- caso o sensor retorna um valor menor de 90 grau o led vai ligar 
		
end Behavorial;