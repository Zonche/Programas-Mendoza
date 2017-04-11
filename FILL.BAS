REM RUTINA DE FILL

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

REM ESTA ES LA SUBRUTINA DE FILL

FILL:
     
     HEY = 0
     PUNTERO = 0
     A = POINT(X, Y)
     WHILE (A <> COLORES OR PUNTERO > 0) AND HEY = 0
          A = POINT(X, Y)
          WHILE (A <> COLORES)
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
     WHILE A <> COLORES AND X1 < XMAX AND X1 >= 0
          A = POINT(X1, Y + 1)
          IF A <> COLORES AND ESTADO1 = 0 THEN
               METY = Y + 1
               GOSUB METER
               ESTADO1 = 1
          END IF
          IF A = COLORES THEN
               ESTADO1 = 0
          END IF
          A = POINT(X1, Y - 1)
          IF A <> COLORES AND ESTADO2 = 0 THEN
               METY = Y - 1
               GOSUB METER
               ESTADO2 = 1
          END IF
          IF A = COLORES THEN
               ESTADO2 = 0
          END IF
          X1 = X1 + 1
          A = POINT(X1, Y)
     WEND
     HEY = 1
     IF X1 < XMAX AND X1 >= 0 THEN
          LINE (X, Y)-(X1, Y), COLORES
          HEY = 0
     END IF
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


