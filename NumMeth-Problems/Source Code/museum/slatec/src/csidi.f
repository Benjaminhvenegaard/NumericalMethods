      SUBROUTINE CSIDI (A, LDA, N, KPVT, DET, WORK, JOB)
      INTEGER LDA,N,JOB
      COMPLEX A(LDA,*),DET(2),WORK(*)
      INTEGER KPVT(*)
C
      COMPLEX AK,AKP1,AKKP1,CDOTU,D,T,TEMP
      REAL TEN
      INTEGER J,JB,K,KM1,KS,KSTEP
      LOGICAL NOINV,NODET
      COMPLEX ZDUM
      REAL CABS1
      CABS1(ZDUM) = ABS(REAL(ZDUM)) + ABS(AIMAG(ZDUM))
C
C***FIRST EXECUTABLE STATEMENT  CSIDI
      NOINV = MOD(JOB,10) .EQ. 0
      NODET = MOD(JOB,100)/10 .EQ. 0
C
      IF (NODET) GO TO 100
         DET(1) = (1.0E0,0.0E0)
         DET(2) = (0.0E0,0.0E0)
         TEN = 10.0E0
         T = (0.0E0,0.0E0)
         DO 90 K = 1, N
            D = A(K,K)
C
C           CHECK IF 1 BY 1
C
            IF (KPVT(K) .GT. 0) GO TO 30
C
C              2 BY 2 BLOCK
C              USE DET (D  T)  =  (D/T * C - T) * T
C                      (T  C)
C              TO AVOID UNDERFLOW/OVERFLOW TROUBLES.
C              TAKE TWO PASSES THROUGH SCALING.  USE  T  FOR FLAG.
C
               IF (CABS1(T) .NE. 0.0E0) GO TO 10
                  T = A(K,K+1)
                  D = (D/T)*A(K+1,K+1) - T
               GO TO 20
   10          CONTINUE
                  D = T
                  T = (0.0E0,0.0E0)
   20          CONTINUE
   30       CONTINUE
C
            DET(1) = D*DET(1)
            IF (CABS1(DET(1)) .EQ. 0.0E0) GO TO 80
   40          IF (CABS1(DET(1)) .GE. 1.0E0) GO TO 50
                  DET(1) = CMPLX(TEN,0.0E0)*DET(1)
                  DET(2) = DET(2) - (1.0E0,0.0E0)
               GO TO 40
   50          CONTINUE
   60          IF (CABS1(DET(1)) .LT. TEN) GO TO 70
                  DET(1) = DET(1)/CMPLX(TEN,0.0E0)
                  DET(2) = DET(2) + (1.0E0,0.0E0)
               GO TO 60
   70          CONTINUE
   80       CONTINUE
   90    CONTINUE
  100 CONTINUE
C
C     COMPUTE INVERSE(A)
C
      IF (NOINV) GO TO 230
         K = 1
  110    IF (K .GT. N) GO TO 220
            KM1 = K - 1
            IF (KPVT(K) .LT. 0) GO TO 140
C
C              1 BY 1
C
               A(K,K) = (1.0E0,0.0E0)/A(K,K)
               IF (KM1 .LT. 1) GO TO 130
                  CALL CCOPY(KM1,A(1,K),1,WORK,1)
                  DO 120 J = 1, KM1
                     A(J,K) = CDOTU(J,A(1,J),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),A(1,J),1,A(1,K),1)
  120             CONTINUE
                  A(K,K) = A(K,K) + CDOTU(KM1,WORK,1,A(1,K),1)
  130          CONTINUE
               KSTEP = 1
            GO TO 180
  140       CONTINUE
C
C              2 BY 2
C
               T = A(K,K+1)
               AK = A(K,K)/T
               AKP1 = A(K+1,K+1)/T
               AKKP1 = A(K,K+1)/T
               D = T*(AK*AKP1 - (1.0E0,0.0E0))
               A(K,K) = AKP1/D
               A(K+1,K+1) = AK/D
               A(K,K+1) = -AKKP1/D
               IF (KM1 .LT. 1) GO TO 170
                  CALL CCOPY(KM1,A(1,K+1),1,WORK,1)
                  DO 150 J = 1, KM1
                     A(J,K+1) = CDOTU(J,A(1,J),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),A(1,J),1,A(1,K+1),1)
  150             CONTINUE
                  A(K+1,K+1) = A(K+1,K+1)
     1                         + CDOTU(KM1,WORK,1,A(1,K+1),1)
                  A(K,K+1) = A(K,K+1) + CDOTU(KM1,A(1,K),1,A(1,K+1),1)
                  CALL CCOPY(KM1,A(1,K),1,WORK,1)
                  DO 160 J = 1, KM1
                     A(J,K) = CDOTU(J,A(1,J),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),A(1,J),1,A(1,K),1)
  160             CONTINUE
                  A(K,K) = A(K,K) + CDOTU(KM1,WORK,1,A(1,K),1)
  170          CONTINUE
               KSTEP = 2
  180       CONTINUE
C
C           SWAP
C
            KS = ABS(KPVT(K))
            IF (KS .EQ. K) GO TO 210
               CALL CSWAP(KS,A(1,KS),1,A(1,K),1)
               DO 190 JB = KS, K
                  J = K + KS - JB
                  TEMP = A(J,K)
                  A(J,K) = A(KS,J)
                  A(KS,J) = TEMP
  190          CONTINUE
               IF (KSTEP .EQ. 1) GO TO 200
                  TEMP = A(KS,K+1)
                  A(KS,K+1) = A(K,K+1)
                  A(K,K+1) = TEMP
  200          CONTINUE
  210       CONTINUE
            K = K + KSTEP
         GO TO 110
  220    CONTINUE
  230 CONTINUE
      RETURN
      END
