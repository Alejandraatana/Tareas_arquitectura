#Alejandra Rodriguez Sanchez Ing. en Computacion
all:tb_rutadatos

tb_rutadatos:rd_bib.o rutadatos.o tb_rutadatos.o
	ghdl -e --ieee=synopsys tb_rutadatos 
	./tb_rutadatos --stop-time=200ns --vcd=tb_rutadatos.vcd
	gtkwave tb_rutadatos.vcd ondas.sav	
rd_bib.o:rd_bib.vhdl
	ghdl -a --ieee=synopsys rd_bib.vhdl

rutadatos.o:rutadatos.vhdl
	ghdl -a --ieee=synopsys rutadatos.vhdl

tb_rutadatos.o:tb_rutadatos.vhdl
	ghdl -a --ieee=synopsys tb_rutadatos.vhdl

clean:
	rm *.o tb_rutadatos *.vcd *.cf
