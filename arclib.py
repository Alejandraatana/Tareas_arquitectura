#Alejandra Rodriguez Sanchez Ing. en Computacion

mne={'ld':('11','000000'),'st':('11','000100'),'sethi':('00','100'),'andcc':('10','010001'),'orcc':('10','010010'),'orncc':('10','010110'),'srl':('10','100110'),'addcc':('10','010000'),'call':('01',''),'jmpl':('10','111000'),'be':('00','0001'),'bneg':('00','0110'),'bcs':('00','0101'),'bvs':('00','0111'),'ba':('00','1000')}
registros={
        '%r0':'00000',
        '%r1':'00001',
        '%r2':'00010',
        '%r3':'00011',
        '%r4':'00100',
        '%r5':'00101',
        '%r6':'00110',
        '%r7':'00111',
        '%r8':'01000',
        '%r9':'01001',
        '%r10':'01010',
        '%r11':'01011',
        '%r12':'01100',
        '%r13':'01101',
        '%r14':'01110',
        '%r15':'01111',
        '%r16':'10000',
        '%r17':'10001',
        '%r18':'10010',
        '%r19':'10011',
        '%r20':'10100',
        '%r21':'10101',
        '%r22':'10110',
        '%r23':'10111',
        '%r24':'11000',
        '%r25':'11001',
        '%r26':'11010',
        '%r27':'11011',
        '%r28':'11100',
        '%r29':'11101',
        '%r30':'11110',
        '%r31':'11111'
        }
tabSim={}
macros={}
def sepLin(linea):
    '''
    Separa la linea y regresa una lista 
    '''
    linea=linea.lower()
    linea=linea.replace(',',' ')
    linea=linea.split()
    return linea

def quiCom(linea):
    '''
    Quita los comentarios
    '''
    comentario=None
    for palabra in linea:
        if palabra.startswith('!'):
            comentario=palabra
            break
    if comentario != None:
        linea=linea[:linea.index(comentario)]
    return linea

def eti(linea,mne,tabSim,direccion):
    '''
    Verifica si hay una etiqueta
    '''
    etiqueta=linea[0].strip(':')
    if etiqueta in mne.keys():
        return False
    if etiqueta in tabSim.keys():
        return True
    else:
        tabSim[etiqueta]=direccion
        return True

def calDes(dirAct,etiqueta,tabSim):
    '''
    Calcula el desplazamiento 
    '''
    if dirAct < tabSim[etiqueta]:
        return tabSim[etiqueta]-dirAct
    else:
        return dirAct-tabSim[etiqueta]

def formato(linea,mne,tabSim,direccion):
    '''
    Devuelve el tipo de formato, op 
    '''
    op=None
    otro=None
    
    if eti(linea,mne,tabSim,direccion):
        op,otro=mne[linea[1]]
        return (op,1)
    else:
        op,otro=mne[linea[0]]
        return (op,0)

def decSalto(linea,mne,tabSim,direccion,indice):
    '''
    decodifica instrucciones de salto
    '''
    op, cond = mne[linea[indice]]
    op2='010'
    dis=calDes(direccion,linea[indice+1],tabSim)
    diss=bin(dis)[2:]
    return hex(direccion)[2:]+' '+op+'0'+cond+op2+diss

def decSethi(linea,mne,tabSim,direccion,indice,registros):
    '''
    decodifica instrucciones de sethi
    '''
    op, op2 = mne[linea[indice]]
    rd=registros[linea[indice+1]]
    imm=int(linea[indice+2])
    diss=bin(imm)[2:]
    return hex(direccion)[2:]+' '+op+rd+op2+diss

def decCall(linea,mne,tabSim,direccion,indice):
    '''
    decodifica instrucciones de llamada a subrutina
    '''
    op, cond = mne[linea[indice]]
    des=calDes(direccion,linea[indice+1],tabSim)
    return hex(direccion)[2:]+' '+op+des

def decAri(linea,mne,tabSim,direccion,indice,registros):
    '''
    decodifica instrucciones aritmeticas
    '''
    i='000000000'
    op,op3=mne[linea[indice]]
    rs1=registros[linea[indice+1]]
    rd=registros[linea[indice+3]]
    if linea[indice+2].startswith('%'):
        rs2=registros[linea[indice+2]]
        return hex(direccion)[2:]+' '+op+rd+op3+rs1+i+rs2
    else:
        return hex(direccion)[2:]+' '+op+rd+op3+rs1+'1'+bin(linea[indice+2])[2:]


