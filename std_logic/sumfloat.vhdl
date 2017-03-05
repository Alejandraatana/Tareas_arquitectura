--Alejandra Rodriguez Sanchez Ing. en Computacion
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sumfloat is
	port(	
		  x: in std_logic_vector(0 downto 31);
		  y: in std_logic_vector(0 downto 31);
		res:out std_logic_vector(0 downto 31)
	    );
end entity sumfloat;
architecture beh of sumfloat is
signal   signox: std_logic;
signal     expx: std_logic_vector(0 downto 7);
signal mantizax: std_logic_vector(0 downto 23);
signal   signoy: std_logic;
signal     expy: std_logic_vector(0 downto 7);
signal mantizay: std_logic_vector(0 downto 23);

signal   resul: std_logic_vector(0 downto 31)="00000000000000000000000000000000";
begin
	process(x,y)
	begin
		signox<=x(0);
		signoy<=y(0);
		expox<=x(1 downto 8);
		expoy<=y(1 downto 8);
		mantizax<=('1' & x(9 downto 31));
		mantizay<=('1' & x(9 downto 31));
	end process;
	
end architecture beh;	
