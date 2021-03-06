      SUBROUTINE DQAWFE (F, A, OMEGA, INTEGR, EPSABS, LIMLST, LIMIT,
     +   MAXP1, RESULT, ABSERR, NEVAL, IER, RSLST, ERLST, IERLST, LST,
     +   ALIST, BLIST, RLIST, ELIST, IORD, NNLOG, CHEBMO)
C
      DOUBLE PRECISION A,ABSEPS,ABSERR,ALIST,BLIST,CHEBMO,CORREC,CYCLE,
     1  C1,C2,DL,DRL,D1MACH,ELIST,ERLST,EP,EPS,EPSA,
     2  EPSABS,ERRSUM,F,FACT,OMEGA,P,PI,P1,PSUM,RESEPS,RESULT,RES3LA,
     3  RLIST,RSLST,UFLOW
      INTEGER IER,IERLST,INTEGR,IORD,KTMIN,L,LAST,LST,LIMIT,LIMLST,LL,
     1    MAXP1,MOMCOM,NEV,NEVAL,NNLOG,NRES,NUMRL2
C
      DIMENSION ALIST(*),BLIST(*),CHEBMO(MAXP1,25),ELIST(*),
     1  ERLST(*),IERLST(*),IORD(*),NNLOG(*),PSUM(52),
     2  RES3LA(3),RLIST(*),RSLST(*)
C
      EXTERNAL F
C
C
C            THE DIMENSION OF  PSUM  IS DETERMINED BY THE VALUE OF
C            LIMEXP IN SUBROUTINE DQELG (PSUM MUST BE OF DIMENSION
C            (LIMEXP+2) AT LEAST).
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           C1, C2    - END POINTS OF SUBINTERVAL (OF LENGTH CYCLE)
C           CYCLE     - (2*INT(ABS(OMEGA))+1)*PI/ABS(OMEGA)
C           PSUM      - VECTOR OF DIMENSION AT LEAST (LIMEXP+2)
C                       (SEE ROUTINE DQELG)
C                       PSUM CONTAINS THE PART OF THE EPSILON TABLE
C                       WHICH IS STILL NEEDED FOR FURTHER COMPUTATIONS.
C                       EACH ELEMENT OF PSUM IS A PARTIAL SUM OF THE
C                       SERIES WHICH SHOULD SUM TO THE VALUE OF THE
C                       INTEGRAL.
C           ERRSUM    - SUM OF ERROR ESTIMATES OVER THE SUBINTERVALS,
C                       CALCULATED CUMULATIVELY
C           EPSA      - ABSOLUTE TOLERANCE REQUESTED OVER CURRENT
C                       SUBINTERVAL
C           CHEBMO    - ARRAY CONTAINING THE MODIFIED CHEBYSHEV
C                       MOMENTS (SEE ALSO ROUTINE DQC25F)
C
      SAVE P, PI
      DATA P/0.9D+00/
      DATA PI / 3.1415926535 8979323846 2643383279 50 D0 /
C
C           TEST ON VALIDITY OF PARAMETERS
C           ------------------------------
C
C***FIRST EXECUTABLE STATEMENT  DQAWFE
      RESULT = 0.0D+00
      ABSERR = 0.0D+00
      NEVAL = 0
      LST = 0
      IER = 0
      IF((INTEGR.NE.1.AND.INTEGR.NE.2).OR.EPSABS.LE.0.0D+00.OR.
     1  LIMLST.LT.3) IER = 6
      IF(IER.EQ.6) GO TO 999
      IF(OMEGA.NE.0.0D+00) GO TO 10
C
C           INTEGRATION BY DQAGIE IF OMEGA IS ZERO
C           --------------------------------------
C
      IF(INTEGR.EQ.1) CALL DQAGIE(F,A,1,EPSABS,0.0D+00,LIMIT,
     1  RESULT,ABSERR,NEVAL,IER,ALIST,BLIST,RLIST,ELIST,IORD,LAST)
      RSLST(1) = RESULT
      ERLST(1) = ABSERR
      IERLST(1) = IER
      LST = 1
      GO TO 999
