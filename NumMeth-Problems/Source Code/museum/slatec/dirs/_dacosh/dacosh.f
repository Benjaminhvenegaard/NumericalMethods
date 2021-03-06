      DOUBLE PRECISION FUNCTION DACOSH (X)
      DOUBLE PRECISION X, DLN2, XMAX,  D1MACH
      SAVE DLN2, XMAX
      DATA DLN2 / 0.6931471805 5994530941 7232121458 18 D0 /
      DATA XMAX / 0.D0 /
C***FIRST EXECUTABLE STATEMENT  DACOSH
      IF (XMAX.EQ.0.D0) XMAX = 1.0D0/SQRT(D1MACH(3))
C
      IF (X .LT. 1.D0) CALL XERMSG ('SLATEC', 'DACOSH',
     +   'X LESS THAN 1', 1, 2)
C
      IF (X.LT.XMAX) DACOSH = LOG (X+SQRT(X*X-1.0D0))
      IF (X.GE.XMAX) DACOSH = DLN2 + LOG(X)
C
      RETURN
      END
