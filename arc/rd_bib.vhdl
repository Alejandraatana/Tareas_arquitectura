--Alejandra Rodriguez Sanchez Ing. en Computacion
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rd_bib is
	function mux(mir,ir:std_logic_vector(5 downto 0);sel:std_logic)return std_logic_vector;
	function deco6a38(reg:std_logic_vector(5 downto 0))return std_logic_vector;
end package rd_bib;

package body rd_bib is
	function mux(mir,ir:std_logic_vector(5 downto 0);sel:std_logic)return std_logic_vector is
		variable salida:std_logic_vector(5 downto 0);
	begin
		if sel='1' then
		   salida:=ir;
	   	elsif sel='0' then
	     	   salida:=mir;		
		end if;
		return salida;
	end function mux;

	function deco6a38(reg:std_logic_vector(5 downto 0))return std_logic_vector is
		variable num_reg:std_logic_vector(37 downto 0);
		variable pos:integer;
	begin
		pos:=TO_INTEGER(unsigned(reg));
		if pos > 37 then
			pos:=0;
		end if;
		num_reg:="00000000000000000000000000000000000000";
		num_reg(pos):='1';
		return num_reg;
	end function deco6a38;

end package body rd_bib;	
