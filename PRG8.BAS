REM PROGRAMA DE DEMOSTRACION 8
REM ROTACION DE UN CUBO EN TRES DIMENSIONES
REM CON ELIMINACION DE SUPERFICIES OCULTAS
REM POR EL METODO DEL PINTOR (SEGUNDO ALGORITMO DE RELLENADO)

REM CONTROLES:
REM Q, A: ROTAR EN EL EJE X
REM P, O: ROTAR EN EL EJE Y
REM K, L: ROTAR EN EL EJE Z
REM R: COLOREAR
REM S: TERMINAR

REM INDICA CUAL ES LA TARJETA GRAFICA QUE PREFIERES EN LA VARIABLE TARJETA:
REM 1=CGA 4 COLORES (320 x 200 puntos)
REM 2=CGA 2 COLORES (640 x 200 puntos)
REM 3=EGA 16 COLORES (640 x 350 puntos)
REM 4=EGA 16 COLORES (320 x 200 puntos) usar este modo si va muy lento
REM 5=MCGA 2 COLORES (640 x 480 puntos)
REM 6=MCGA 256 COLORES (320 x 200 puntos)
REM 7=VGA/SVGA 16 COLORES (640 x 480 puntos)
REM 8=AT&T 2 COLORES (640 x 400 puntos)
REM 9=HERCULES 2 COLORES (720 x 348 puntos)
REM Para usar la tarjeta HERCULES, ejecutar antes desde DOS
REM la controladora de dispositivos MSHERC.COM

TARJETA = 1
GOSUB PREPARAR

REM LA VARIABLE RELAS INDICA LA RELACION DE ASPECTO DEL DISPOSITIVO DE SALIDA

RELAS = 3 / 4
IF RELAS <= 1 THEN
     REX = 480 / RELAS
     REY = 480
ELSE
     REX = 480
     REY = 480 * RELAS
END IF

RELX = XMAX / REX
RELY = YMAX / REY

REM INCR ES EL INCREMENTO DE LOS ANGULOS
REM REDUCIRLO SI VA MUY RAPIDO

INCR = 3.141592 / 18

REM D ES LA DISTANCIA DESDE EL OBSERVADOR A LA PANTALLA EN PIXELS

D = 1000

DIM MAX(YMAX)
DIM MIN(YMAX)

REM INICIO

REM LEEMOS LA TABLA DE DATOS

RESTORE DATOS

REM LEEMOS LOS VERTICES

READ TOTV
DIM V(TOTV - 1, 2)
FOR N = 0 TO TOTV - 1
     FOR F = 0 TO 2
	  READ V(N, F)
     NEXT F
NEXT N

REM LEEMOS LAS CARAS

READ TOTL
DIM L(TOTL - 1, 5)
FOR N = 0 TO TOTL - 1
     READ NLIN
     L(N, 0) = NLIN
     FOR F = 1 TO NLIN + 1
	  READ L(N, F)
     NEXT F
NEXT N
    
REM AJUSTAMOS LOS COLORES SI TENEMOS UNA CGA

IF NUMCOLOR = 4 THEN
     FOR N = 0 TO TOTL - 1
	  NLIN = L(N, 0)
	  COLORES = L(N, NLIN + 1) - 2
	  COLORES = COLORES * 2 / 13
	  COLORES = COLORES + 1
	  L(N, NLIN + 1) = COLORES
     NEXT N
END IF

IF NUMCOLOR = 2 THEN
     FOR N = 0 TO TOTL - 1
	  NLIN = L(N, 0)
	  L(N, NLIN + 1) = 1
     NEXT N
END IF


DIM MED(TOTL - 1, 1)
DIM C(TOTV - 1, 1)
RENDER = 0

REM BUCLE PRINCIPAL

FOR N = 0 TO TOTV - 1
     GOSUB ECUACION
     C(N, 0) = X
     C(N, 1) = Y
NEXT N

