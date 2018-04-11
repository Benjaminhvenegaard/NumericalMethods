      SUBROUTINE BESKS (XNU, X, NIN, BK)
      DIMENSION BK(*)
      SAVE XMAX
      DATA XMAX / 0.0 /
C***FIRST EXECUTABLE STATEMENT  BESKS
      IF (XMAX.EQ.0.0) XMAX = -LOG (R1MACH(1))
C
      IF (X .GT. XMAX) CALL XERMSG ('SLATEC', 'BESKS',
     +   'X SO BIG BESSEL K UNDERFLOWS', 1, 2)
C
      CALL BESKES (XNU, X, NIN, BK)
C
      EXPXI = EXP (-X)
      N = ABS (NIN)
      DO 20 I=1,N
        BK(I) = EXPXI * BK(I)
 20   CONTINUE
C
      RETURN
      END
