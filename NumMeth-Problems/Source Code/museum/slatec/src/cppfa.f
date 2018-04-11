      SUBROUTINE CPPFA (AP, N, INFO)
      INTEGER N,INFO
      COMPLEX AP(*)
C
      COMPLEX CDOTC,T
      REAL S
      INTEGER J,JJ,JM1,K,KJ,KK
C***FIRST EXECUTABLE STATEMENT  CPPFA
         JJ = 0
         DO 30 J = 1, N
            INFO = J
            S = 0.0E0
            JM1 = J - 1
            KJ = JJ
            KK = 0
            IF (JM1 .LT. 1) GO TO 20
            DO 10 K = 1, JM1
               KJ = KJ + 1
               T = AP(KJ) - CDOTC(K-1,AP(KK+1),1,AP(JJ+1),1)
               KK = KK + K
               T = T/AP(KK)
               AP(KJ) = T
               S = S + REAL(T*CONJG(T))
   10       CONTINUE
   20       CONTINUE
            JJ = JJ + J
            S = REAL(AP(JJ)) - S
            IF (S .LE. 0.0E0 .OR. AIMAG(AP(JJ)) .NE. 0.0E0) GO TO 40
            AP(JJ) = CMPLX(SQRT(S),0.0E0)
   30    CONTINUE
         INFO = 0
   40 CONTINUE
      RETURN
      END
