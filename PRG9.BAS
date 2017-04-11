REM PROGRAMA DE DEMOSTRACION 9
REM ROTACION DE UN CUBO EN TRES DIMENSIONES
REM CON SOMBREADO DE SUPERFICIES POR ILUMINACION
REM PON LA VARIABLE MONOCROMO A 1 SI QUIERES VERLO EN UN SOLO COLOR
REM (SE APRECIA MEJOR LA ILUMINACION, SOBRE TODO EN MONITORES MONOCROMOS)

MONOCROMO = 0

REM CONTROLES:
REM Q, A: ROTAR EN EL EJE X
REM P, O: ROTAR EN EL EJE Y
REM K, L: ROTAR EN EL EJE Z
REM R: SOMBREAR
REM S: TERMINAR

REM LA VARIABLE LUZ INDICA EL NIVEL DE LUZ AMBIENTAL

LUZ = 1

REM INDICA CUAL ES LA TARJETA GRAFICA QUE PREFIERES EN LA VARIABLE TARJETA:
REM 1=CGA 4 COLORES (320 x 200 puntos)
REM 2=EGA 16 COLORES (640 x 350 puntos)
REM 3=EGA/VGA/SVGA 16 COLORES (320 x 200 puntos) (usarlo si va muy lento)
REM 4=MCGA 256 COLORES (320 x 200 puntos)
REM 5=VGA/SVGA 16 COLORES (640 x 480 puntos)

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

REM ESTAS VARIABLES SE USAN PARA LA SIMULACION DE LA PILA O STACK
REM DEL FILL

DIM PILA(20, 1)
PUNTERO = 0

REM D ES LA DISTANCIA DESDE EL OBSERVADOR A LA PANTALLA EN PIXELS

D = 1000

REM INICIO

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

REM LEEMOS LAS CARAS CON SU COLOR CORRESPONDIENTE

READ TOTL
DIM L(TOTL - 1, 5)
FOR N = 0 TO TOTL - 1
     READ LNUM
     L(N, 0) = LNUM
     FOR F = 1 TO LNUM
	  READ L(N, F)
     NEXT F
     READ L(N, LNUM + 1)
NEXT N
  
REM AJUSTAMOS LOS COLORES SI TENEMOS UNA CGA

IF NUMCOLOR = 4 THEN
     FOR N = 0 TO TOTL - 1
	  NLIN = L(N, 0)
	  COLORES = L(N, NLIN + 1)
	  IF COLORES > 0 THEN
	       IF COLORES < 9 THEN
		    COLORES = 2
	       ELSE
		    COLORES = 3
	       END IF
	  END IF
	  L(N, NLIN + 1) = COLORES
     NEXT N
END IF

REM AJUSTAMOS LOS COLORES SI QUEREMOS MONOCROMO

IF MONOCROMO = 1 THEN
     FOR N = 0 TO TOTL - 1
	  NLIN = L(N, 0)
	 
	  REM COGEMOS EL COLOR MAS CLARO DE LA PALETA.

	  L(N, NLIN + 1) = NUMCOLOR - 1
     NEXT N
