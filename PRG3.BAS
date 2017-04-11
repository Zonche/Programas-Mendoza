REM PROGRAMA DE DEMOSTRACION 3
REM ROTACION DE UN CUBO EN TRES DIMENSIONES

REM CONTROLES:
REM Q, A: ROTAR EN EL EJE X
REM P, O: ROTAR EN EL EJE Y
REM K, L: ROTAR EN EL EJE Z
REM S: TERMINAR

REM INDICA CUAL ES LA TARJETA GRAFICA QUE PREFIERES EN LA VARIABLE TARJETA:
REM 1=CGA 4 COLORES (320 x 200 puntos)
REM 2=CGA 2 COLORES (640 x 200 puntos)
REM 3=EGA 16 COLORES (640 x 350 puntos)
REM 4=MCGA 2 COLORES (640 x 480 puntos)
REM 5=MCGA 256 COLORES (320 x 200 puntos)
REM 6=VGA/SVGA 16 COLORES (640 x 480 puntos)
REM 7=AT&T 2 COLORES (640 x 400 puntos)
REM 8=HERCULES 2 COLORES (720 x 348 puntos)
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

REM LEEMOS LOS SEGMENTOS

READ TOTL
DIM L(TOTL - 1, 3)
FOR N = 0 TO TOTL - 1
     FOR F = 0 TO 2
          READ L(N, F)
     NEXT F
NEXT N
DIM C(TOTV - 1, 1)

REM AJUSTAMOS LOS COLORES

FOR N = 0 TO TOTL - 1
     COLORES = L(N, 2)
     IF NUMCOLOR = 2 THEN COLORES = 1
     IF NUMCOLOR = 4 THEN COLORES = COLORES * 3 / 16 + 1
     L(N, 2) = COLORES
NEXT N

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
    
     REM IMPRIMIMOS EL CUBO A PARTIR DE LAS
     REM COORDENADAS CALCULADAS INICIALMENTE

     FOR N = 0 TO TOTL - 1
               XI = C(L(N, 0), 0)
               YI = C(L(N, 0), 1)
               XF = C(L(N, 1), 0)
               YF = C(L(N, 1), 1)
               COLORES = L(N, 2)
               GOSUB PINTAR
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
  
     LINE (XI * RELX, YI * RELY)-(XF * RELX, YF * RELY), COLORES
     RETURN

PREPARAR:
  
     ON TARJETA GOSUB CGA1, CGA2, EGA, MCGA1, MCGA2, VGA, ATT, HERCULES
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

EGA:
     XMAX = 640
     YMAX = 350
     SCREEN 9
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

     REM AQUI VIENE LA DEFINICION DE LOS SEGMENTOS
     REM EL PRIMER NUMERO ES EL NUMERO DE LINEAS EN TOTAL
     REM DESPUES VIENE LA DEFINICION DE ESTAS:
     REM EL PRIMER NUMERO ES LA COORDENADA INICIAL
     REM (REFERIDA A LA BASE DE DATOS DE LOS VERTICES)
     REM EL SEGUNDO NUMERO ES LA COORDENADA FINAL
     REM EL TERCER NUMERO ES EL COLOR

     DATA 16
     DATA 0,1,1
     DATA 1,2,2
     DATA 2,3,3
     DATA 3,0,4
     DATA 4,5,5
     DATA 5,6,6
     DATA 6,7,7
     DATA 7,4,8
     DATA 0,4,9
     DATA 1,5,10
     DATA 2,6,11
     DATA 3,7,12
     DATA 0,8,9
     DATA 1,8,9
     DATA 4,8,9
     DATA 5,8,9
    

