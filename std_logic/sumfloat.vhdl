--Alejandra Rodriguez Sanchez Ing. en Computacion
entity sumfloat is
	port(
		clk: in std_logic;
		  x: in std_logic_vector(0 downto 31);
		  y: in std_logic_vector(0 downto 31);
		res:out std_logic_vector(0 downto 31)
	    );
end entity sumfloat;
architecture beh of sumfloat is
signal   signo: std_logic;
signal     exp: std_logic_vector(0 downto 7);
signal mantiza: std_logic_vector(0 downto 23);
signal   resul: std_logic_vector(0 downto 31)="00000000000000000000000000000000";
begin
	
end architecture beh;	
