DECLARE FUNCTION RAN0! (IDUM&)

FUNCTION RAN0 (IDUM&) STATIC
DIM V(97)
IF IDUM& < 0 OR IFF = 0 THEN
  IFF = 1
  ISEED& = ABS(IDUM&)
  IDUM& = 1
  FOR J = 1 TO 97
    DUM = RND(ISEED&)
  NEXT J
  FOR J = 1 TO 97
    V(J) = RND(ISEED&)
  NEXT J
  Y = RND(ISEED&)
END IF
J = 1 + INT(97! * Y)
IF J > 97 OR J < 1 THEN PRINT "Abnormal exit": EXIT FUNCTION
Y = V(J)
RAN0 = Y
V(J) = RND(ISEED&)
END FUNCTION

