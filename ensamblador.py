#!/usr/bin/env python3
#Alejandra Rodriguez Sanchez Ing. en Computacion

import sys
import arclib as ale

if __name__ == '__main__':
    archivo=sys.argv[1]
    direccion=ale.buscaMacrosOrg(archivo,ale.macros,ale.mne,ale.tabSim)
    ale.preprocesoTemporal(archivo,'ppan.txt',ale.macros)
    f=open('ppan.txt',"r")
    e=open('ensamblado',"w")
    for linea in f:
        linea=ale.sepLin(linea)
        linea=ale.quiCom(linea)
        op,indice=ale.formato(linea,ale.mne,ale.tabSim,direccion)
        asm=ale.ensamblado(op,linea,indice,ale.mne,ale.tabSim,direccion,ale.registros)
        e.write(asm+'\n')
    f.close()
    e.close()
