      SUBROUTINE HWSSSP (TS, TF, M, MBDCND, BDTS, BDTF, PS, PF, N,
     +   NBDCND, BDPS, BDPF, ELMBDA, F, IDIMF, PERTRB, IERROR, W)
C
      DIMENSION       F(IDIMF,*) ,BDTS(*)    ,BDTF(*)    ,BDPS(*)    ,
     1                BDPF(*)    ,W(*)
C***FIRST EXECUTABLE STATEMENT  HWSSSP
      PI = PIMACH(DUM)
      TPI = 2.*PI
      IERROR = 0
      IF (TS.LT.0. .OR. TF.GT.PI) IERROR = 1
      IF (TS .GE. TF) IERROR = 2
      IF (MBDCND.LT.1 .OR. MBDCND.GT.9) IERROR = 3
      IF (PS.LT.0. .OR. PF.GT.TPI) IERROR = 4
      IF (PS .GE. PF) IERROR = 5
      IF (N .LT. 5) IERROR = 6
      IF (M .LT. 5) IERROR = 7
      IF (NBDCND.LT.0 .OR. NBDCND.GT.4) IERROR = 8
      IF (ELMBDA .GT. 0.) IERROR = 9
      IF (IDIMF .LT. M+1) IERROR = 10
      IF ((NBDCND.EQ.1 .OR. NBDCND.EQ.2 .OR. NBDCND.EQ.4) .AND.
     1    MBDCND.GE.5) IERROR = 11
      IF (TS.EQ.0. .AND.
     1    (MBDCND.EQ.3 .OR. MBDCND.EQ.4 .OR. MBDCND.EQ.8)) IERROR = 12
      IF (TF.EQ.PI .AND.
     1    (MBDCND.EQ.2 .OR. MBDCND.EQ.3 .OR. MBDCND.EQ.6)) IERROR = 13
      IF ((MBDCND.EQ.5 .OR. MBDCND.EQ.6 .OR. MBDCND.EQ.9) .AND.
     1    TS.NE.0.) IERROR = 14
      IF (MBDCND.GE.7 .AND. TF.NE.PI) IERROR = 15
      IF (IERROR.NE.0 .AND. IERROR.NE.9) RETURN
      CALL HWSSS1 (TS,TF,M,MBDCND,BDTS,BDTF,PS,PF,N,NBDCND,BDPS,BDPF,
     1             ELMBDA,F,IDIMF,PERTRB,W,W(M+2),W(2*M+3),W(3*M+4),
     2             W(4*M+5),W(5*M+6),W(6*M+7))
      W(1) = W(6*M+7)+6*(M+1)
      RETURN
      END
