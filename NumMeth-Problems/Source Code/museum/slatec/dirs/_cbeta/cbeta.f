      COMPLEX FUNCTION CBETA (A, B)
      COMPLEX A, B, CGAMMA, CLBETA
      EXTERNAL CGAMMA
      SAVE XMAX
      DATA XMAX / 0.0 /
C***FIRST EXECUTABLE STATEMENT  CBETA
      IF (XMAX.EQ.0.0) THEN
         CALL GAMLIM (XMIN, XMAXT)
         XMAX = XMAXT
      ENDIF
C
      IF (REAL(A) .LE. 0.0 .OR. REAL(B) .LE. 0.0) CALL XERMSG ('SLATEC',
     +   'CBETA', 'REAL PART OF BOTH ARGUMENTS MUST BE GT 0', 1, 2)
C
      IF (REAL(A)+REAL(B).LT.XMAX) CBETA = CGAMMA(A) * (CGAMMA(B)/
     1  CGAMMA(A+B) )
      IF (REAL(A)+REAL(B).LT.XMAX) RETURN
C
      CBETA = EXP (CLBETA(A, B))
C
      RETURN
      END