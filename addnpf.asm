!Alejandra Rodriguez Sanchez Ing. Computacion
	.begin
	.org 2048
main:	ld [x], %r1  		!carga de operando 1
	ld [y], %r2		!carga de operando 2
	ld [mase], %r3		!carga de mascara para exponente
	ld [masm], %r4		!carga de mascara para mantiza
	ld [biti], %r5		!carga de mascara para bit implicito
	srl %r1, 31, %r6	!separacion de signo, op1
	srl %r2, 31, %r7	!separacion de signo, op2
	andcc %r3, %r1, %r8	!separacion del exponente, op1
	srl %r8, 23, %r8	!colocacion del exponente en la parte mas baja
	andcc %r3, %r2, %r9	!separacion del exponente, op2
	srl %r9, 23, %r9	!colocacion del exponente en la parte mas baja
	andcc %r4, %r1, %r10	!separacion de la mantiza, op1
	orcc %r10, %r5, %r10	!clocacion del bit implicito
	andcc %r4, %r2, %r11	!separacion de la mantiza, op2
	orcc %r11, %r5, %r11	!colocacion del bit implicito
	orncc %r0,%r8, %r12	!complemento a 1 del exponente del op1 
	addcc %r12, 1, %r12	!complemento a 2 del exponente del op1 
	ld [nega], %r16		!carga los 8 bits correspondientes al signo extendido
	ld [sig], %r17		!carga un -1 para identificar si algun operando es negativo
	addcc %r9,%r12,%r13	!diferencia de exponentes, exp2-exp1
	bneg diferencia2	!salta si el resultado de la resta es negativo
	srl %r10, %r13, %r10	!corrimiento de la mantiza, op1	
	addcc %r17, %r6, %r0	!identificacion del signo del op1
	be op1nega		!salta si el signo del op1 es negativo
	addcc %r17, %r7, %r0	!identificacion del signo del op2
	be op2nega		!salta si el signo del op2 es negativo 
	addcc %r10, %r11, %r18	!suma de mantizas
	jmpl %r15+4, %r0	!return
diferencia2:  			
	orncc %r0,%r9,%r12 	!complemento a 1 del exponente del op2
	addcc %r12, 1, %r12	!complemento a 2 del exponente del op2 
	addcc %r8, %r12, %r13	!diferencia de exponentes, exp1-exp2
	srl %r11, %r13, %r11	!corrimiento de la mantiza, op2
	addcc %r17, %r6, %r0	!identificacion del signo del op1
	be op1nega		!salta si el signo del op1 es negativo
	addcc %r17, %r7, %r0	!identificacion del signo del op2
	be op2nega		!salta si el signo del op2 es negativo 
	addcc %r10, %r11, %r18	!suma de mantizas
	jmpl %r15+4, %r0	!return 
op1nega:
	orncc %r0, %r10, %r10	!mantiza del op1 en complemento a 1
	addcc %r10, 1, %r10	!mantiza del op1 en complemento a 2
	orcc %r16, %r10,%r10	!extencion de signo 
	addcc %r17, %r7, %r0	!identificacion de signo del op2
	be op2nega		!salta si el signo del op2 es negativo
	addcc %r10,%r11,%r18	!suma de mantizas
	jmpl %r15+4, %r0	!return 
op2nega:
	orncc %r0, %r11, %r11	!mantiza del op2 en complemento a 1
	addcc %r11, 1, %r11	!mantiza del op2 en complemento a 2
	orcc %r16, %r11, %r11 	!extencion de signo
	addcc %r10, %r11, %r18	!suma de mantizas
	jmpl %r15+4, %r0	!return 
	x: 0x40A00000
	y: 0xBF400000
	mase: 0x7F800000
	masm: 0x007FFFFF
	biti: 0x00800000
	sig: 0xFFFFFFFF
	nega: 0xFF000000 	
	.end
