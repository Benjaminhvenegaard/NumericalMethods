      COMPLEX FUNCTION CGAMR (Z)
      COMPLEX Z, CLNGAM
C***FIRST EXECUTABLE STATEMENT  CGAMR
      CGAMR = (0.0, 0.0)
      X = REAL (Z)
      IF (X.LE.0.0 .AND. AINT(X).EQ.X .AND. AIMAG(Z).EQ.0.0) RETURN
C
      CALL XGETF (IROLD)
      CALL XSETF (1)
      CGAMR = CLNGAM(Z)
      CALL XERCLR
      CALL XSETF (IROLD)
      CGAMR = EXP (-CGAMR)
C
      RETURN
      END