def decMem(linea,mne,tabSim,direccion,indice,registros):
    '''
    decodifica instrucciones de memoria
    '''
    i='000000000'
    inmediato=None
    op,op3=mne[linea[indice]]

    if linea[indice]=='ld':
        if linea[indice+1].startswith('[') and linea[indice+1].endswith(']'):
            rs1=tabSim[linea[indice+1][1:-1]]
            inmediato=True
        else:
            rs1=registros[linea[indice+1]]
            inmediato=False
        rd=registros[linea[indice+2]]
    elif linea[indice]=='st':
        if linea[indice+2].startswith('[') and linea[indice+2].startswith(']'):
            rd=tabSim[linea[indice+1][1:-1]]
            inmediato=True
        else:
            rd=registros[linea[indice+1]]
            inmediato=False
        rs1=registros[linea[indice+1]]
    
    if not inmediato:
        if len(linea) == 3:
            rs2=registros[linea[indice+2]]
        else:
            rs2=registros['%r0']
        return hex(direccion)[2:]+' '+op+rd+op3+rs1+i+rs2
    else:
        #return hex(direccion)[2:]+' '+op+rd+op3+str(rs1)+'1'+bin(linea[indice+2])[2:]
        return '00000000 00000000000 :('

def ensamblado(op,linea,indice,mne,tabSim,direccion,registros):
    '''
    Verifica el op y ensambla la instruccion
    '''
    asm=None
    if op == '00' and linea[indice]=='sethi':
        asm=decSethi(linea,mne,tabSim,direccion,indice,registros)
        return 'sethi'
    elif op == '00':
        asm=decSalto(linea,mne,tabSim,direccion,indice)
        return "salto"
    elif op == '01':
         asm=decCall(linea,mne,tabSim,direccion,indice)
         return 'call'
    elif op == '11' and not (linea[indice]=='st' or linea[indice]=='ld'):
        asm=decAri(linea,mne,tabSim,direccion,indice,registros)
        return 'ari'
    elif op == '11': 
        asm=decMem(linea,mne,tabSim,direccion,indice,registros)
        return 'mem'

def buscaMacrosOrg(archivo,macros,mne,tabSim):
    ''' ALe Ale aLe Ale'''
    cadena=''
    etiqueta=''
    inMacro=False
    f=open(archivo,"r")
    for linea in f:
        tmp=sepLin(linea.lower())
        if len(tmp) == 0:
            continue
        if tmp[0] == ".org":
            org=int(tmp[1])
        elif tmp[0] == ".macro":
            macroName=tmp[1]
            inMacro=True
            continue
        elif tmp[0]=='.endmacro':
            inMacro=False
            macros[macroName]=cadena
            cadena=''
        elif inMacro:
            cadena+=linea
        elif tmp[0].endswith(':'):
                if len(tmp) == 1:
                    continue
                if not tmp[1] in mne.keys() and not tmp[0][:-1] in tabSim.keys():
                    if tmp[1][:2] == '0x':
                        tabSim[tmp[0].strip(':')]=int(tmp[1],16)
                    else:
                        tabSim[tmp[0].strip(':')]=int(tmp[1])
            
    f.close()
    return org


def preprocesoTemporal(archivo,temporal,macros):
    '''Aqui va un comentario ingenioso'''
    f = open(archivo,"r")
    t =open(temporal,"w")
    enOrg=False
    hayEtiqueta=False
    for linea in f:
        if linea.startswith('!') or len(linea)==1: #ignora comentarios y lineas en blanco
            continue
        lista=sepLin(linea)
        if lista[0] == '.org': #identifica inicio de programa
            enOrg=True
            continue
        if not enOrg: #ignora lineas antes del org
            continue
        if lista[0].startswith('.'): #ignora directivas del ensamblador
            continue
        if lista[0].endswith(':') and len(lista)==1: #Etiqueta en una linea solita
            hayEtiqueta=True
            etiqueta=lista[0]
        elif lista[0] in macros.keys(): #Reemplaza macros
            t.write(macros[lista[0]].replace('arg',lista[1]))
        elif hayEtiqueta: #pega etiqueta a la linea siguente
            hayEtiqueta=False
            t.write(etiqueta +' '+ linea)
        else:
            t.write(linea)
    f.close()
    t.close()

