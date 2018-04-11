      SUBROUTINE SDNTP (H, K, N, NQ, T, TOUT, YH, Y)
      INTEGER I, J, JJ, K, KK, KUSED, N, NQ
      REAL FACTOR, H, R, T, TOUT, Y(*), YH(N,*)
C***FIRST EXECUTABLE STATEMENT  SDNTP
      IF (K .EQ. 0) THEN
        DO 10 I = 1,N
 10       Y(I) = YH(I,NQ+1)
        R = ((TOUT - T)/H)
        DO 20 JJ = 1,NQ
          J = NQ + 1 - JJ
          DO 20 I = 1,N
 20         Y(I) = YH(I,J) + R*Y(I)
      ELSE
        KUSED = MIN(K, NQ)
        FACTOR = 1.E0
        DO 40 KK = 1,KUSED
 40       FACTOR = FACTOR*(NQ+1-KK)
        DO 50 I = 1,N
 50       Y(I) = FACTOR*YH(I,NQ+1)
        R = ((TOUT - T)/H)
        DO 80 JJ = KUSED+1,NQ
          J = KUSED + 1 + NQ - JJ
          FACTOR = 1.E0
          DO 60 KK = 1,KUSED
 60         FACTOR = FACTOR*(J-KK)
          DO 70 I = 1,N
 70         Y(I) = FACTOR*YH(I,J) + R*Y(I)
 80       CONTINUE
        DO 100 I = 1,N
 100      Y(I) = Y(I)*H**(-KUSED)
      END IF
      RETURN
      END
