      SUBROUTINE CSICO (A, LDA, N, KPVT, RCOND, Z)
      INTEGER LDA,N,KPVT(*)
      COMPLEX A(LDA,*),Z(*)
      REAL RCOND
C
      COMPLEX AK,AKM1,BK,BKM1,CDOTU,DENOM,EK,T
      REAL ANORM,S,SCASUM,YNORM
      INTEGER I,INFO,J,JM1,K,KP,KPS,KS
      COMPLEX ZDUM,ZDUM2,CSIGN1
      REAL CABS1
      CABS1(ZDUM) = ABS(REAL(ZDUM)) + ABS(AIMAG(ZDUM))
      CSIGN1(ZDUM,ZDUM2) = CABS1(ZDUM)*(ZDUM2/CABS1(ZDUM2))
C
C     FIND NORM OF A USING ONLY UPPER HALF
C
C***FIRST EXECUTABLE STATEMENT  CSICO
      DO 30 J = 1, N
         Z(J) = CMPLX(SCASUM(J,A(1,J),1),0.0E0)
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 20
         DO 10 I = 1, JM1
            Z(I) = CMPLX(REAL(Z(I))+CABS1(A(I,J)),0.0E0)
   10    CONTINUE
   20    CONTINUE
   30 CONTINUE
      ANORM = 0.0E0
      DO 40 J = 1, N
         ANORM = MAX(ANORM,REAL(Z(J)))
   40 CONTINUE
C
C     FACTOR
C
      CALL CSIFA(A,LDA,N,KPVT,INFO)
C
C     RCOND = 1/(NORM(A)*(ESTIMATE OF NORM(INVERSE(A)))) .
C     ESTIMATE = NORM(Z)/NORM(Y) WHERE  A*Z = Y  AND  A*Y = E .
C     THE COMPONENTS OF  E  ARE CHOSEN TO CAUSE MAXIMUM LOCAL
C     GROWTH IN THE ELEMENTS OF W  WHERE  U*D*W = E .
C     THE VECTORS ARE FREQUENTLY RESCALED TO AVOID OVERFLOW.
C
C     SOLVE U*D*W = E
C
      EK = (1.0E0,0.0E0)
      DO 50 J = 1, N
         Z(J) = (0.0E0,0.0E0)
   50 CONTINUE
      K = N
   60 IF (K .EQ. 0) GO TO 120
         KS = 1
         IF (KPVT(K) .LT. 0) KS = 2
         KP = ABS(KPVT(K))
         KPS = K + 1 - KS
         IF (KP .EQ. KPS) GO TO 70
            T = Z(KPS)
            Z(KPS) = Z(KP)
            Z(KP) = T
   70    CONTINUE
         IF (CABS1(Z(K)) .NE. 0.0E0) EK = CSIGN1(EK,Z(K))
         Z(K) = Z(K) + EK
         CALL CAXPY(K-KS,Z(K),A(1,K),1,Z(1),1)
         IF (KS .EQ. 1) GO TO 80
            IF (CABS1(Z(K-1)) .NE. 0.0E0) EK = CSIGN1(EK,Z(K-1))
            Z(K-1) = Z(K-1) + EK
            CALL CAXPY(K-KS,Z(K-1),A(1,K-1),1,Z(1),1)
   80    CONTINUE
         IF (KS .EQ. 2) GO TO 100
            IF (CABS1(Z(K)) .LE. CABS1(A(K,K))) GO TO 90
               S = CABS1(A(K,K))/CABS1(Z(K))
               CALL CSSCAL(N,S,Z,1)
               EK = CMPLX(S,0.0E0)*EK
   90       CONTINUE
            IF (CABS1(A(K,K)) .NE. 0.0E0) Z(K) = Z(K)/A(K,K)
            IF (CABS1(A(K,K)) .EQ. 0.0E0) Z(K) = (1.0E0,0.0E0)
         GO TO 110
  100    CONTINUE
            AK = A(K,K)/A(K-1,K)
            AKM1 = A(K-1,K-1)/A(K-1,K)
            BK = Z(K)/A(K-1,K)
            BKM1 = Z(K-1)/A(K-1,K)
            DENOM = AK*AKM1 - 1.0E0
            Z(K) = (AKM1*BK - BKM1)/DENOM
            Z(K-1) = (AK*BKM1 - BK)/DENOM
  110    CONTINUE
         K = K - KS
      GO TO 60
  120 CONTINUE
      S = 1.0E0/SCASUM(N,Z,1)
      CALL CSSCAL(N,S,Z,1)