C
C           INITIALIZATIONS
C           ---------------
C
   10 L = ABS(OMEGA)
      DL = 2*L+1
      CYCLE = DL*PI/ABS(OMEGA)
      IER = 0
      KTMIN = 0
      NEVAL = 0
      NUMRL2 = 0
      NRES = 0
      C1 = A
      C2 = CYCLE+A
      P1 = 0.1D+01-P
      UFLOW = D1MACH(1)
      EPS = EPSABS
      IF(EPSABS.GT.UFLOW/P1) EPS = EPSABS*P1
      EP = EPS
      FACT = 0.1D+01
      CORREC = 0.0D+00
      ABSERR = 0.0D+00
      ERRSUM = 0.0D+00
C
C           MAIN DO-LOOP
C           ------------
C
      DO 50 LST = 1,LIMLST
C
C           INTEGRATE OVER CURRENT SUBINTERVAL.
C
        EPSA = EPS*FACT
        CALL DQAWOE(F,C1,C2,OMEGA,INTEGR,EPSA,0.0D+00,LIMIT,LST,MAXP1,
     1  RSLST(LST),ERLST(LST),NEV,IERLST(LST),LAST,ALIST,BLIST,RLIST,
     2  ELIST,IORD,NNLOG,MOMCOM,CHEBMO)
        NEVAL = NEVAL+NEV
        FACT = FACT*P
        ERRSUM = ERRSUM+ERLST(LST)
        DRL = 0.5D+02*ABS(RSLST(LST))
C
C           TEST ON ACCURACY WITH PARTIAL SUM
C
        IF((ERRSUM+DRL).LE.EPSABS.AND.LST.GE.6) GO TO 80
        CORREC = MAX(CORREC,ERLST(LST))
        IF(IERLST(LST).NE.0) EPS = MAX(EP,CORREC*P1)
        IF(IERLST(LST).NE.0) IER = 7
        IF(IER.EQ.7.AND.(ERRSUM+DRL).LE.CORREC*0.1D+02.AND.
     1  LST.GT.5) GO TO 80
        NUMRL2 = NUMRL2+1
        IF(LST.GT.1) GO TO 20
        PSUM(1) = RSLST(1)
        GO TO 40
   20   PSUM(NUMRL2) = PSUM(LL)+RSLST(LST)
        IF(LST.EQ.2) GO TO 40
C
C           TEST ON MAXIMUM NUMBER OF SUBINTERVALS
C
        IF(LST.EQ.LIMLST) IER = 1
C
C           PERFORM NEW EXTRAPOLATION
C
        CALL DQELG(NUMRL2,PSUM,RESEPS,ABSEPS,RES3LA,NRES)
C
C           TEST WHETHER EXTRAPOLATED RESULT IS INFLUENCED BY ROUNDOFF
C
        KTMIN = KTMIN+1
        IF(KTMIN.GE.15.AND.ABSERR.LE.0.1D-02*(ERRSUM+DRL)) IER = 4
        IF(ABSEPS.GT.ABSERR.AND.LST.NE.3) GO TO 30
        ABSERR = ABSEPS
        RESULT = RESEPS
        KTMIN = 0
C
C           IF IER IS NOT 0, CHECK WHETHER DIRECT RESULT (PARTIAL SUM)
C           OR EXTRAPOLATED RESULT YIELDS THE BEST INTEGRAL
C           APPROXIMATION
C
        IF((ABSERR+0.1D+02*CORREC).LE.EPSABS.OR.
     1  (ABSERR.LE.EPSABS.AND.0.1D+02*CORREC.GE.EPSABS)) GO TO 60
   30   IF(IER.NE.0.AND.IER.NE.7) GO TO 60
   40   LL = NUMRL2
        C1 = C2
        C2 = C2+CYCLE
   50 CONTINUE
C
C         SET FINAL RESULT AND ERROR ESTIMATE
C         -----------------------------------
C
   60 ABSERR = ABSERR+0.1D+02*CORREC
      IF(IER.EQ.0) GO TO 999
      IF(RESULT.NE.0.0D+00.AND.PSUM(NUMRL2).NE.0.0D+00) GO TO 70
      IF(ABSERR.GT.ERRSUM) GO TO 80
      IF(PSUM(NUMRL2).EQ.0.0D+00) GO TO 999
   70 IF(ABSERR/ABS(RESULT).GT.(ERRSUM+DRL)/ABS(PSUM(NUMRL2)))
     1  GO TO 80
      IF(IER.GE.1.AND.IER.NE.7) ABSERR = ABSERR+DRL
      GO TO 999
   80 RESULT = PSUM(NUMRL2)
      ABSERR = ERRSUM+DRL
  999 RETURN
      END