END IF

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
	  PRINT "(C) 1994 RASTER SOFT."
	  ILUX = ILUX * 320
	  ILUY = ILUY * -320
	  ILUZ = -D
	  FOR N = 0 TO TOTL - 1
	 
	       REM CALCULAMOS LA MEDIA ARITMETICA DE LOS VERTICES DE LA CARA

	       MEDX = 0
	       MEDY = 0
	       MEDZ = 0
	       LNUM = L(N, 0)
	       FOR F = 1 TO LNUM
		    MEDX = MEDX + V(L(N, F), 0)
		    MEDY = MEDY + V(L(N, F), 1)
		    MEDZ = MEDZ + V(L(N, F), 2)
	       NEXT F
	       MEDX = MEDX / LNUM
	       MEDY = MEDY / LNUM
	       MEDZ = MEDZ / LNUM

	       REM Y HALLAMOS SU PROYECCION

	       MEDIX = (MEDX * D) / (MEDZ + D) + REX / 2
	       MEDIY = (MEDY * D) / (MEDZ + D) + REY / 2

	       REM CALCULO LAS COORDENADAS DE DOS VECTORES CONSECUTIVOS
	       REM DE LA CARA A TESTEAR

	       X1 = V(L(N, 2), 0) - V(L(N, 1), 0)
	       Y1 = V(L(N, 2), 1) - V(L(N, 1), 1)
	       Z1 = V(L(N, 2), 2) - V(L(N, 1), 2)
	       X2 = V(L(N, 3), 0) - V(L(N, 2), 0)
	       Y2 = V(L(N, 3), 1) - V(L(N, 2), 1)
	       Z2 = V(L(N, 3), 2) - V(L(N, 2), 2)
	 
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

	       X1 = V(L(N, 1), 0)
	       Y1 = V(L(N, 1), 1)
	       Z1 = V(L(N, 1), 2) + D

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
	      
	       REM SI ESCALAR2 ES NEGATIVO, LO PONEMOS A CERO

	       IF ESCALAR2 < 0 THEN
		    ESCALAR2 = 0
	       END IF

	       REM Y APLICAMOS EL TEST DE VISIBILIDAD
	      
	       IF ESCALAR > 0 THEN
		    FOR F = 1 TO LNUM
			 SIGUIE = F + 1
			 IF F = LNUM THEN SIGUIE = 1
			 XI = C(L(N, F), 0)
			 YI = C(L(N, F), 1)
			 XF = C(L(N, SIGUIE), 0)
			 YF = C(L(N, SIGUIE), 1)
			 COLORES = 1
			 GOSUB PINTAR
		    NEXT F
		    COLORES = L(N, LNUM + 1)
		    GRIS = LUZ + INT(ESCALAR2 * 24)
		    IF GRIS > 24 THEN GRIS = 24
		    X = MEDIX * RELX
		    Y = MEDIY * RELY
		    GOSUB FILL
	       END IF
	  NEXT N
	  RENDER = 0

     ELSE

	  CLS
	  PRINT "(C) 1994 RASTER SOFT."
	  FOR N = 0 TO TOTL - 1
	       LNUM = L(N, 0)
	       FOR F = 1 TO LNUM
		    SIGUIE = F + 1
		    IF F = LNUM THEN SIGUIE = 1
		    XI = C(L(N, F), 0)
		    YI = C(L(N, F), 1)
		    XF = C(L(N, SIGUIE), 0)
		    YF = C(L(N, SIGUIE), 1)
		    COLORES = L(N, LNUM + 1)
		    GOSUB PINTAR
	       NEXT F
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

PINTAR:
 
     LINE (XI * RELX, YI * RELY)-(XF * RELX, YF * RELY), COLORES
     RETURN

REM ESTA ES LA SUBRUTINA DE FILL

FILL:
    
     HEY = 0
     XAL = X
     YAL = Y
     PASO = 0
     GOSUB FILL2
     IF HEY = 0 THEN
	  PASO = 1
	  X = XAL
	  Y = YAL
	  GOSUB FILL3
     END IF
     RETURN

FILL2:
    
     PUNTERO = 0
     A = POINT(X, Y)
     WHILE (A <> 1 OR PUNTERO > 0) AND HEY = 0
	  A = POINT(X, Y)
	  WHILE (A <> 1)
	       X = X - 1
	       A = POINT(X, Y)
	  WEND
	  X = X + 1
	  X1 = X
	  GOSUB TRAZAR
	  IF PUNTERO > 0 THEN
	       GOSUB SACAR
	  END IF
	  A = POINT(X, Y)
     WEND
RETURN

TRAZAR:
     ESTADO1 = 0
     ESTADO2 = 0
     A = POINT(X1, Y)
     WHILE A <> 1 AND X1 < XMAX AND X1 >= 0
	  A = POINT(X1, Y + 1)
	  IF A <> 1 AND ESTADO1 = 0 THEN
	       METY = Y + 1
	       GOSUB METER
	       ESTADO1 = 1
	  END IF
	  IF A = 1 THEN
	       ESTADO1 = 0
	  END IF
	  A = POINT(X1, Y - 1)
	  IF A <> 1 AND ESTADO2 = 0 THEN
	       METY = Y - 1
	       GOSUB METER
	       ESTADO2 = 1
	  END IF
	  IF A = 1 THEN
	       ESTADO2 = 0
	  END IF
	  X1 = X1 + 1
	  A = POINT(X1, Y)
     WEND
     HEY = 1
     IF X1 < XMAX AND X1 >= 0 THEN
	  LINE (X, Y)-(X1, Y), 1
	  HEY = 0
     END IF
RETURN

