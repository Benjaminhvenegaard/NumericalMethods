      SUBROUTINE CRATI (Z, FNU, N, CY, TOL)
      COMPLEX CDFNU, CONE, CY, CZERO, PT, P1, P2, RZ, T1, Z
      REAL AK, AMAGZ, AP1, AP2, ARG, AZ, DFNU, FDNU, FLAM, FNU, FNUP,
     * RAP1, RHO, TEST, TEST1, TOL
      INTEGER I, ID, IDNU, INU, ITIME, K, KK, MAGZ, N
      DIMENSION CY(N)
      DATA CZERO, CONE / (0.0E0,0.0E0), (1.0E0,0.0E0) /
C***FIRST EXECUTABLE STATEMENT  CRATI
      AZ = ABS(Z)
      INU = FNU
      IDNU = INU + N - 1
      FDNU = IDNU
      MAGZ = AZ
      AMAGZ = MAGZ+1
      FNUP = MAX(AMAGZ,FDNU)
      ID = IDNU - MAGZ - 1
      ITIME = 1
      K = 1
      RZ = (CONE+CONE)/Z
      T1 = CMPLX(FNUP,0.0E0)*RZ
      P2 = -T1
      P1 = CONE
      T1 = T1 + RZ
      IF (ID.GT.0) ID = 0
      AP2 = ABS(P2)
      AP1 = ABS(P1)
C-----------------------------------------------------------------------
C     THE OVERFLOW TEST ON K(FNU+I-1,Z) BEFORE THE CALL TO CBKNX
C     GUARANTEES THAT P2 IS ON SCALE. SCALE TEST1 AND ALL SUBSEQUENT
C     P2 VALUES BY AP1 TO ENSURE THAT AN OVERFLOW DOES NOT OCCUR
C     PREMATURELY.
C-----------------------------------------------------------------------
      ARG = (AP2+AP2)/(AP1*TOL)
      TEST1 = SQRT(ARG)
      TEST = TEST1
      RAP1 = 1.0E0/AP1
      P1 = P1*CMPLX(RAP1,0.0E0)
      P2 = P2*CMPLX(RAP1,0.0E0)
      AP2 = AP2*RAP1
   10 CONTINUE
      K = K + 1
      AP1 = AP2
      PT = P2
      P2 = P1 - T1*P2
      P1 = PT
      T1 = T1 + RZ
      AP2 = ABS(P2)
      IF (AP1.LE.TEST) GO TO 10
      IF (ITIME.EQ.2) GO TO 20
      AK = ABS(T1)*0.5E0
      FLAM = AK + SQRT(AK*AK-1.0E0)
      RHO = MIN(AP2/AP1,FLAM)
      TEST = TEST1*SQRT(RHO/(RHO*RHO-1.0E0))
      ITIME = 2
      GO TO 10
   20 CONTINUE
      KK = K + 1 - ID
      AK = KK
      DFNU = FNU + (N-1)
      CDFNU = CMPLX(DFNU,0.0E0)
      T1 = CMPLX(AK,0.0E0)
      P1 = CMPLX(1.0E0/AP2,0.0E0)
      P2 = CZERO
      DO 30 I=1,KK
        PT = P1
        P1 = RZ*(CDFNU+T1)*P1 + P2
        P2 = PT
        T1 = T1 - CONE
   30 CONTINUE
      IF (REAL(P1).NE.0.0E0 .OR. AIMAG(P1).NE.0.0E0) GO TO 40
      P1 = CMPLX(TOL,TOL)
   40 CONTINUE
      CY(N) = P2/P1
      IF (N.EQ.1) RETURN
      K = N - 1
      AK = K
      T1 = CMPLX(AK,0.0E0)
      CDFNU = CMPLX(FNU,0.0E0)*RZ
      DO 60 I=2,N
        PT = CDFNU + T1*RZ + CY(K+1)
        IF (REAL(PT).NE.0.0E0 .OR. AIMAG(PT).NE.0.0E0) GO TO 50
        PT = CMPLX(TOL,TOL)
   50   CONTINUE
        CY(K) = CONE/PT
        T1 = T1 - CONE
        K = K - 1
   60 CONTINUE
      RETURN
      END