A$ = INKEY$
WHILE A$ <> "S" AND A$ <> "s"
     CLS
     PRINT "(C) 1994 RASTER SOFT."
    
     REM SI RENDER ES IGUAL A 1, ENTONCES ES QUE TENEMOS QUE COLOREAR
     REM LA FIGURA

     IF RENDER = 1 THEN

	  REM CALCULAMOS LA DISTANCIA DE CADA CARA Y LA ALMACENAMOS EN MED
	  REM INCLUIMOS EN MED (N,3) EL NUMERO DE CARA PARA SABER CUAL TENEMOS
	  REM QUE DIBUJAR EN CADA MOMENTO

	  PRINT "ORDENANDO LAS CARAS"
	  FOR N = 0 TO TOTL - 1
	       ZM = 0
	 
	       REM HALLAMOS LA MEDIA ARITMETICA DE LAS COORDENADAS Z
	       REM DE LOS VERTICES DE LA CARA
	  
	       LNUM = L(N, 0)
	       FOR F = 1 TO LNUM
		    ZM = ZM + V(L(N, F), 2)
	       NEXT F
	       MED(N, 0) = ZM / LNUM
	       MED(N, 1) = N
	  NEXT N
	 
	  REM ORDENAMOS LAS CARAS DE MAS LEJANA A MAS CERCANA
	  REM USANDO EL VALOR DE Z
	 
	  FOR N = 0 TO TOTL - 2
	       FOR F = N + 1 TO TOTL - 1
		    IF MED(N, 0) < MED(F, 0) THEN
			 FOR A = 0 TO 1
			      SWAP MED(N, A), MED(F, A)
			 NEXT A
		    END IF
	       NEXT F
	  NEXT N

	  LOCATE 2, 1
	  PRINT "                         "
	  FOR N = 0 TO TOTL - 1
      
	       FOR CU = 0 TO YMAX
		       MIN(CU) = XMAX
		       MAX(CU) = 0
	       NEXT CU
	       YMAXI = 0
	       YMINI = YMAX

	       REM PINTAMOS LA CARA QUE INDIQUE MED (N,3)

	       CAR = MED(N, 1)
	       LNUM = L(CAR, 0)

	       REM PINTAMOS LA CARA CON EL COLOR DEFINITIVO

	       COLORES = L(CAR, LNUM + 1)
	       GOSUB CARA
	       GOSUB RELLENAR
	 
	       REM PINTAMOS LOS BORDES DE LA CARA EN NEGRO PARA QUE RESALTEN
	       REM SOLO CON TARJETA CGA O DOS COLORES

	       IF NUMCOLOR = 4 OR NUMCOLOR = 2 THEN
		    COLORES = 0
		    GOSUB CARA3
	       END IF
	  NEXT N
	  RENDER = 0
	 
     ELSE

	  REM SI NO SON VISTAS, LAS PINTAMOS SIMPLEMENTE

	  FOR N = 0 TO TOTL - 1
	       LNUM = L(N, 0)
	       CAR = N
	       COLORES = L(N, LNUM + 1)
	       GOSUB CARA2
	  NEXT N
     END IF
    
     A$ = INKEY$
     WHILE A$ = ""
	 A$ = INKEY$
     WEND
     IF A$ = "R" OR A$ = "r" THEN RENDER = 1
     IF A$ = "A" OR A$ = "a" THEN
	  AX = INCR
	  GOSUB ROTX
     END IF
     IF A$ = "Q" OR A$ = "q" THEN
	  AX = -INCR
	  GOSUB ROTX
     END IF
     IF A$ = "P" OR A$ = "p" THEN
	  AY = INCR
	  GOSUB ROTY
     END IF
     IF A$ = "O" OR A$ = "o" THEN
	  AY = -INCR
	  GOSUB ROTY
     END IF
     IF A$ = "L" OR A$ = "l" THEN
	  AZ = INCR
	  GOSUB ROTZ
     END IF
     IF A$ = "K" OR A$ = "k" THEN
	  AZ = -INCR
	  GOSUB ROTZ
     END IF
WEND
END
   
REM CALCULAMOS LAS ROTACIONES PARA CADA UNO DE LOS VERTICES
  
ROTX:
     A$ = ""
     SA = SIN(AX)
     CA = COS(AX)
     FOR N = 0 TO TOTV - 1
	  C1 = V(N, 1)
	  C2 = V(N, 2)
	  GOSUB ROTAR
	  V(N, 1) = C1
	  V(N, 2) = C2
	  GOSUB ECUACION
	  C(N, 0) = X
	  C(N, 1) = Y
     NEXT N
     AX = 0
     RETURN
       
ROTY:
     A$ = ""
     SA = SIN(AY)
     CA = COS(AY)
     FOR N = 0 TO TOTV - 1
	  C1 = V(N, 0)
	  C2 = V(N, 2)
	  GOSUB ROTAR
	  V(N, 0) = C1
	  V(N, 2) = C2
	  GOSUB ECUACION
	  C(N, 0) = X
	  C(N, 1) = Y
     NEXT N
     AY = 0
     RETURN