FILL3:
    
     IF GRIS < 0 THEN GRIS = 0
     PUNTERO = 0
     A = POINT(X, Y)
     WHILE A = 1 OR PUNTERO > 0
	  A = POINT(X, Y)
	  WHILE (A = 1)
	       X = X - 1
	       A = POINT(X, Y)
	  WEND
	  X = X + 1
	  X1 = X
	  GOSUB TRAZAR2
	  IF PUNTERO > 0 THEN
	       GOSUB SACAR
	  END IF
	  A = POINT(X, Y)
     WEND
RETURN

TRAZAR2:
     ESTADO1 = 0
     ESTADO2 = 0
     A = POINT(X1, Y)
     WHILE A = 1
	  GOSUB PUNTO
	  A = POINT(X1, Y + 1)
	  IF A = 1 AND ESTADO1 = 0 THEN
	       METY = Y + 1
	       GOSUB METER
	       ESTADO1 = 1
	  END IF
	  IF A <> 1 THEN
	       ESTADO1 = 0
	  END IF
	  A = POINT(X1, Y - 1)
	  IF A = 1 AND ESTADO2 = 0 THEN
	       METY = Y - 1
	       GOSUB METER
	       ESTADO2 = 1
	  END IF
	  IF A <> 1 THEN
	       ESTADO2 = 0
	  END IF
	  X1 = X1 + 1
	  A = POINT(X1, Y)
     WEND
RETURN

PUNTO:
   
     XMOD = X1 MOD 6
     YMOD = Y MOD 4
     COLORES3 = PATRONES(GRIS, YMOD, XMOD)
     COLORES3 = COLORES3 * COLORES
     PSET (X1, Y), COLORES3
     RETURN

REM ESTA SUBRUTINA METE LOS VALORES DE X1 METY EN LA PILA

METER:
     PILA(PUNTERO, 0) = X1
     PILA(PUNTERO, 1) = METY
     PUNTERO = PUNTERO + 1
     RETURN

REM ESTA SUBRUTINA SACA A LAS VARIABLES X E Y LOS VALORES DE LA PILA

SACAR:
     PUNTERO = PUNTERO - 1
     X = PILA(PUNTERO, 0)
     Y = PILA(PUNTERO, 1)
     RETURN

PREPARAR:
 
     ON TARJETA GOSUB CGA, EGA1, EGA2, MCGA, VGA
     CLS
     RETURN

CGA:
     XMAX = 320
     YMAX = 200
     SCREEN 1
     NUMCOLOR = 4
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

MCGA:
     XMAX = 320
     YMAX = 200
     SCREEN 13
     NUMCOLOR = 16
     RETURN

VGA:
     XMAX = 640
     YMAX = 480
     SCREEN 12
     NUMCOLOR = 16
     RETURN

DATOS:
     REM ESTA ES LA BASE DE DATOS OPTIMIZADA DEL CUBO.
     REM ESTA REFERIDA A UNA PANTALLA DE 640 x 480
     REM AQUI VIENE LA DEFINICION DE LOS VERTICES.
     REM EL PRIMER VALOR ES EL NUMERO DE VERTICES.
     REM CADA VERTICE VIENE DEFINIDO POR SUS TRES COORDENADAS.
    
     DATA 9
     DATA -100,-100,-100
     DATA 100,-100,-100
     DATA 100,100,-100
     DATA -100,100,-100
     DATA -100,-100,100
     DATA 100,-100,100
     DATA 100,100,100
     DATA -100,100,100
     DATA 0,-150,0

     REM AQUI VIENE LA DEFINICION DE LAS CARAS
     REM EL PRIMER NUMERO ES EL NUMERO TOTAL DE CARAS
     REM DESPUES VIENE LA DEFINICION DE ESTAS:
     REM PRIMERO VIENE EL NUMERO DE LADOS DE LA CARA;
     REM LUEGO LOS VERTICES, DEFINIDOS EN ORDEN ANTIHORARIO
     REM POR ULTIMO, SU COLOR (DE 2 A 15)

     DATA 9
     DATA 4,0,1,2,3,2
     DATA 4,7,6,5,4,3
     DATA 4,1,5,6,2,4
     DATA 4,7,3,2,6,5
     DATA 4,0,3,7,4,7
     DATA 3,0,8,1,9
     DATA 3,1,8,5,11
     DATA 3,5,8,4,13
     DATA 3,4,8,0,15

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