C
C     SOLVE TRANS(U)*Y = W
C
      K = 1
  130 IF (K .GT. N) GO TO 160
         KS = 1
         IF (KPVT(K) .LT. 0) KS = 2
         IF (K .EQ. 1) GO TO 150
            Z(K) = Z(K) + CDOTU(K-1,A(1,K),1,Z(1),1)
            IF (KS .EQ. 2)
     1         Z(K+1) = Z(K+1) + CDOTU(K-1,A(1,K+1),1,Z(1),1)
            KP = ABS(KPVT(K))
            IF (KP .EQ. K) GO TO 140
               T = Z(K)
               Z(K) = Z(KP)
               Z(KP) = T
  140       CONTINUE
  150    CONTINUE
         K = K + KS
      GO TO 130
  160 CONTINUE
      S = 1.0E0/SCASUM(N,Z,1)
      CALL CSSCAL(N,S,Z,1)
C
      YNORM = 1.0E0
C
C     SOLVE U*D*V = Y
C
      K = N
  170 IF (K .EQ. 0) GO TO 230
         KS = 1
         IF (KPVT(K) .LT. 0) KS = 2
         IF (K .EQ. KS) GO TO 190
            KP = ABS(KPVT(K))
            KPS = K + 1 - KS
            IF (KP .EQ. KPS) GO TO 180
               T = Z(KPS)
               Z(KPS) = Z(KP)
               Z(KP) = T
  180       CONTINUE
            CALL CAXPY(K-KS,Z(K),A(1,K),1,Z(1),1)
            IF (KS .EQ. 2) CALL CAXPY(K-KS,Z(K-1),A(1,K-1),1,Z(1),1)
  190    CONTINUE
         IF (KS .EQ. 2) GO TO 210
            IF (CABS1(Z(K)) .LE. CABS1(A(K,K))) GO TO 200
               S = CABS1(A(K,K))/CABS1(Z(K))
               CALL CSSCAL(N,S,Z,1)
               YNORM = S*YNORM
  200       CONTINUE
            IF (CABS1(A(K,K)) .NE. 0.0E0) Z(K) = Z(K)/A(K,K)
            IF (CABS1(A(K,K)) .EQ. 0.0E0) Z(K) = (1.0E0,0.0E0)
         GO TO 220
  210    CONTINUE
            AK = A(K,K)/A(K-1,K)
            AKM1 = A(K-1,K-1)/A(K-1,K)
            BK = Z(K)/A(K-1,K)
            BKM1 = Z(K-1)/A(K-1,K)
            DENOM = AK*AKM1 - 1.0E0
            Z(K) = (AKM1*BK - BKM1)/DENOM
            Z(K-1) = (AK*BKM1 - BK)/DENOM
  220    CONTINUE
         K = K - KS
      GO TO 170
  230 CONTINUE
      S = 1.0E0/SCASUM(N,Z,1)
      CALL CSSCAL(N,S,Z,1)
      YNORM = S*YNORM
C
C     SOLVE TRANS(U)*Z = V
C
      K = 1
  240 IF (K .GT. N) GO TO 270
         KS = 1
         IF (KPVT(K) .LT. 0) KS = 2
         IF (K .EQ. 1) GO TO 260
            Z(K) = Z(K) + CDOTU(K-1,A(1,K),1,Z(1),1)
            IF (KS .EQ. 2)
     1         Z(K+1) = Z(K+1) + CDOTU(K-1,A(1,K+1),1,Z(1),1)
            KP = ABS(KPVT(K))
            IF (KP .EQ. K) GO TO 250
               T = Z(K)
               Z(K) = Z(KP)
               Z(KP) = T
  250       CONTINUE
  260    CONTINUE
         K = K + KS
      GO TO 240
  270 CONTINUE
C     MAKE ZNORM = 1.0
      S = 1.0E0/SCASUM(N,Z,1)
      CALL CSSCAL(N,S,Z,1)
      YNORM = S*YNORM
C
      IF (ANORM .NE. 0.0E0) RCOND = YNORM/ANORM
      IF (ANORM .EQ. 0.0E0) RCOND = 0.0E0
      RETURN
      END
