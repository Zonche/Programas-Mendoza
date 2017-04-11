REM PROGRAMA DE DEMOSTRACION 16
REM ROTACION DE UNA COPA EN TRES DIMENSIONES
REM CON SOMBREADO DE SUPERFICIES POR ILUMINACION
REM (ELIMINACION DE SUPERFICIES OCULTAS POR EL ALGORITMO DEL PINTOR)

REM CONTROLES:
REM Q, A: ROTAR EN EL EJE X
REM P, O: ROTAR EN EL EJE Y
REM K, L: ROTAR EN EL EJE Z
REM R: SOMBREAR
REM S: TERMINAR

REM LUZ INDICA EL NIVEL DE LUZ AMBIENTAL

LUZ = 1

REM INDICA CUAL ES LA TARJETA GRAFICA QUE PREFIERES EN LA VARIABLE TARJETA:
REM 1=CGA 2 COLORES (640 x 200 puntos)
REM 2=EGA 16 COLORES (640 x 350 puntos)
REM 3=MCGA/VGA/SVGA 2 COLORES (640 x 480 puntos)
REM 4=AT&T 2 COLORES (640 x 400 puntos)
REM 5=HERCULES 2 COLORES (720 x 348 puntos)
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

REM INCR ES EL INCREMENTO POR ROTACION

INCR = 3.141592 / 18

DIM MAX(YMAX)
DIM MIN(YMAX)

REM D ES LA DISTANCIA DESDE EL OBSERVADOR A LA PANTALLA EN PIXELS

D = 1000

REM INICIO

PRINT "CALCULANDO LA FIGURA"
PRINT "UN MOMENTO, POR FAVOR"

REM LEEMOS LOS PATRONES DE RELLENADO PARA LA RUTINA DE FILL

DIM PATRONES(24, 3, 5)
RESTORE PATRONES
FOR N = 0 TO 12
     FOR F = 0 TO 3
	  FOR Z = 0 TO 5
	       READ PATRONES(N, F, Z)
	      
	       REM LOS 12 ULTIMOS LOS OBTENEMOS POR INVERSION
	      
	       PATRONES(24 - N, F, Z) = 1 - PATRONES(N, F, Z)
	  NEXT Z
     NEXT F
NEXT N

REM PASO: NUMERO DE LADOS PARA LAS BASES

PASO = 15

REM CALCULAMOS LAS CONSTANTES

RESTORE DATOS
PI = 3.141591 / 180
READ NDISCOS
TOTV = NDISCOS * PASO
DIM V(TOTV, 2)
PASO2 = 360 / PASO

REM CALCULAMOS LOS VERTICES DE LA FIGURA

FOR F = 0 TO NDISCOS - 1
     READ RADIO
     READ ALT
   
     FOR N = 0 TO 360 - PASO2 STEP PASO2
	  GRADO = N * PI
	  V(CUENTA, 0) = RADIO * SIN(GRADO)
	  V(CUENTA, 1) = ALT
	  V(CUENTA, 2) = RADIO * COS(GRADO)
	  CUENTA = CUENTA + 1
     NEXT N
NEXT F

TOTL = (NDISCOS - 1) * PASO
DIM L%(TOTL, PASO)

REM ASIGNAMOS LOS VERTICES A LOS LADOS

FOR F = 0 TO NDISCOS - 2
     FOR N = 0 TO PASO - 1
	  SIG = N + 1
	  IF SIG = PASO THEN
	       SIG = 0
	  END IF
	  CUENTA = N + F * PASO
	  L%(CUENTA, 0) = 4
	  L%(CUENTA, 1) = N + F * PASO
	  L%(CUENTA, 2) = N + PASO + F * PASO
	  L%(CUENTA, 3) = SIG + PASO + F * PASO
	  L%(CUENTA, 4) = SIG + F * PASO
     NEXT N
NEXT F

DIM MED(TOTL - 1, 1)
DIM C(TOTV - 1, 1)

REM BUCLE PRINCIPAL

RENDER = 0
FOR N = 0 TO TOTV - 1
     GOSUB ECUACION
     C(N, 0) = X
     C(N, 1) = Y
NEXT N

