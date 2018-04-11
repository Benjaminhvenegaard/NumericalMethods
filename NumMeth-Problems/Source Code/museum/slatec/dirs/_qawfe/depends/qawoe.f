      SUBROUTINE QAWOE (F, A, B, OMEGA, INTEGR, EPSABS, EPSREL, LIMIT,
     +   ICALL, MAXP1, RESULT, ABSERR, NEVAL, IER, LAST, ALIST, BLIST,
     +   RLIST, ELIST, IORD, NNLOG, MOMCOM, CHEBMO)
C
      REAL A,ABSEPS,ABSERR,ALIST,AREA,AREA1,AREA12,AREA2,A1,
     1  A2,B,BLIST,B1,B2,CHEBMO,CORREC,DEFAB1,DEFAB2,DEFABS,
     2  DOMEGA,R1MACH,DRES,ELIST,EPMACH,EPSABS,EPSREL,ERLARG,
     3  ERLAST,ERRBND,ERRMAX,ERROR1,ERRO12,ERROR2,ERRSUM,ERTEST,F,OFLOW,
     4  OMEGA,RESABS,RESEPS,RESULT,RES3LA,RLIST,RLIST2,SMALL,UFLOW,WIDTH
      INTEGER ICALL,ID,IER,IERRO,INTEGR,IORD,IROFF1,IROFF2,IROFF3,
     1  JUPBND,K,KSGN,KTMIN,LAST,LIMIT,MAXERR,MAXP1,MOMCOM,NEV,
     2  NEVAL,NNLOG,NRES,NRMAX,NRMOM,NUMRL2
      LOGICAL EXTRAP,NOEXT,EXTALL
C
      DIMENSION ALIST(*),BLIST(*),RLIST(*),ELIST(*),
     1  IORD(*),RLIST2(52),RES3LA(3),CHEBMO(MAXP1,25),NNLOG(*)
C
      EXTERNAL F
C
C            THE DIMENSION OF RLIST2 IS DETERMINED BY  THE VALUE OF
C            LIMEXP IN SUBROUTINE QELG (RLIST2 SHOULD BE OF
C            DIMENSION (LIMEXP+2) AT LEAST).
C
C            LIST OF MAJOR VARIABLES
C            -----------------------
C
C           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
C                       CONSIDERED UP TO NOW
C           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
C                       CONSIDERED UP TO NOW
C           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
C                       (ALIST(I),BLIST(I))
C           RLIST2    - ARRAY OF DIMENSION AT LEAST LIMEXP+2
C                       CONTAINING THE PART OF THE EPSILON TABLE
C                       WHICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
C           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
C           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST
C                       ERROR ESTIMATE
C           ERRMAX    - ELIST(MAXERR)
C           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
C           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
C           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
C           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
C                       ABS(RESULT))
C           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
C           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
C           LAST      - INDEX FOR SUBDIVISION
C           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
C           NUMRL2    - NUMBER OF ELEMENTS IN RLIST2. IF AN APPROPRIATE
C                       APPROXIMATION TO THE COMPOUNDED INTEGRAL HAS
C                       BEEN OBTAINED IT IS PUT IN RLIST2(NUMRL2) AFTER
C                       NUMRL2 HAS BEEN INCREASED BY ONE
C           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED
C                       UP TO NOW, MULTIPLIED BY 1.5
C           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
C                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
C           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE IS
C                       ATTEMPTING TO PERFORM EXTRAPOLATION, I.E. BEFORE
C                       SUBDIVIDING THE SMALLEST INTERVAL WE TRY TO
C                       DECREASE THE VALUE OF ERLARG
C           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
C                       IS NO LONGER ALLOWED (TRUE VALUE)
C
C            MACHINE DEPENDENT CONSTANTS
C            ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
C
C***FIRST EXECUTABLE STATEMENT  QAWOE
      EPMACH = R1MACH(4)
