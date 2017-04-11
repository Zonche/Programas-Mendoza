REM PROGRAMA DE DEMOSTRACION 4
REM EFECTOS PRODUCIDOS AL COMBINAR ROTACIONES Y TRASLACIONES
REM EL EJE DE ROTACION ES SIEMPRE LA LINEA BLANCA.

REM PARA PARAR CADA DEMOSTRACION, PULSAR UNA TECLA CUALQUIERA

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

REM INCR ES EL INCREMENTO EN ROTACIONES. REDUCELO PARA QUE VAYA MAS LENTA.

INCR = 3.141592 / 18

REM D ES LA DISTANCIA DESDE EL OBSERVADOR A LA PANTALLA EN PIXELS

D = 1000

REM INICIO

REM LEEMOS LA TABLA DE DATOS

RESTORE DATOS

REM LEEMOS LOS VERTICES
REM DEJAMOS SITIO PARA DOS MAS, QUE SERAN LOS VERTICES DEL EJE DE ROTACION

READ TOTV
DIM V(TOTV - 1, 2)
FOR N = 0 TO TOTV - 1
     FOR F = 0 TO 2
          READ V(N, F)
     NEXT F
NEXT N

REM LEEMOS LOS SEGMENTOS
REM DEJAMOS SITIO PARA UNO MAS, QUE SERA EL EJE DE ROTACION
REM LOS PUNTOS DE ESTE YA VIENEN DEFINIDOS EN LAS DATAs
REM VER EL REM FINAL EN ESTAS

READ TOTL
DIM L(TOTL - 1, 3)
FOR N = 0 TO TOTL - 1
     FOR F = 0 TO 2
          READ L(N, F)
     NEXT F
NEXT N

REM AJUSTAMOS LOS COLORES

FOR N = 0 TO TOTL - 1
     COLORES = L(N, 2)
     IF NUMCOLOR = 2 THEN COLORES = 1
     IF NUMCOLOR = 4 THEN COLORES = COLORES * 3 / 16 + 1
     L(N, 2) = COLORES
NEXT N

DIM C(TOTV - 1, 1)

REM ROTAMOS PRIMERO E INCLINAMOS LUEGO
    
     AZ = 3.141592 / 9
     SAZ = SIN(AZ)
     CAZ = COS(AZ)
     AY = 0
     PRINT "PRIMERO ROTAMOS Y LUEGO INCLINAMOS"
     PRINT "PULSA UNA TECLA PARA EMPEZAR"
     A$ = INKEY$
     WHILE A$ = ""
          A$ = INKEY$
     WEND

WHILE INKEY$ = ""
     SAY = SIN(AY)
     CAY = COS(AY)
     FOR N = 0 TO TOTV - 1
          X = V(N, 0)
          Y = V(N, 1)
          Z = V(N, 2)
         
          REM AQUI LO ROTAMOS
         
          C1 = X
          C2 = Z
          SA = SAY
          CA = CAY
          GOSUB ROTAR
         
          REM Y AQUI LO INCLINAMOS
         
          Z = C2
          C2 = Y
          SA = SAZ
          CA = CAZ
          GOSUB ROTAR
          X = C1
          Y = C2
          GOSUB ECUACION
          C(N, 0) = X
          C(N, 1) = Y
     NEXT N
     GOSUB IMPRESION
     AY = AY + INCR
     IF AY > 6.283182 THEN AY = 0
WEND

REM INCLINAMOS PRIMERO Y ROTAMOS LUEGO
   
     CLS
     AZ = 3.141592 / 9
     SAZ = SIN(AZ)
     CAZ = COS(AZ)
     AY = 0
     PRINT "PRIMERO INCLINAMOS Y LUEGO ROTAMOS"
     PRINT "PULSA UNA TECLA PARA EMPEZAR"
     A$ = INKEY$
     WHILE A$ = ""
          A$ = INKEY$
     WEND

WHILE INKEY$ = ""
     SAY = SIN(AY)
     CAY = COS(AY)
     FOR N = 0 TO TOTV - 1
          X = V(N, 0)
          Y = V(N, 1)
          Z = V(N, 2)
         
          REM AQUI LO INCLINAMOS
          REM SOLO SI NO SON LAS COORDENADAS DEL EJE
         
          C1 = X
          C2 = Y
          IF N < TOTV - 2 THEN
               SA = SAZ
               CA = CAZ
               GOSUB ROTAR
          END IF
         
          REM Y AQUI LO ROTAMOS
         
          Y = C2
          C2 = Z
          SA = SAY
          CA = CAY
          GOSUB ROTAR
          X = C1
          Z = C2
          GOSUB ECUACION
          C(N, 0) = X
          C(N, 1) = Y
     NEXT N
     GOSUB IMPRESION
     AY = AY + INCR
     IF AY > 6.283182 THEN AY = 0
WEND

REM ROTAMOS PRIMERO Y TRASLADAMOS LUEGO

     CLS
     INCX = 150
     AY = 0
     PRINT "PRIMERO ROTAMOS Y LUEGO TRASLADAMOS"
     PRINT "PULSA UNA TECLA PARA EMPEZAR"
     A$ = INKEY$
     WHILE A$ = ""
          A$ = INKEY$
     WEND

WHILE INKEY$ = ""
     SAY = SIN(AY)
     CAY = COS(AY)
     FOR N = 0 TO TOTV - 1
          X = V(N, 0)
          Y = V(N, 1)
          Z = V(N, 2)
         
          REM AQUI LO ROTAMOS
         
          C1 = X
          C2 = Z
          SA = SAY
          CA = CAY
          GOSUB ROTAR
         
          REM Y AQUI LE SUMAMOS INCX PARA TRASLADARLO
         
          X = C1 + INCX
          Z = C2
          GOSUB ECUACION
          C(N, 0) = X
          C(N, 1) = Y
     NEXT N
     GOSUB IMPRESION
     AY = AY + INCR
     IF AY > 6.283182 THEN AY = 0