A$ = INKEY$
WHILE A$ <> "S" AND A$ <> "s"
     IF RENDER = 1 THEN
	 
	  LOCATE 1, 1
	  INPUT "ILUMINACION: ARRIBA (1), CENTRO (0),    ABAJO (-1):", ILUY
	  LOCATE 1, 1
	  INPUT "ILUMINACION: IZQUIERDA (-1), CENTRO (0),DERECHA (1):", ILUX
	  CLS
	  ILUX = ILUX * 320
	  ILUY = ILUY * -320
	  ILUZ = -D
	 
	  REM CALCULAMOS LA DISTANCIA DE CADA CARA Y LA ALMACENAMOS EN MED
	  REM INCLUIMOS EN MED (N,3) EL NUMERO DE CARA PARA SABER CUAL TENEMOS
	  REM QUE DIBUJAR EN CADA MOMENTO

	  PRINT "ORDENANDO LAS CARAS"
	  FOR N = 0 TO TOTL - 1
	       ZM = 0
	
	       REM HALLAMOS LA MEDIA ARITMETICA DE LAS COORDENADAS Z
	       REM DE LOS VERTICES DE LA CARA
	 
	       LNUM = L%(N, 0)
	       FOR F = 1 TO LNUM
		    ZM = ZM + V(L%(N, F), 2)
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
	  CLS
	  PRINT "(C) 1994 RASTER SOFT."
	 
	  FOR N = 0 TO TOTL - 1
	 
	       CAR = MED(N, 1)

	       REM CALCULAMOS LA MEDIA ARITMETICA DE LOS VERTICES DE LA CARA

	       MEDX = 0
	       MEDY = 0
	       MEDZ = 0
	       LNUM = L%(CAR, 0)
	       FOR F = 1 TO LNUM
		    MEDX = MEDX + V(L%(CAR, F), 0)
		    MEDY = MEDY + V(L%(CAR, F), 1)
		    MEDZ = MEDZ + V(L%(CAR, F), 2)
	       NEXT F
	       MEDX = MEDX / LNUM
	       MEDY = MEDY / LNUM
	       MEDZ = MEDZ / LNUM

	       REM CALCULO LAS COORDENADAS DE DOS VECTORES CONSECUTIVOS
	       REM DE LA CARA A TESTEAR

	       X1 = V(L%(CAR, 2), 0) - V(L%(CAR, 1), 0)
	       Y1 = V(L%(CAR, 2), 1) - V(L%(CAR, 1), 1)
	       Z1 = V(L%(CAR, 2), 2) - V(L%(CAR, 1), 2)
	       X2 = V(L%(CAR, 3), 0) - V(L%(CAR, 2), 0)
	       Y2 = V(L%(CAR, 3), 1) - V(L%(CAR, 2), 1)
	       Z2 = V(L%(CAR, 3), 2) - V(L%(CAR, 2), 2)
	 
	       REM CALCULO LAS COORDENADAS DEL VECTOR NORMAL
	       REM POR MEDIO DEL PRODUCTO VECTORIAL
	 
	       X = (Y1 * Z2) - (Y2 * Z1)
	       Y = (Z1 * X2) - (Z2 * X1)
	       Z = (X1 * Y2) - (X2 * Y1)
	  
	       REM LO CONVERTIMOS EN VECTOR UNITARIO

	       MODULO = SQR(X ^ 2 + Y ^ 2 + Z ^ 2)
	       X = X / MODULO
	       Y = Y / MODULO
	       Z = Z / MODULO

	       REM CALCULAMOS LAS COORDENADAS DEL VECTOR DE VISION, QUE UNE
	       REM EL OJO CON EL PRIMER VERTICE DE LA CARA

	       X1 = V(L%(CAR, 1), 0)
	       Y1 = V(L%(CAR, 1), 1)
	       Z1 = V(L%(CAR, 1), 2) + D

	       REM Y LO CONVERTIMOS EN UNITARIO

	       MODULO = SQR(X1 ^ 2 + Y1 ^ 2 + Z1 ^ 2)
	       X1 = X1 / MODULO
	       Y1 = Y1 / MODULO
	       Z1 = Z1 / MODULO

	       REM Y EL VECTOR DE ILUMINACION, QUE UNE LA FUENTE DE LUZ CON
	       REM EL VERTICE MEDIO DE LA CARA

	       X2 = MEDX - ILUX
	       Y2 = MEDY - ILUY
	       Z2 = MEDZ - ILUZ

	       REM Y LO CONVERTIMOS EN UNITARIO

	       MODULO = SQR(X2 ^ 2 + Y2 ^ 2 + Z2 ^ 2)
	       X2 = X2 / MODULO
	       Y2 = Y2 / MODULO
	       Z2 = Z2 / MODULO
	      
	       REM CALCULAMOS EL PRODUCTO ESCALAR DEL VECTOR NORMAL A LA
	       REM CARA CON EL VECTOR DE VISION
 
	       ESCALAR = (X * X1) + (Y * Y1) + (Z * Z1)
	 
	       REM ASI COMO EL PRODUCTO ESCALAR CON EL VECTOR DE ILUMINACION

	       ESCALAR2 = (X * X2) + (Y * Y2) + (Z * Z2)
	      
	       REM Y APLICAMOS EL TEST DE VISIBILIDAD
	      
	       IF (ESCALAR < 0 AND ESCALAR2 < 0) OR (ESCALAR >= 0 AND ESCALAR2 >= 0) THEN
		    ESCALAR2 = ABS(ESCALAR2)
	       ELSE
		    ESCALAR2 = 0
	       END IF
	      
	       FOR CU = 0 TO YMAX
		    MIN(CU) = XMAX
		    MAX(CU) = 0
	       NEXT CU
		     
	       YMAXI = 0
	       YMINI = YMAX
	       FOR F = 1 TO LNUM
		    SIGUIE = F + 1
		    IF F = LNUM THEN SIGUIE = 1
		    XI = C(L%(CAR, F), 0) * RELX
		    YI = C(L%(CAR, F), 1) * RELY
		    XF = C(L%(CAR, SIGUIE), 0) * RELX
		    YF = C(L%(CAR, SIGUIE), 1) * RELY
		    GRIS = LUZ + INT(ESCALAR2 * 24)
		    IF GRIS > 24 THEN GRIS = 24
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
	       GOSUB RELLENAR
	  NEXT N
	  RENDER = 0

     ELSE

	  CLS
	  PRINT "(C) 1994 RASTER SOFT."
	  FOR N = 0 TO TOTL - 1
	       LNUM = L%(N, 0)
	       FOR F = 1 TO LNUM
		    SIGUIE = F + 1
		    IF F = LNUM THEN SIGUIE = 1
		    XI = C(L%(N, F), 0)
		    YI = C(L%(N, F), 1)
		    XF = C(L%(N, SIGUIE), 0)
		    YF = C(L%(N, SIGUIE), 1)
		    COLORES = NUMCOLOR - 1
		    GOSUB PINTAR
	       NEXT F
	  NEXT N
    
     END IF
     A$ = INKEY$
     WHILE A$ = ""
	 A$ = INKEY$
     WEND
     IF A$ = "R" OR A$ = "r" THEN RENDER = 1
     PRINT "ROTANDO"
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