C
C         TEST ON VALIDITY OF PARAMETERS
C         ------------------------------
C
      IER = 0
      NEVAL = 0
      LAST = 0
      RESULT = 0.0E+00
      ABSERR = 0.0E+00
      ALIST(1) = A
      BLIST(1) = B
      RLIST(1) = 0.0E+00
      ELIST(1) = 0.0E+00
      IORD(1) = 0
      NNLOG(1) = 0
      IF((INTEGR.NE.1.AND.INTEGR.NE.2).OR.(EPSABS.LE.0.0E+00.AND.
     1  EPSREL.LT.MAX(0.5E+02*EPMACH,0.5E-14)).OR.ICALL.LT.1.OR.
     2  MAXP1.LT.1) IER = 6
      IF(IER.EQ.6) GO TO 999
C
C           FIRST APPROXIMATION TO THE INTEGRAL
C           -----------------------------------
C
      DOMEGA = ABS(OMEGA)
      NRMOM = 0
      IF (ICALL.GT.1) GO TO 5
      MOMCOM = 0
    5 CALL QC25F(F,A,B,DOMEGA,INTEGR,NRMOM,MAXP1,0,RESULT,ABSERR,
     1  NEVAL,DEFABS,RESABS,MOMCOM,CHEBMO)
C
C           TEST ON ACCURACY.
C
      DRES = ABS(RESULT)
      ERRBND = MAX(EPSABS,EPSREL*DRES)
      RLIST(1) = RESULT
      ELIST(1) = ABSERR
      IORD(1) = 1
      IF(ABSERR.LE.0.1E+03*EPMACH*DEFABS.AND.ABSERR.GT.
     1  ERRBND) IER = 2
      IF(LIMIT.EQ.1) IER = 1
      IF(IER.NE.0.OR.ABSERR.LE.ERRBND) GO TO 200
C
C           INITIALIZATIONS
C           ---------------
C
      UFLOW = R1MACH(1)
      OFLOW = R1MACH(2)
      ERRMAX = ABSERR
      MAXERR = 1
      AREA = RESULT
      ERRSUM = ABSERR
      ABSERR = OFLOW
      NRMAX = 1
      EXTRAP = .FALSE.
      NOEXT = .FALSE.
      IERRO = 0
      IROFF1 = 0
      IROFF2 = 0
      IROFF3 = 0
      KTMIN = 0
      SMALL = ABS(B-A)*0.75E+00
      NRES = 0
      NUMRL2 = 0
      EXTALL = .FALSE.
      IF(0.5E+00*ABS(B-A)*DOMEGA.GT.0.2E+01) GO TO 10
      NUMRL2 = 1
      EXTALL = .TRUE.
      RLIST2(1) = RESULT
   10 IF(0.25E+00*ABS(B-A)*DOMEGA.LE.0.2E+01) EXTALL = .TRUE.
      KSGN = -1
      IF(DRES.GE.(0.1E+01-0.5E+02*EPMACH)*DEFABS) KSGN = 1
C
C           MAIN DO-LOOP
C           ------------
C
      DO 140 LAST = 2,LIMIT
C
C           BISECT THE SUBINTERVAL WITH THE NRMAX-TH LARGEST
C           ERROR ESTIMATE.
C
        NRMOM = NNLOG(MAXERR)+1
        A1 = ALIST(MAXERR)
        B1 = 0.5E+00*(ALIST(MAXERR)+BLIST(MAXERR))
        A2 = B1
        B2 = BLIST(MAXERR)
        ERLAST = ERRMAX
        CALL QC25F(F,A1,B1,DOMEGA,INTEGR,NRMOM,MAXP1,0,
     1  AREA1,ERROR1,NEV,RESABS,DEFAB1,MOMCOM,CHEBMO)
        NEVAL = NEVAL+NEV
        CALL QC25F(F,A2,B2,DOMEGA,INTEGR,NRMOM,MAXP1,1,
     1  AREA2,ERROR2,NEV,RESABS,DEFAB2,MOMCOM,CHEBMO)
        NEVAL = NEVAL+NEV