WEND

REM TRASLADAMOS PRIMERO Y ROTAMOS LUEGO

     CLS
     INCX = 150
     AY = 0
     PRINT "PRIMERO TRASLADAMOS Y LUEGO ROTAMOS"
     PRINT "PULSA UNA TECLA PARA EMPEZAR"
     A$ = INKEY$
     WHILE A$ = ""
          A$ = INKEY$
     WEND

WHILE INKEY$ = ""
     SAY = SIN(AY)
     CAY = COS(AY)
     FOR N = 0 TO TOTV - 1
          X = V(N, 0)
          Y = V(N, 1)
          Z = V(N, 2)
         
          REM AQUI LE SUMAMOS INCX PARA TRASLADARLO
          REM SALVO QUE SE TRATE DEL EJE DE ROTACION

          IF N < TOTV - 2 THEN
               C1 = X + INCX
          ELSE
               C1 = X
          END IF
          C2 = Z
         
          REM Y AQUI LO ROTAMOS
         
          SA = SAY
          CA = CAY
          GOSUB ROTAR
          X = C1
          Z = C2
          GOSUB ECUACION
          C(N, 0) = X
          C(N, 1) = Y
     NEXT N
     GOSUB IMPRESION
     AY = AY + INCR
     IF AY > 6.283182 THEN AY = 0
WEND

NUEVO:
REM ROTACION ALREDEDOR DE UN EJE QUE FORMA 30 GRADOS CON EL X Y 60 CON EL Y

     CLS
     AZ = 3.141592 / 9
     SAZ = SIN(AZ)
     CAZ = COS(AZ)
     AY = 0
     PRINT "ROTACION ALREDEDOR DE UN EJE DISTINTO A LOS COORDENADOS"
     PRINT "PULSA UNA TECLA PARA EMPEZAR"
     A$ = INKEY$
     WHILE A$ = ""
          A$ = INKEY$
     WEND

WHILE INKEY$ = ""
     SAY = SIN(AY)
     CAY = COS(AY)
     AZ = 3.141591 * 30 / 180
     SAZ = SIN(AZ)
     CAZ = COS(AZ)
     FOR N = 0 TO TOTV - 1
          X = V(N, 0)
          Y = V(N, 1)
          Z = V(N, 2)
         
          REM AQUI LO INCLINAMOS 30 GRADOS SOBRE EL EJE Z
          REM SALVO QUE SEA EL EJE DE ROTACION

          C1 = X
          C2 = Y
          IF N < TOTV - 2 THEN
               SA = SAZ
               CA = CAZ
               GOSUB ROTAR
          END IF

          REM AQUI LO ROTAMOS
         
          Y = C2
          C2 = Z
          SA = SAY
          CA = CAY
          GOSUB ROTAR
         
          REM Y AQUI LO INCLINAMOS -30 GRADOS PARA DEVOLVERLO
          REM A LA POSICION INICIAL
         
          Z = C2
          C2 = Y
          SA = -SAZ
          CA = CAZ
          GOSUB ROTAR
          X = C1
          Y = C2
          GOSUB ECUACION
          C(N, 0) = X
          C(N, 1) = Y
     NEXT N
     GOSUB IMPRESION
     AY = AY + INCR
     IF AY > 6.283182 THEN AY = 0
WEND
END

REM ESTA ES LA SUBRUTINA COMUN DE IMPRESION

IMPRESION:
     CLS
     PRINT "(C) 1994 RASTER SOFT."
     FOR N = 0 TO TOTL - 1
          XI = C(L(N, 0), 0)
          YI = C(L(N, 0), 1)
          XF = C(L(N, 1), 0)
          YF = C(L(N, 1), 1)
          COLORES = L(N, 2)
          GOSUB PINTAR
     NEXT N
RETURN

REM SUBRUTINA DE PROYECCION PARA PASAR DE 3D A 2D

ECUACION:
     X = (X * D) / (Z + D) + REX / 2
     Y = (Y * D) / (Z + D) + REY / 2
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
    
     DATA 11
    
     DATA -50,-100,-50
     DATA 50,-100,-50
     DATA 50,100,-50
     DATA -50,100,-50
     DATA -50,-100,50
     DATA 50,-100,50
     DATA 50,100,50
     DATA -50,100,50
     DATA 0,-150,0
    
     REM ESTAS DOS SON LAS COORDENADAS DEL EJE DE ROTACION.
     REM PUEDEN SER CAMBIADAS DURANTE EL TRANSCURSO DEL
     REM PROGRAMA PARA ADAPTARSE A CADA EJEMPLO.
   
     DATA 0,140,0
     DATA 0,-190,0
   

     REM AQUI VIENE LA DEFINICION DE LOS SEGMENTOS
     REM EL PRIMER NUMERO ES EL NUMERO DE LINEAS EN TOTAL
     REM DESPUES VIENE LA DEFINICION DE ESTAS:
     REM EL PRIMER NUMERO ES LA COORDENADA INICIAL
     REM (REFERIDA A LA BASE DE DATOS DE LOS VERTICES)
     REM EL SEGUNDO NUMERO ES LA COORDENADA FINAL
     REM EL TERCER NUMERO ES EL COLOR

     DATA 17
    
     REM ESTE SEGMENTO ES EL EJE DE ROTACION

     DATA 9,10,15
    
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
   
REM ESTE SEGMENTO ES EL EJE DE ROTACION

     DATA 9,10,16

