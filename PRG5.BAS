REM PROGRAMA DE DEMOSTRACION 5
REM ROTACION DE UN CUBO EN TRES DIMENSIONES
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
DIM L(TOTL - 1, 4)
FOR N = 0 TO TOTL - 1
     READ NLIN
     L(N, 0) = NLIN
     FOR F = 1 TO NLIN
          READ L(N, F)
     NEXT F
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
     REM EL PRIMER VALOR ES EL NUMERO DE SEGMENTOS DE LA CARA
     REM DESPUES VIENEN LOS VERTICES DEFINIDOS EN ORDEN ANTIHORARIO
    
     DATA 9
     DATA 4,0,1,2,3
     DATA 4,7,6,5,4
     DATA 4,1,5,6,2
     DATA 4,7,3,2,6
     DATA 4,0,3,7,4
     DATA 3,0,8,1
     DATA 3,1,8,5
     DATA 3,5,8,4
     DATA 3,4,8,0

