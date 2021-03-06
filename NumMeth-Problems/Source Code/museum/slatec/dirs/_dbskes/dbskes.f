      SUBROUTINE DBSKES (XNU, X, NIN, BKE)
      DOUBLE PRECISION XNU, X, BKE(*), BKNU1, V, VINCR, VEND, ALNBIG,
     1  D1MACH, DIRECT
      SAVE ALNBIG
      DATA ALNBIG / 0.D0 /
C***FIRST EXECUTABLE STATEMENT  DBSKES
      IF (ALNBIG.EQ.0.D0) ALNBIG = LOG (D1MACH(2))
C
      V = ABS(XNU)
      N = ABS(NIN)
C
      IF (V .GE. 1.D0) CALL XERMSG ('SLATEC', 'DBSKES',
     +   'ABS(XNU) MUST BE LT 1', 2, 2)
      IF (X .LE. 0.D0) CALL XERMSG ('SLATEC', 'DBSKES', 'X IS LE 0', 3,
     +   2)
      IF (N .EQ. 0) CALL XERMSG ('SLATEC', 'DBSKES',
     +   'N THE NUMBER IN THE SEQUENCE IS 0', 4, 2)
C
      CALL D9KNUS (V, X, BKE(1), BKNU1, ISWTCH)
      IF (N.EQ.1) RETURN
C
      VINCR = SIGN (1.0, REAL(NIN))
      DIRECT = VINCR
      IF (XNU.NE.0.D0) DIRECT = VINCR*SIGN(1.D0, XNU)
      IF (ISWTCH .EQ. 1 .AND. DIRECT .GT. 0.) CALL XERMSG ('SLATEC',
     +   'DBSKES', 'X SO SMALL BESSEL K-SUB-XNU+1 OVERFLOWS', 5, 2)
      BKE(2) = BKNU1
C
      IF (DIRECT.LT.0.) CALL D9KNUS (ABS(XNU+VINCR), X, BKE(2), BKNU1,
     1  ISWTCH)
      IF (N.EQ.2) RETURN
C
      VEND = ABS (XNU+NIN) - 1.0D0
      IF ((VEND-.5D0)*LOG(VEND)+0.27D0-VEND*(LOG(X)-.694D0) .GT.
     +   ALNBIG) CALL XERMSG ('SLATEC', 'DBSKES',
     +      'X SO SMALL OR ABS(NU) SO BIG THAT BESSEL K-SUB-NU ' //
     +      'OVERFLOWS', 5, 2)
C
      V = XNU
      DO 10 I=3,N
        V = V + VINCR
        BKE(I) = 2.0D0*V*BKE(I-1)/X + BKE(I-2)
 10   CONTINUE
C
      RETURN
      END