PINTAR:

     LINE (XI * RELX, YI * RELY)-(XF * RELX, YF * RELY), COLORES
     RETURN

RELLENAR:

FOR Y = YMINI TO YMAXI
	X0 = MIN(Y)
	X1 = MAX(Y)
	IF X0 <= X1 THEN
		FOR CU = X0 TO X1
			X = CU
			GOSUB PUNTO
		NEXT CU
	END IF
NEXT Y
RETURN

PUNTO:
   
     XMOD = X MOD 6
     YMOD = Y MOD 4
     COLORES3 = PATRONES(GRIS, YMOD, XMOD)
     COLORES3 = COLORES3 * COLORES
     PSET (X, Y), COLORES3
     RETURN

PREPARAR:
  
     ON TARJETA GOSUB CGA, EGA, VGA, ATT, HERCULES
     CLS
     RETURN

CGA:
     XMAX = 640
     YMAX = 200
     SCREEN 2
     NUMCOLOR = 2
     RETURN

EGA:
     XMAX = 640
     YMAX = 350
     SCREEN 9
     NUMCOLOR = 16
     RETURN

VGA:
     XMAX = 640
     YMAX = 480
     SCREEN 11
     NUMCOLOR = 2
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

REM ESTAS SON LAS DATAs CON LOS PATRONES DE SOMBREADO

PATRONES:
     DATA 0,0,0,0,0,0
     DATA 0,0,0,0,0,0
     DATA 0,0,0,0,0,0
     DATA 0,0,0,0,0,0

     DATA 1,0,0,0,0,0
     DATA 0,0,0,0,0,0
     DATA 0,0,0,0,0,0
     DATA 0,0,0,0,0,0

     DATA 1,0,0,0,0,0
     DATA 0,0,0,0,0,0
     DATA 0,0,1,0,0,0
     DATA 0,0,0,0,0,0

     DATA 1,0,0,0,1,0
     DATA 0,0,0,0,0,0
     DATA 0,0,1,0,0,0
     DATA 0,0,0,0,0,0

     DATA 1,0,0,0,1,0
     DATA 0,0,0,0,0,0
     DATA 1,0,1,0,0,0
     DATA 0,0,0,0,0,0

     DATA 1,0,0,0,1,0
     DATA 0,0,0,0,0,0
     DATA 1,0,1,0,1,0
     DATA 0,0,0,0,0,0
   
     DATA 1,0,1,0,1,0
     DATA 0,0,0,0,0,0
     DATA 1,0,1,0,1,0
     DATA 0,0,0,0,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,0,0,0
     DATA 1,0,1,0,1,0
     DATA 0,0,0,0,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,0,0,0
     DATA 1,0,1,0,1,0
     DATA 0,0,0,1,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,0,0,1
     DATA 1,0,1,0,1,0
     DATA 0,0,0,1,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,0,0,1
     DATA 1,0,1,0,1,0
     DATA 0,1,0,1,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,1,0,1
     DATA 1,0,1,0,1,0
     DATA 0,1,0,1,0,0

     DATA 1,0,1,0,1,0
     DATA 0,1,0,1,0,1
     DATA 1,0,1,0,1,0
     DATA 0,1,0,1,0,1
    
     REM AQUI VIENE LA DEFINICION DE LA COPA
     REM EL PRIMER VALOR ES EL NUMERO DE DISCOS O CORTES
     REM A CONTINUACION CADA DISCO VIENEN DEFINIDO POR DOS VALORES:
     REM PRIMERO SU RADIO
     REM Y LUEGO SU COORDENADA Y

DATOS:

     DATA 7
     DATA 120,-150
     DATA 100,-140
     DATA 100,0
     DATA 75,50
     DATA 25,100
     DATA 25,150
     DATA 75,155

