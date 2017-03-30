--Alejandra Rodriguez Sanchez Ing. en Computacion
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rd_bib.all;

entity tb_rutadatos is
end entity tb_rutadatos;

architecture beh of tb_rutadatos is
	component rutadatos is
	port(
		 clk: in std_logic; 			--senal del reloj
		amux: in std_logic; 			--selector de lectura del bus A
		bmux: in std_logic; 			--selector de lectura del bus B 
		cmux: in std_logic; 			--selector de escritua del bus C 
		 rdm: in std_logic; 			--selector de dato en el bus C 
		   a: in std_logic_vector(5 downto 0);	--registro que se escribira en el bus A
		   b: in std_logic_vector(5 downto 0);	--registro que se escribira en el bus B
		   c: in std_logic_vector(5 downto 0);	--registro al que se escribira del bus C
	       datom: in std_logic_vector(31 downto 0); --dato de la memoria
	           f: in std_logic_vector(3 downto 0);	--selector de operacion de la ALU
	       setcc:out std_logic;			--selector de codigos de condicion
	       bit13:out std_logic;			--bit 13, bit i
	          cc:out std_logic_vector(3 downto 0);	--codigos de condicion
	          op:out std_logic_vector(1 downto 0);	--codigo de operacion
		 op3:out std_logic_vector(5 downto 0);	--codigo op3
	        salm:out std_logic_vector(31 downto 0);	--dato de salida a memoria
	         dir:out std_logic_vector(31 downto 0)	--direccion de memoria	
	    );
	end component rutadatos;

		signal botonclk:std_logic:='0'; 		
		signal botonamux:std_logic; 	
		signal botonbmux:std_logic; 
		signal botoncmux:std_logic;
		signal botonrdm:std_logic;
		signal botona:std_logic_vector(5 downto 0);
		signal botonb:std_logic_vector(5 downto 0);
		signal botonc:std_logic_vector(5 downto 0);
	        signal botondatom:std_logic_vector(31 downto 0);
	        signal botonf:std_logic_vector(3 downto 0);
	        signal ledsetcc:std_logic;		
	        signal ledbit13:std_logic;	
	        signal ledcc:std_logic_vector(3 downto 0);
	        signal ledop:std_logic_vector(1 downto 0);
		signal ledop3:std_logic_vector(5 downto 0);	
	        signal ledsalm:std_logic_vector(31 downto 0);	
	        signal leddir:std_logic_vector(31 downto 0);

begin
	u0:rutadatos
	port map(
		 clk=>botonclk,
		amux=>botonamux,
		bmux=>botonbmux,
		cmux=>botoncmux,
		 rdm=>botonrdm,
		   a=>botona,
		   b=>botonb,
		   c=>botonc,
	       datom=>botondatom,
	           f=>botonf,
	       setcc=>ledsetcc,
	       bit13=>ledbit13,
	          cc=>ledcc,
	          op=>ledop,
		 op3=>ledop3,
	        salm=>ledsalm,
	         dir=>leddir
	    );

	process
	begin
		wait for 10 ns;
		botonclk<='1';
		wait for 10 ns;
		botonclk<='0';
	end process;

	process
	begin
		wait for 5 ns;
		botona<="000000";
	end process;

	process
	begin
		wait for 5 ns;
		botonb<="000000";
	end process;

	process
	begin
		wait for 5 ns;
		botonamux<='0';
		wait for 75 ns;
		botonamux<='1';
		wait for 15 ns;
	end process;
	
	process
	begin
		wait for 5 ns;
		botonbmux<='0';
		wait for 75 ns;
		botonbmux<='1';
		wait for 15 ns;
	end process;
	
	process
	begin
		wait for 5 ns;
		botoncmux<='0';
		wait for 75 ns;
		botoncmux<='1';
		wait for 15 ns;
	end process;

	process
	begin
		wait for 5 ns;
		botonrdm<='1';
		wait for 75 ns;
		botonrdm<='0';
		wait for 15 ns;
	end process;

	process
	begin
		wait for 5 ns;
		botonf<="0101";
		wait for 75 ns;
		botonf<="0000";
		wait for 15 ns;
	end process;

	process
	begin
		wait for 20 ns;
		botonc<="000001";
		wait for 15 ns;
		botonc<="000010";
		wait for 25 ns;
		botonc<="100101";
	end process;

	process
	begin
		wait for 20 ns;
		botondatom<="00000000000000000000000000000101";
		wait for 15 ns;
		botondatom<="00000000000000000000000000000001";
		wait for 25 ns;
		botondatom<="10000110100000000100000000000010";
	end process;



end architecture beh;

