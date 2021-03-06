      SUBROUTINE CSPDI (AP, N, KPVT, DET, WORK, JOB)
      INTEGER N,JOB
      COMPLEX AP(*),WORK(*),DET(2)
      INTEGER KPVT(*)
C
      COMPLEX AK,AKKP1,AKP1,CDOTU,D,T,TEMP
      REAL TEN
      INTEGER IJ,IK,IKP1,IKS,J,JB,JK,JKP1
      INTEGER K,KK,KKP1,KM1,KS,KSJ,KSKP1,KSTEP
      LOGICAL NOINV,NODET
      COMPLEX ZDUM
      REAL CABS1
      CABS1(ZDUM) = ABS(REAL(ZDUM)) + ABS(AIMAG(ZDUM))
C
C***FIRST EXECUTABLE STATEMENT  CSPDI
      NOINV = MOD(JOB,10) .EQ. 0
      NODET = MOD(JOB,100)/10 .EQ. 0
C
      IF (NODET) GO TO 110
         DET(1) = (1.0E0,0.0E0)
         DET(2) = (0.0E0,0.0E0)
         TEN = 10.0E0
         T = (0.0E0,0.0E0)
         IK = 0
         DO 100 K = 1, N
            KK = IK + K
            D = AP(KK)
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
                  IKP1 = IK + K
                  KKP1 = IKP1 + K
                  T = AP(KKP1)
                  D = (D/T)*AP(KKP1+1) - T
               GO TO 20
   10          CONTINUE
                  D = T
                  T = (0.0E0,0.0E0)
   20          CONTINUE
   30       CONTINUE
C
            IF (NODET) GO TO 90
               DET(1) = D*DET(1)
               IF (CABS1(DET(1)) .EQ. 0.0E0) GO TO 80
   40             IF (CABS1(DET(1)) .GE. 1.0E0) GO TO 50
                     DET(1) = CMPLX(TEN,0.0E0)*DET(1)
                     DET(2) = DET(2) - (1.0E0,0.0E0)
                  GO TO 40
   50             CONTINUE
   60             IF (CABS1(DET(1)) .LT. TEN) GO TO 70
                     DET(1) = DET(1)/CMPLX(TEN,0.0E0)
                     DET(2) = DET(2) + (1.0E0,0.0E0)
                  GO TO 60
   70             CONTINUE
   80          CONTINUE
   90       CONTINUE
            IK = IK + K
  100    CONTINUE
  110 CONTINUE
C
C     COMPUTE INVERSE(A)
C
      IF (NOINV) GO TO 240
         K = 1
         IK = 0
  120    IF (K .GT. N) GO TO 230
            KM1 = K - 1
            KK = IK + K
            IKP1 = IK + K
            IF (KPVT(K) .LT. 0) GO TO 150
C
C              1 BY 1
C
               AP(KK) = (1.0E0,0.0E0)/AP(KK)
               IF (KM1 .LT. 1) GO TO 140
                  CALL CCOPY(KM1,AP(IK+1),1,WORK,1)
                  IJ = 0
                  DO 130 J = 1, KM1
                     JK = IK + J
                     AP(JK) = CDOTU(J,AP(IJ+1),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),AP(IJ+1),1,AP(IK+1),1)
                     IJ = IJ + J
  130             CONTINUE
                  AP(KK) = AP(KK) + CDOTU(KM1,WORK,1,AP(IK+1),1)
  140          CONTINUE
               KSTEP = 1
            GO TO 190
  150       CONTINUE
C
C              2 BY 2
C
               KKP1 = IKP1 + K
               T = AP(KKP1)
               AK = AP(KK)/T
               AKP1 = AP(KKP1+1)/T
               AKKP1 = AP(KKP1)/T
               D = T*(AK*AKP1 - (1.0E0,0.0E0))
               AP(KK) = AKP1/D
               AP(KKP1+1) = AK/D
               AP(KKP1) = -AKKP1/D
               IF (KM1 .LT. 1) GO TO 180
                  CALL CCOPY(KM1,AP(IKP1+1),1,WORK,1)
                  IJ = 0
                  DO 160 J = 1, KM1
                     JKP1 = IKP1 + J
                     AP(JKP1) = CDOTU(J,AP(IJ+1),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),AP(IJ+1),1,AP(IKP1+1),1)
                     IJ = IJ + J
  160             CONTINUE
                  AP(KKP1+1) = AP(KKP1+1)
     1                         + CDOTU(KM1,WORK,1,AP(IKP1+1),1)
                  AP(KKP1) = AP(KKP1)
     1                       + CDOTU(KM1,AP(IK+1),1,AP(IKP1+1),1)
                  CALL CCOPY(KM1,AP(IK+1),1,WORK,1)
                  IJ = 0
                  DO 170 J = 1, KM1
                     JK = IK + J
                     AP(JK) = CDOTU(J,AP(IJ+1),1,WORK,1)
                     CALL CAXPY(J-1,WORK(J),AP(IJ+1),1,AP(IK+1),1)
                     IJ = IJ + J
  170             CONTINUE
                  AP(KK) = AP(KK) + CDOTU(KM1,WORK,1,AP(IK+1),1)
  180          CONTINUE
               KSTEP = 2
  190       CONTINUE
C
C           SWAP
C
            KS = ABS(KPVT(K))
            IF (KS .EQ. K) GO TO 220
               IKS = (KS*(KS - 1))/2
               CALL CSWAP(KS,AP(IKS+1),1,AP(IK+1),1)
               KSJ = IK + KS
               DO 200 JB = KS, K
                  J = K + KS - JB
                  JK = IK + J
                  TEMP = AP(JK)
                  AP(JK) = AP(KSJ)
                  AP(KSJ) = TEMP
                  KSJ = KSJ - (J - 1)
  200          CONTINUE
               IF (KSTEP .EQ. 1) GO TO 210
                  KSKP1 = IKP1 + KS
                  TEMP = AP(KSKP1)
                  AP(KSKP1) = AP(KKP1)
                  AP(KKP1) = TEMP
  210          CONTINUE
  220       CONTINUE
            IK = IK + K
            IF (KSTEP .EQ. 2) IK = IK + K + 1
            K = K + KSTEP
         GO TO 120
  230    CONTINUE
  240 CONTINUE
      RETURN
      END
