REM PROGRAMA DE DEMOSTRACION 11
REM ROTACION DE UN CILINDRO EN TRES DIMENSIONES
REM CON ELIMINACION DE SUPERFICIES OCULTAS
REM POR EL METODO DEL VECTOR NORMAL AL PLANO

REM CONTROLES:
REM Q, A: ROTAR EN EL EJE X
REM P, O: ROTAR EN EL EJE Y
REM K, L: ROTAR EN EL EJE Z
REM S: TERMINAR

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

REM INCR ES EL FACTOR DE INCREMENTO POR CADA PULSACION DE TECLA
REM SI EL PROGRAMA VA MUY RAPIDO, REDUCE SU VALOR

INCR = 3.141592 / 18

REM D ES LA DISTANCIA DESDE EL OBSERVADOR A LA PANTALLA EN PIXELS

D = 1000

REM INICIO

REM ESTOS SON LOS ANGULOS INICIALES PARA LAS COORDENADAS X,Y,Z

AX = 0
AY = 0
AZ = 0

REM ESTOS SON LOS DATOS QUE DEFINEN AL CILINDRO:
REM ALTURA: SU ALTURA EN PIXEL (REFERIDA A UNA PANTALLA DE 640 x 480)
REM RADIO1: RADIO DE LA BASE SUPERIOR
REM RADIO2: RADIO DE LA BASE INFERIOR
REM PASO: NUMERO DE LADOS PARA LAS BASES

ALTURA = 250
RADIO1 = 75
RADIO2 = 75
PASO = 15

REM CALCULAMOS LAS CONSTANTES

PI = 3.141591 / 180
TOTV = PASO * 2
DIM V(TOTV, 2)
ALT = ALTURA / -2
CUENTA = 0
PASO2 = 360 / PASO

REM CALCULAMOS LOS VERTICES DEL CILINDRO

FOR N = 0 TO 360 - (PASO2 / 2) STEP PASO2
     GRADO = N * PI
     V(CUENTA, 0) = RADIO1 * SIN(GRADO)
     V(CUENTA, 1) = ALT
     V(CUENTA, 2) = RADIO1 * COS(GRADO)
     V(CUENTA + PASO, 2) = RADIO2 * COS(GRADO)
     V(CUENTA + PASO, 1) = -ALT
     V(CUENTA + PASO, 0) = RADIO2 * SIN(GRADO)
     CUENTA = CUENTA + 1
NEXT N

REM CALCULAMOS LOS LADOS DE LAS DOS BASES
REM HAY PASO+2 CARAS, PUES HAY QUE INCLUIR LAS DOS BASES

TOTL = PASO + 2
DIM L(TOTL + 2, PASO)

REM ASIGNAMOS A CADA BASE TANTOS LADOS COMO PASOS DIMOS

L(0, 0) = PASO
L(1, 0) = PASO

REM ASIGNAMOS LOS VERTICES A LAS BASES

FOR N = 1 TO PASO
     L(0, N) = N - 1
    
     REM A LA BASE SEGUNDA SE LE DAN LOS VERTICES EN ORDEN DECRECIENTE
     REM PUES DEBEN IR EN SENTIDO ANTIHORARIO
    
     L(1, N) = PASO * 2 - N
NEXT N

REM ASIGNAMOS LOS VERTICES A LOS LADOS

FOR N = 0 TO PASO - 1
     SIG = N + 1
     IF SIG = PASO THEN
          SIG = 0
     END IF
    
     REM 4 LADOS
    
     L(N + 2, 0) = 4
    
     REM DESDE EL VERTICE N DE LA BASE 1
    
     L(N + 2, 1) = N
    
     REM AL VERTICE N DE LA BASE 2
    
     L(N + 2, 2) = N + PASO
    
     REM AHORA AL VERTICE N+1 DE LA BASE 2
    
     L(N + 2, 3) = SIG + PASO
    
     REM Y AL VERTICE N+1 DE LA BASE 1
    
     L(N + 2, 4) = SIG
NEXT N

DIM C(TOTV - 1, 2)

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
     FOR N = 0 TO TOTL - 1
         
               REM CALCULO LAS COORDENADAS DE DOS VECTORES CONSECUTIVOS
               REM DE LA CARA A TESTEAR

               X1 = V(L(N, 2), 0) - V(L(N, 1), 0)
               Y1 = V(L(N, 2), 1) - V(L(N, 1), 1)
               Z1 = V(L(N, 2), 2) - V(L(N, 1), 2)
               X2 = V(L(N, 3), 0) - V(L(N, 2), 0)
               Y2 = V(L(N, 3), 1) - V(L(N, 2), 1)
               Z2 = V(L(N, 3), 2) - V(L(N, 2), 2)
         
               REM CALCULO LAS COORDENADAS DE LOS VECTORES NORMALES
               REM POR MEDIO DEL PRODUCTO VECTORIAL
         
               X = (Y1 * Z2) - (Y2 * Z1)
               Y = (Z1 * X2) - (Z2 * X1)
               Z = (X1 * Y2) - (X2 * Y1)
          
               REM CALCULAMOS LAS COORDENADAS DEL VECTOR DE VISION, QUE UNE
               REM EL OJO CON EL PRIMER VERTICE DE LA CARA

               X1 = V(L(N, 1), 0)
               Y1 = V(L(N, 1), 1)
               Z1 = V(L(N, 1), 2) + D

               REM CALCULAMOS EL PRODUCTO ESCALAR DEL VECTOR NORMAL A LA
               REM CARA CON EL VECTOR DE VISION
 
               ESCALAR = (X * X1) + (Y * Y1) + (Z * Z1)
         
               REM Y APLICAMOS EL TEST DE VISIBILIDAD
               
               IF ESCALAR > 0 THEN
                    NLIN = L(N, 0)
                    FOR F = 1 TO NLIN
                         SIGUIE = F + 1
                         IF F = NLIN THEN SIGUIE = 1
                         XI = C(L(N, F), 0)
                         YI = C(L(N, F), 1)
                         XF = C(L(N, SIGUIE), 0)
                         YF = C(L(N, SIGUIE), 1)
                         GOSUB PINTAR
                    NEXT F
               END IF
          NEXT N
     A$ = INKEY$
     WHILE A$ = ""
         A$ = INKEY$
     WEND
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
 
REM PINTAMOS CON EL COLOR NUMCOLOR-1 PARA COGER SIEMPRE EL MAS CLARO
REM DE LOS QUE TENGAMOS

     LINE (XI * RELX, YI * RELY)-(XF * RELX, YF * RELY), NUMCOLOR - 1
     RETURN

PREPARAR:
  
     ON TARJETA GOSUB CGA, EGA, MCGA, ATT, HERCULES
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

MCGA:
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

