      SUBROUTINE COSQF (N, X, WSAVE)
      DIMENSION X(*), WSAVE(*)
C***FIRST EXECUTABLE STATEMENT  COSQF
      SQRT2 = SQRT(2.)
      IF (N-2) 102,101,103
  101 TSQX = SQRT2*X(2)
      X(2) = X(1)-TSQX
      X(1) = X(1)+TSQX
  102 RETURN
  103 CALL COSQF1 (N,X,WSAVE,WSAVE(N+1))
      RETURN
      END