ROTZ:
     A$ = ""
     SA = SIN(AZ)
     CA = COS(AZ)
     FOR N = 0 TO TOTV - 1
	  C1 = V(N, 0)
	  C2 = V(N, 1)
	  GOSUB ROTAR
	  V(N, 0) = C1
	  V(N, 1) = C2
	  GOSUB ECUACION
	  C(N, 0) = X
	  C(N, 1) = Y
     NEXT N
     RETURN

REM SUBRUTINA DE PROYECCION PARA PASAR DE 3D A 2D

ECUACION:
     X = (V(N, 0) * D) / (V(N, 2) + D) + REX / 2
     Y = (V(N, 1) * D) / (V(N, 2) + D) + REY / 2
     RETURN
    
REM SUBRUTINA DE ROTACION

ROTAR:
     ALFA = C1 * CA - C2 * SA
     C2 = C1 * SA + C2 * CA
     C1 = ALFA
     RETURN

REM ESTA SUBRUTINA DIBUJA CADA UNA DE LAS CARAS Y LA RELLENA

CARA:
   
     FOR F = 1 TO NLIN
	  SIGUIE = F + 1
	  IF F = LNUM THEN SIGUIE = 1
	  XI = C(L(CAR, F), 0) * RELX
	  YI = C(L(CAR, F), 1) * RELY
	  XF = C(L(CAR, SIGUIE), 0) * RELX
	  YF = C(L(CAR, SIGUIE), 1) * RELY
	  DX = XF - XI
	  DY = YF - YI
	  IF DX <> 0 OR DY <> 0 THEN
	       IF ABS(DX) > ABS(DY) THEN
		    PASO# = 1 / (1.1 * DX)
	       ELSE
		    PASO# = 1 / (1.1 * DY)
	       END IF
	  ELSE
		PASO# = 1
	  END IF
	  FOR CU# = 0 TO 1 STEP ABS(PASO#)
	       X = INT(XI + CU# * DX)
	       Y = INT(YI + CU# * DY)
	       IF X >= 0 AND X < XMAX AND Y >= 0 AND Y < YMAX THEN
		    IF X > MAX(Y) THEN MAX(Y) = X
		    IF X < MIN(Y) THEN MIN(Y) = X
		    IF Y < YMINI THEN YMINI = Y
		    IF Y > YMAXI THEN YMAXI = Y
	       END IF
	  NEXT CU#
     NEXT F
     RETURN

REM ESTA SUBRUTINA PINTA LOS CONTORNOS DE LAS CARAS CON EL COLOR ESPECIFICADO

CARA3:
  
     FOR F = 1 TO NLIN
	  SIGUIE = F + 1
	  IF F = LNUM THEN SIGUIE = 1
	  XI = C(L(CAR, F), 0) * RELX
	  YI = C(L(CAR, F), 1) * RELY
	  XF = C(L(CAR, SIGUIE), 0) * RELX
	  YF = C(L(CAR, SIGUIE), 1) * RELY
	  DX = XF - XI
	  DY = YF - YI
	  IF DX <> 0 OR DY <> 0 THEN
	       IF ABS(DX) > ABS(DY) THEN
		    PASO# = 1 / (1.1 * DX)
	       ELSE
		    PASO# = 1 / (1.1 * DY)
	       END IF
	  ELSE
		PASO# = 1
	  END IF
	  FOR CU# = 0 TO 1 STEP ABS(PASO#)
	       X = INT(XI + CU# * DX)
	       Y = INT(YI + CU# * DY)
	       IF X >= 0 AND X < XMAX AND Y >= 0 AND Y < YMAX THEN
		    PSET (X, Y), COLORES
	       END IF
	  NEXT CU#
     NEXT F
     RETURN


CARA2:
  
     FOR F = 1 TO NLIN
	  SIGUIE = F + 1
	  IF F = LNUM THEN SIGUIE = 1
	  XI = C(L(CAR, F), 0) * RELX
	  YI = C(L(CAR, F), 1) * RELY
	  XF = C(L(CAR, SIGUIE), 0) * RELX
	  YF = C(L(CAR, SIGUIE), 1) * RELY
	  LINE (XI, YI)-(XF, YF), COLORES
     NEXT F
     RETURN


RELLENAR:

FOR Y = YMINI TO YMAXI
	X0 = MIN(Y)
	X1 = MAX(Y)
	IF X0 <= X1 THEN LINE (X0, Y)-(X1, Y), COLORES
NEXT Y
RETURN

PREPARAR:
 
     ON TARJETA GOSUB CGA1, CGA2, EGA1, EGA2, MCGA1, MCGA2, VGA, ATT, HERCULES
     CLS
     RETURN

CGA1:
     XMAX = 320
     YMAX = 200
     SCREEN 1
     NUMCOLOR = 4
     RETURN

CGA2:
     XMAX = 640
     YMAX = 200
     SCREEN 2
     NUMCOLOR = 2
     RETURN

EGA1:
     XMAX = 640
     YMAX = 350
     SCREEN 9
     NUMCOLOR = 16
     RETURN

EGA2:
     XMAX = 320
     YMAX = 200
     SCREEN 7
     NUMCOLOR = 16
     RETURN


MCGA1:
     XMAX = 640
     YMAX = 480
     SCREEN 11
     NUMCOLOR = 2
     RETURN

MCGA2:
     XMAX = 320
     YMAX = 200
     SCREEN 13
     NUMCOLOR = 256
     RETURN

VGA:
     XMAX = 640
     YMAX = 480
     SCREEN 12
     NUMCOLOR = 16
     RETURN

ATT:
     XMAX = 640
     YMAX = 400
     SCREEN 4
     NUMCOLOR = 2
     RETURN

HERCULES:
     XMAX = 720
     YMAX = 348
     SCREEN 3
     NUMCOLOR = 2
     RETURN

DATOS:
     REM ESTA ES LA BASE DE DATOS OPTIMIZADA DEL CUBO.
     REM ESTA REFERIDA A UNA PANTALLA DE 640 x 480
     REM AQUI VIENE LA DEFINICION DE LOS VERTICES.
     REM EL PRIMER VALOR ES EL NUMERO DE VERTICES.
     REM CADA VERTICE VIENE DEFINIDO POR SUS TRES COORDENADAS.
    
     DATA 32
     DATA -100,-100,-100
     DATA 100,-100,-100
     DATA 100,100,-100
     DATA -100,100,-100
     DATA -100,-100,100
     DATA 100,-100,100
     DATA 100,100,100
     DATA -100,100,100
     DATA -100,-80,-80
     DATA -100,80,-80
     DATA -100,80,80
     DATA -100,-80,80
     DATA 100,-80,-80
     DATA 100,80,-80
     DATA 100,80,80
     DATA 100,-80,80
     DATA -80,-100,-80
     DATA 80,-100,-80
     DATA 80,-100,80
     DATA -80,-100,80
     DATA -80,100,-80
     DATA 80,100,-80
     DATA 80,100,80
     DATA -80,100,80
     DATA -80,-80,-100
     DATA 80,-80,-100
     DATA 80,80,-100
     DATA -80,80,-100
     DATA -80,-80,100
     DATA 80,-80,100
     DATA 80,80,100
     DATA -80,80,100

     REM AQUI VIENE LA DEFINICION DE LAS CARAS
     REM EL PRIMER NUMERO ES EL NUMERO TOTAL DE CARAS
     REM DESPUES VIENE LA DEFINICION DE ESTAS
     REM EL PRIMER VALOR ES EL NUMERO DE SEGMENTOS DE LA CARA
     REM EL ULTIMO ES EL COLOR
    
     DATA 24
     DATA 4,4,28,31,7,8
     DATA 4,4,28,29,5,9
     DATA 4,5,29,30,6,10
     DATA 4,6,30,31,7,11

     DATA 4,0,24,25,1,4
     DATA 4,0,24,27,3,5
     DATA 4,1,25,26,2,6
     DATA 4,2,26,27,3,7

     DATA 4,3,20,23,7,14
     DATA 4,3,20,21,2,15
     DATA 4,2,21,22,6,2
     DATA 4,22,6,7,23,3

     DATA 4,0,16,19,4,10
     DATA 4,0,16,17,1,11
     DATA 4,1,17,18,5,12
     DATA 4,5,18,19,4,13

     DATA 4,1,12,15,5,6
     DATA 4,1,12,13,2,7
     DATA 4,2,13,14,6,8
     DATA 4,6,14,15,5,9

     DATA 4,0,8,9,3,2
     DATA 4,0,8,11,4,3
     DATA 4,3,9,10,7,4
     DATA 4,7,10,11,4,5

