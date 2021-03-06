REM PROGRAMA GENERADOR DE UNA ESFERA 3D

REM ESTOS SON LOS DATOS QUE DEFINEN A LA ESFERA:
REM RADIO1: RADIO EN EL EJE Y (ALTURA)
REM RADIO2: RADIO EN EL EJE X (ANCHURA)
REM RADIO3: RADIO EN EL EJE Z (PROFUNDIDAD)
REM PASO: NUMERO DE LADOS PARA LAS BASES

RADIO1 = 200
RADIO2 = 200
RADIO3 = 200
PASO = 20

REM CALCULAMOS LAS CONSTANTES

PI = 3.1416 / 180
TOTV = 2 + PASO * ((PASO / 2) - 1)
DIM V(TOTV, 2)
CUENTA = 2
PASO2 = 360 / PASO

REM CALCULAMOS EL VERTICE INFERIOR Y EL SUPERIOR DE LA ESFERA

V(0, 0) = 0
V(0, 1) = RADIO1
V(0, 2) = 0
V(1, 0) = 0
V(1, 1) = -RADIO1
V(1, 2) = 0

REM CALCULAMOS LA ALTURA DE CADA CINTURON DE PUNTOS

PRINT "CALCULANDO LOS PUNTOS"
PRINT "UN MOMENTO, POR FAVOR"
FOR F = PASO2 TO 180 - (PASO2 / 2) STEP PASO2
     GRADO2 = F * PI
     RADIOS2 = RADIO2 * SIN(GRADO2)
     RADIOS3 = RADIO3 * SIN(GRADO2)
     ALT2 = RADIO1 * COS(GRADO2)

REM CALCULAMOS LOS VERTICES DEL CINTURON

FOR N = 0 TO 360 - (PASO2 / 2) STEP PASO2
     GRADO = N * PI
     V(CUENTA, 0) = RADIOS2 * SIN(GRADO)
     V(CUENTA, 1) = ALT2
     V(CUENTA, 2) = RADIOS3 * COS(GRADO)
     CUENTA = CUENTA + 1
NEXT N
NEXT F

CLS
PRINT "CALCULANDO LAS CARAS"
PRINT "UN MOMENTO, POR FAVOR"

TOTL = PASO * INT(PASO / 2)
DIM L%(TOTL, PASO)

REM CALCULAMOS LOS LADOS DE LA BASE INFERIOR
  
FOR N = 0 TO PASO - 1
     SIG = N + 1
     IF N = PASO - 1 THEN
	  SIG = 0
     END IF
     L%(N, 0) = 3
     L%(N, 1) = 0
     L%(N, 2) = SIG + 2
     L%(N, 3) = N + 2
NEXT N

REM ASIGNAMOS LOS VERTICES A LOS LADOS

FOR F = 0 TO (INT(PASO / 2)) - 3
     FOR N = 0 TO PASO - 1
	  SIG = N + 1
	  IF SIG = PASO THEN
	       SIG = 0
	  END IF
	  CUENTA = N + PASO + F * PASO
	  L%(CUENTA, 0) = 4
	  L%(CUENTA, 1) = SIG + F * PASO + 2
	  L%(CUENTA, 2) = SIG + PASO + F * PASO + 2
	  L%(CUENTA, 3) = N + PASO + F * PASO + 2
	  L%(CUENTA, 4) = N + F * PASO + 2
     NEXT N
NEXT F

REM CALCULAMOS LOS LADOS DE LA BASE SUPERIOR

F = PASO * ((INT(PASO / 2)) - 2)
CUENTA = CUENTA + 1
FOR N = 0 TO PASO - 1
     SIG = N + 1
     IF N = PASO - 1 THEN
	  SIG = 0
     END IF
     L%(N + CUENTA, 0) = 3
     L%(N + CUENTA, 1) = 1
     L%(N + CUENTA, 2) = N + 2 + F
     L%(N + CUENTA, 3) = SIG + 2 + F
NEXT N