C
C           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
C           AND ERROR AND TEST FOR ACCURACY.
C
        AREA12 = AREA1+AREA2
        ERRO12 = ERROR1+ERROR2
        ERRSUM = ERRSUM+ERRO12-ERRMAX
        AREA = AREA+AREA12-RLIST(MAXERR)
        IF(DEFAB1.EQ.ERROR1.OR.DEFAB2.EQ.ERROR2) GO TO 25
        IF(ABS(RLIST(MAXERR)-AREA12).GT.0.1E-04*ABS(AREA12)
     1  .OR.ERRO12.LT.0.99E+00*ERRMAX) GO TO 20
        IF(EXTRAP) IROFF2 = IROFF2+1
        IF(.NOT.EXTRAP) IROFF1 = IROFF1+1
   20   IF(LAST.GT.10.AND.ERRO12.GT.ERRMAX) IROFF3 = IROFF3+1
   25   RLIST(MAXERR) = AREA1
        RLIST(LAST) = AREA2
        NNLOG(MAXERR) = NRMOM
        NNLOG(LAST) = NRMOM
        ERRBND = MAX(EPSABS,EPSREL*ABS(AREA))
C
C           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
C           SET ERROR FLAG
C
        IF(IROFF1+IROFF2.GE.10.OR.IROFF3.GE.20) IER = 2
        IF(IROFF2.GE.5) IERRO = 3
C
C           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
C           SUBINTERVALS EQUALS LIMIT.
C
        IF(LAST.EQ.LIMIT) IER = 1
C
C           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
C           AT A POINT OF THE INTEGRATION RANGE.
C
        IF(MAX(ABS(A1),ABS(B2)).LE.(0.1E+01+0.1E+03*EPMACH)
     1  *(ABS(A2)+0.1E+04*UFLOW)) IER = 4
C
C           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
C
        IF(ERROR2.GT.ERROR1) GO TO 30
        ALIST(LAST) = A2
        BLIST(MAXERR) = B1
        BLIST(LAST) = B2
        ELIST(MAXERR) = ERROR1
        ELIST(LAST) = ERROR2
        GO TO 40
   30   ALIST(MAXERR) = A2
        ALIST(LAST) = A1
        BLIST(LAST) = B1
        RLIST(MAXERR) = AREA2
        RLIST(LAST) = AREA1
        ELIST(MAXERR) = ERROR2
        ELIST(LAST) = ERROR1
C
C           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
C           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
C           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
C           BISECTED NEXT).
C
   40   CALL QPSRT(LIMIT,LAST,MAXERR,ERRMAX,ELIST,IORD,NRMAX)
C ***JUMP OUT OF DO-LOOP
      IF(ERRSUM.LE.ERRBND) GO TO 170
      IF(IER.NE.0) GO TO 150
        IF(LAST.EQ.2.AND.EXTALL) GO TO 120
        IF(NOEXT) GO TO 140
        IF(.NOT.EXTALL) GO TO 50
        ERLARG = ERLARG-ERLAST
        IF(ABS(B1-A1).GT.SMALL) ERLARG = ERLARG+ERRO12
        IF(EXTRAP) GO TO 70
C
C           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
C           SMALLEST INTERVAL.
C
   50   WIDTH = ABS(BLIST(MAXERR)-ALIST(MAXERR))
        IF(WIDTH.GT.SMALL) GO TO 140
        IF(EXTALL) GO TO 60
C
C           TEST WHETHER WE CAN START WITH THE EXTRAPOLATION
C           PROCEDURE (WE DO THIS IF WE INTEGRATE OVER THE
C           NEXT INTERVAL WITH USE OF A GAUSS-KRONROD RULE - SEE
C           SUBROUTINE QC25F).
C
        SMALL = SMALL*0.5E+00
        IF(0.25E+00*WIDTH*DOMEGA.GT.0.2E+01) GO TO 140
        EXTALL = .TRUE.
        GO TO 130
   60   EXTRAP = .TRUE.
        NRMAX = 2
   70   IF(IERRO.EQ.3.OR.ERLARG.LE.ERTEST) GO TO 90
