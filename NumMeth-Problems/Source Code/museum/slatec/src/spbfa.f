      SUBROUTINE SPBFA (ABD, LDA, N, M, INFO)
      INTEGER LDA,N,M,INFO
      REAL ABD(LDA,*)
C
      REAL SDOT,T
      REAL S
      INTEGER IK,J,JK,K,MU
C***FIRST EXECUTABLE STATEMENT  SPBFA
         DO 30 J = 1, N
            INFO = J
            S = 0.0E0
            IK = M + 1
            JK = MAX(J-M,1)
            MU = MAX(M+2-J,1)
            IF (M .LT. MU) GO TO 20
            DO 10 K = MU, M
               T = ABD(K,J) - SDOT(K-MU,ABD(IK,JK),1,ABD(MU,J),1)
               T = T/ABD(M+1,JK)
               ABD(K,J) = T
               S = S + T*T
               IK = IK - 1
               JK = JK + 1
   10       CONTINUE
   20       CONTINUE
            S = ABD(M+1,J) - S
            IF (S .LE. 0.0E0) GO TO 40
            ABD(M+1,J) = SQRT(S)
   30    CONTINUE
         INFO = 0
   40 CONTINUE
      RETURN
      END
