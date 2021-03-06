      SUBROUTINE CPPCO (AP, N, RCOND, Z, INFO)
      INTEGER N,INFO
      COMPLEX AP(*),Z(*)
      REAL RCOND
C
      COMPLEX CDOTC,EK,T,WK,WKM
      REAL ANORM,S,SCASUM,SM,YNORM
      INTEGER I,IJ,J,JM1,J1,K,KB,KJ,KK,KP1
      COMPLEX ZDUM,ZDUM2,CSIGN1
      REAL CABS1
      CABS1(ZDUM) = ABS(REAL(ZDUM)) + ABS(AIMAG(ZDUM))
      CSIGN1(ZDUM,ZDUM2) = CABS1(ZDUM)*(ZDUM2/CABS1(ZDUM2))
C
C     FIND NORM OF A
C
C***FIRST EXECUTABLE STATEMENT  CPPCO
      J1 = 1
      DO 30 J = 1, N
         Z(J) = CMPLX(SCASUM(J,AP(J1),1),0.0E0)
         IJ = J1
         J1 = J1 + J
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 20
         DO 10 I = 1, JM1
            Z(I) = CMPLX(REAL(Z(I))+CABS1(AP(IJ)),0.0E0)
            IJ = IJ + 1
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
      CALL CPPFA(AP,N,INFO)
      IF (INFO .NE. 0) GO TO 180
C
C        RCOND = 1/(NORM(A)*(ESTIMATE OF NORM(INVERSE(A)))) .
C        ESTIMATE = NORM(Z)/NORM(Y) WHERE  A*Z = Y  AND  A*Y = E .
C        THE COMPONENTS OF  E  ARE CHOSEN TO CAUSE MAXIMUM LOCAL
C        GROWTH IN THE ELEMENTS OF W  WHERE  CTRANS(R)*W = E .
C        THE VECTORS ARE FREQUENTLY RESCALED TO AVOID OVERFLOW.
C
C        SOLVE CTRANS(R)*W = E
C
         EK = (1.0E0,0.0E0)
         DO 50 J = 1, N
            Z(J) = (0.0E0,0.0E0)
   50    CONTINUE
         KK = 0
         DO 110 K = 1, N
            KK = KK + K
            IF (CABS1(Z(K)) .NE. 0.0E0) EK = CSIGN1(EK,-Z(K))
            IF (CABS1(EK-Z(K)) .LE. REAL(AP(KK))) GO TO 60
               S = REAL(AP(KK))/CABS1(EK-Z(K))
               CALL CSSCAL(N,S,Z,1)
               EK = CMPLX(S,0.0E0)*EK
   60       CONTINUE
            WK = EK - Z(K)
            WKM = -EK - Z(K)
            S = CABS1(WK)
            SM = CABS1(WKM)
            WK = WK/AP(KK)
            WKM = WKM/AP(KK)
            KP1 = K + 1
            KJ = KK + K
            IF (KP1 .GT. N) GO TO 100
               DO 70 J = KP1, N
                  SM = SM + CABS1(Z(J)+WKM*CONJG(AP(KJ)))
                  Z(J) = Z(J) + WK*CONJG(AP(KJ))
                  S = S + CABS1(Z(J))
                  KJ = KJ + J
   70          CONTINUE
               IF (S .GE. SM) GO TO 90
                  T = WKM - WK
                  WK = WKM
                  KJ = KK + K
                  DO 80 J = KP1, N
                     Z(J) = Z(J) + T*CONJG(AP(KJ))
                     KJ = KJ + J
   80             CONTINUE
   90          CONTINUE
  100       CONTINUE
            Z(K) = WK
  110    CONTINUE
         S = 1.0E0/SCASUM(N,Z,1)
         CALL CSSCAL(N,S,Z,1)
C
C        SOLVE R*Y = W
C
         DO 130 KB = 1, N
            K = N + 1 - KB
            IF (CABS1(Z(K)) .LE. REAL(AP(KK))) GO TO 120
               S = REAL(AP(KK))/CABS1(Z(K))
               CALL CSSCAL(N,S,Z,1)
  120       CONTINUE
            Z(K) = Z(K)/AP(KK)
            KK = KK - K
            T = -Z(K)
            CALL CAXPY(K-1,T,AP(KK+1),1,Z(1),1)
  130    CONTINUE
         S = 1.0E0/SCASUM(N,Z,1)
         CALL CSSCAL(N,S,Z,1)
C
         YNORM = 1.0E0
C
C        SOLVE CTRANS(R)*V = Y
C
         DO 150 K = 1, N
            Z(K) = Z(K) - CDOTC(K-1,AP(KK+1),1,Z(1),1)
            KK = KK + K
            IF (CABS1(Z(K)) .LE. REAL(AP(KK))) GO TO 140
               S = REAL(AP(KK))/CABS1(Z(K))
               CALL CSSCAL(N,S,Z,1)
               YNORM = S*YNORM
  140       CONTINUE
            Z(K) = Z(K)/AP(KK)
  150    CONTINUE
         S = 1.0E0/SCASUM(N,Z,1)
         CALL CSSCAL(N,S,Z,1)
         YNORM = S*YNORM
C
C        SOLVE R*Z = V
C
         DO 170 KB = 1, N
            K = N + 1 - KB
            IF (CABS1(Z(K)) .LE. REAL(AP(KK))) GO TO 160
               S = REAL(AP(KK))/CABS1(Z(K))
               CALL CSSCAL(N,S,Z,1)
               YNORM = S*YNORM
  160       CONTINUE
            Z(K) = Z(K)/AP(KK)
            KK = KK - K
            T = -Z(K)
            CALL CAXPY(K-1,T,AP(KK+1),1,Z(1),1)
  170    CONTINUE
C        MAKE ZNORM = 1.0
         S = 1.0E0/SCASUM(N,Z,1)
         CALL CSSCAL(N,S,Z,1)
         YNORM = S*YNORM
C
         IF (ANORM .NE. 0.0E0) RCOND = YNORM/ANORM
         IF (ANORM .EQ. 0.0E0) RCOND = 0.0E0
  180 CONTINUE
      RETURN
      END