C
C           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
C           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
C           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
C           EXTRAPOLATION.
C
        JUPBND = LAST
        IF (LAST.GT.(LIMIT/2+2)) JUPBND = LIMIT+3-LAST
        ID = NRMAX
        DO 80 K = ID,JUPBND
          MAXERR = IORD(NRMAX)
          ERRMAX = ELIST(MAXERR)
          IF(ABS(BLIST(MAXERR)-ALIST(MAXERR)).GT.SMALL) GO TO 140
          NRMAX = NRMAX+1
   80   CONTINUE
C
C           PERFORM EXTRAPOLATION.
C
   90   NUMRL2 = NUMRL2+1
        RLIST2(NUMRL2) = AREA
        IF(NUMRL2.LT.3) GO TO 110
        CALL QELG(NUMRL2,RLIST2,RESEPS,ABSEPS,RES3LA,NRES)
        KTMIN = KTMIN+1
        IF(KTMIN.GT.5.AND.ABSERR.LT.0.1E-02*ERRSUM) IER = 5
        IF(ABSEPS.GE.ABSERR) GO TO 100
        KTMIN = 0
        ABSERR = ABSEPS
        RESULT = RESEPS
        CORREC = ERLARG
        ERTEST = MAX(EPSABS,EPSREL*ABS(RESEPS))
C ***JUMP OUT OF DO-LOOP
        IF(ABSERR.LE.ERTEST) GO TO 150
C
C           PREPARE BISECTION OF THE SMALLEST INTERVAL.
C
  100   IF(NUMRL2.EQ.1) NOEXT = .TRUE.
        IF(IER.EQ.5) GO TO 150
  110   MAXERR = IORD(1)
        ERRMAX = ELIST(MAXERR)
        NRMAX = 1
        EXTRAP = .FALSE.
        SMALL = SMALL*0.5E+00
        ERLARG = ERRSUM
        GO TO 140
  120   SMALL = SMALL*0.5E+00
        NUMRL2 = NUMRL2+1
        RLIST2(NUMRL2) = AREA
  130   ERTEST = ERRBND
        ERLARG = ERRSUM
  140 CONTINUE
C
C           SET THE FINAL RESULT.
C           ---------------------
C
  150 IF(ABSERR.EQ.OFLOW.OR.NRES.EQ.0) GO TO 170
      IF(IER+IERRO.EQ.0) GO TO 165
      IF(IERRO.EQ.3) ABSERR = ABSERR+CORREC
      IF(IER.EQ.0) IER = 3
      IF(RESULT.NE.0.0E+00.AND.AREA.NE.0.0E+00) GO TO 160
      IF(ABSERR.GT.ERRSUM) GO TO 170
      IF(AREA.EQ.0.0E+00) GO TO 190
      GO TO 165
  160 IF(ABSERR/ABS(RESULT).GT.ERRSUM/ABS(AREA)) GO TO 170
C
C           TEST ON DIVERGENCE.
C
  165 IF(KSGN.EQ.(-1).AND.MAX(ABS(RESULT),ABS(AREA)).LE.
     1 DEFABS*0.1E-01) GO TO 190
      IF(0.1E-01.GT.(RESULT/AREA).OR.(RESULT/AREA).GT.0.1E+03
     1 .OR.ERRSUM.GE.ABS(AREA)) IER = 6
      GO TO 190
C
C           COMPUTE GLOBAL INTEGRAL SUM.
C
  170 RESULT = 0.0E+00
      DO 180 K=1,LAST
        RESULT = RESULT+RLIST(K)
  180 CONTINUE
      ABSERR = ERRSUM
  190 IF (IER.GT.2) IER=IER-1
  200 IF (INTEGR.EQ.2.AND.OMEGA.LT.0.0E+00) RESULT=-RESULT
  999 RETURN
      END
