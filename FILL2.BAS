REM RUTINA DE FILL DE ENTRAMADOS

REM INDICA CUAL ES LA TARJETA GRAFICA QUE PREFIERES EN LA VARIABLE TARJETA:
REM 1=CGA 4 COLORES (320 x 200 puntos)
REM 2=EGA 16 COLORES (640 x 350 puntos)
REM 3=MCGA 256 COLORES (320 x 200 puntos)
REM 4=VGA/SVGA 16 COLORES (640 x 480 puntos)

TARJETA = 1
GOSUB PREPARAR

REM ESTAS VARIABLES SE USAN PARA LA SIMULACION DE LA PILA O STACK
REM DEL FILL

DIM PILA(20, 1)
PUNTERO = 0

REM AQUI LEEMOS LOS PATRONES

DIM PATRONES(24, 3, 5)
RESTORE PATRONES
FOR N = 0 TO 12
     FOR F = 0 TO 3
          FOR Z = 0 TO 5
               READ PATRONES(N, F, Z)
               PATRONES(24 - N, F, Z) = 1 - PATRONES(N, F, Z)
          NEXT Z
     NEXT F
NEXT N

REM ESTA ES LA SUBRUTINA DE FILL
REM EN X VA LA COORDENADA X INICIAL
REM EN Y VA LA COORDENADA Y INICIAL
REM EN COLORES VA EL COLOR CON EL QUE SE QUIERE RELLENAR (DEBE SER MAYOR DE 2)
REM Y EN GRIS VA EL PATRON O ENTRAMADO QUE SE DESEA (DE 0 A 16)

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
  
     ON TARJETA GOSUB CGA, EGA, MCGA, VGA
     CLS
     RETURN

CGA:
     XMAX = 320
     YMAX = 200
     SCREEN 1
     NUMCOLOR = 4
     RETURN

EGA:
     XMAX = 640
     YMAX = 350
     SCREEN 9
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


