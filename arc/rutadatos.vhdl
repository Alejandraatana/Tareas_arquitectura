--Alejandra Rodriguez Sanchez Ing. en Computacion
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rd_bib.all;

entity rutadatos is
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
end entity rutadatos;

architecture beh of rutadatos is
component registro is
	port(
		clk: in std_logic;
      		datol: in std_logic_vector(31 downto 0); --Lee el dato solo del bus C
      		esca: in std_logic; 			 --1 si el registro escribira en el bus A 
      		escb: in std_logic; 			 --1 si el registro escribira en el bus B
      		leec: in std_logic; 			 --1 si el registro toma el valor del bus C
      		sala:out std_logic_vector(31 downto 0);	 --dato a escribir en el bus A
      		salb:out std_logic_vector(31 downto 0)	 --dato a escribir en el bus B
	    );
end component registro;

component alu is
       port(
       		  a: in std_logic_vector(31 downto 0);	--operando 1 del bus A
       		  b: in std_logic_vector(31 downto 0);	--operando 2 del bus B
		  f: in std_logic_vector(3 downto 0);	--operacion a realizar
		res:out std_logic_vector(31 downto 0);	--resultado de la operacion
		ban:out std_logic_vector(3 downto 0);	--banderas
       		 cc:out std_logic			--codigos de operacion
	   );
end component alu;

signal   sela:std_logic_vector(37 downto 0);	--registro seleccionado para escribir en el bus A
signal   selb:std_logic_vector(37 downto 0);	--registro seleccionado para escribir en el bus B
signal   selc:std_logic_vector(37 downto 0);	--registro seleccionado para escribir en el bus C
signal   busA:std_logic_vector(31 downto 0);	--bus A
signal   busB:std_logic_vector(31 downto 0);	--bus B
signal   busC:std_logic_vector(31 downto 0);	--bus C
signal   cero:std_logic_vector(31 downto 0):="00000000000000000000000000000000"; --ceros para llenar el registro 0
signal  valir:std_logic_vector(31 downto 0);	--valor del registro ir
signal resalu:std_logic_vector(31 downto 0);	--resultado de la ALU

begin
	sela<=deco6a38(mux(a,'0'&valir(18 downto 14),amux));	--valor del registro seleccionado para escribir en el bus A
	selb<=deco6a38(mux(b,'0'&valir(4 downto 0),bmux));	--valor del registro seleccionado para escribir en el bus B 
	selc<=deco6a38(mux(c,'0'&valir(29 downto 25),cmux));	--valor del registro seleccionado para leer del bus C
	
	op<=valir(31 downto 30);
        op3<=valir(24 downto 19);
        bit13<=valir(13);
	salm<=busB;
	dir<=busA;

	reg0:registro	--alambra el registro 0 
	port map(
		clk=>clk,
      		datol=>cero,
      		esca=>sela(0),
      		escb=>selb(0),
      		leec=>'0',
      		sala=>busA,
      		salb=>busB
	    );

	registros:for i in 1 to 36 generate	--alambra del registro 1 al 36
	        reg:registro	
         	port map(
			clk=>clk,
      			datol=>busC,
      			esca=>sela(i),
      			escb=>selb(i),
      			leec=>selc(i),
      			sala=>busA,
      			salb=>busB
	    		);
        end generate registros;

	reg37ir:registro
		port map(
		clk=>clk,
      		datol=>busC,
      		esca=>sela(37),
      		escb=>selb(37),
      		leec=>selc(37),
      		sala=>busA,
      		salb=>busB
	    );

	    process(selc(37))
	    begin
		if selc(37) = '1' then
		    valir<=busC;
		end if;
	    end process;

	    alu0:alu	--Instancia de la ALU
	    port map(
       		  a=>busA,
       		  b=>busB,
		  f=>f,
		res=>resalu,
		ban=>cc,
       		 cc=>setcc
	   );

	   process(resalu,datom,rdm)
	   begin
		if rdm='1' then
			busC<=datom;
		else
			busC<=resalu;
		end if;
	   end process;
end architecture beh;
