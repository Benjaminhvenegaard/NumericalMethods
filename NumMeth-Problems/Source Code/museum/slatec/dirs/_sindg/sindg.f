      FUNCTION SINDG (X)
C JUNE 1977 EDITION.   W. FULLERTON, C3, LOS ALAMOS SCIENTIFIC LAB.
      SAVE RADDEG
      DATA RADDEG / .017453292519943296E0 /
C
C***FIRST EXECUTABLE STATEMENT  SINDG
      SINDG = SIN (RADDEG*X)
C
      IF (MOD(X,90.).NE.0.) RETURN
      N = ABS(X)/90.0 + 0.5
      N = MOD (N, 2)
      IF (N.EQ.0) SINDG = 0.
      IF (N.EQ.1) SINDG = SIGN (1.0, SINDG)
C
      RETURN
      END
