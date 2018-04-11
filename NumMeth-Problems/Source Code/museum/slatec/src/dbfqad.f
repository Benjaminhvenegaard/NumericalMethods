      SUBROUTINE DBFQAD (F, T, BCOEF, N, K, ID, X1, X2, TOL, QUAD, IERR,
     +   WORK)
C
C
      INTEGER ID, IERR, IFLG, ILO, IL1, IL2, K, LEFT, MFLAG, N, NPK, NP1
      DOUBLE PRECISION A,AA,ANS,B,BB,BCOEF,Q,QUAD,T,TA,TB,TOL,WORK,WTOL,
     1 X1, X2
      DOUBLE PRECISION D1MACH, F
      DIMENSION T(*), BCOEF(*), WORK(*)
      EXTERNAL F
C***FIRST EXECUTABLE STATEMENT  DBFQAD
      IERR = 1
      QUAD = 0.0D0
      IF(K.LT.1) GO TO 100
      IF(N.LT.K) GO TO 105
      IF(ID.LT.0 .OR. ID.GE.K) GO TO 110
      WTOL = D1MACH(4)
      WTOL = MAX(WTOL,1.D-18)
      IF (TOL.LT.WTOL .OR. TOL.GT.0.1D0) GO TO 30
      AA = MIN(X1,X2)
      BB = MAX(X1,X2)
      IF (AA.LT.T(K)) GO TO 20
      NP1 = N + 1
      IF (BB.GT.T(NP1)) GO TO 20
      IF (AA.EQ.BB) RETURN
      NPK = N + K
C
      ILO = 1
      CALL DINTRV(T, NPK, AA, ILO, IL1, MFLAG)
      CALL DINTRV(T, NPK, BB, ILO, IL2, MFLAG)
      IF (IL2.GE.NP1) IL2 = N
      INBV = 1
      Q = 0.0D0
      DO 10 LEFT=IL1,IL2
        TA = T(LEFT)
        TB = T(LEFT+1)
        IF (TA.EQ.TB) GO TO 10
        A = MAX(AA,TA)
        B = MIN(BB,TB)
        CALL DBSGQ8(F,T,BCOEF,N,K,ID,A,B,INBV,TOL,ANS,IFLG,WORK)
        IF (IFLG.GT.1) IERR = 2
        Q = Q + ANS
   10 CONTINUE
      IF (X1.GT.X2) Q = -Q
      QUAD = Q
      RETURN
C
C
   20 CONTINUE
      CALL XERMSG ('SLATEC', 'DBFQAD',
     +   'X1 OR X2 OR BOTH DO NOT SATISFY T(K).LE.X.LE.T(N+1)', 2, 1)
      RETURN
   30 CONTINUE
      CALL XERMSG ('SLATEC', 'DBFQAD',
     +   'TOL IS LESS DTOL OR GREATER THAN 0.1', 2, 1)
      RETURN
  100 CONTINUE
      CALL XERMSG ('SLATEC', 'DBFQAD', 'K DOES NOT SATISFY K.GE.1', 2,
     +   1)
      RETURN
  105 CONTINUE
      CALL XERMSG ('SLATEC', 'DBFQAD', 'N DOES NOT SATISFY N.GE.K', 2,
     +   1)
      RETURN
  110 CONTINUE
      CALL XERMSG ('SLATEC', 'DBFQAD',
     +   'ID DOES NOT SATISFY 0.LE.ID.LT.K', 2, 1)
      RETURN
      END