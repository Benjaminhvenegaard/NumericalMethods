      SUBROUTINE QAWSE (F, A, B, ALFA, BETA, INTEGR, EPSABS, EPSREL,
     +   LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST,
     +   IORD, LAST)
C
      REAL A,ABSERR,ALFA,ALIST,AREA,AREA1,AREA12,
     1  AREA2,A1,A2,B,BETA,BLIST,B1,B2,CENTRE,
     2  R1MACH,ELIST,EPMACH,EPSABS,EPSREL,ERRBND,ERRMAX,
     3  ERROR1,ERRO12,ERROR2,ERRSUM,F,RESAS1,RESAS2,RESULT,RG,RH,RI,RJ,
     4  RLIST,UFLOW
      INTEGER IER,INTEGR,IORD,IROFF1,IROFF2,K,LAST,
     1  LIMIT,MAXERR,NEV,NEVAL,NRMAX
C
      EXTERNAL F
C
      DIMENSION ALIST(*),BLIST(*),RLIST(*),ELIST(*),
     1  IORD(*),RI(25),RJ(25),RH(25),RG(25)
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
C           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
C           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST
C                       ERROR ESTIMATE
C           ERRMAX    - ELIST(MAXERR)
C           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
C           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
C           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
C                       ABS(RESULT))
C           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
C           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
C           LAST      - INDEX FOR SUBDIVISION
C
C
C            MACHINE DEPENDENT CONSTANTS
C            ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C
C***FIRST EXECUTABLE STATEMENT  QAWSE
      EPMACH = R1MACH(4)
      UFLOW = R1MACH(1)
C
C           TEST ON VALIDITY OF PARAMETERS
C           ------------------------------
C
      IER = 6
      NEVAL = 0
      LAST = 0
      RLIST(1) = 0.0E+00
      ELIST(1) = 0.0E+00
      IORD(1) = 0
      RESULT = 0.0E+00
      ABSERR = 0.0E+00
      IF (B.LE.A.OR.(EPSABS.EQ.0.0E+00.AND.
     1    EPSREL.LT.MAX(0.5E+02*EPMACH,0.5E-14)).OR.ALFA.LE.(-0.1E+01)
     2    .OR.BETA.LE.(-0.1E+01).OR.INTEGR.LT.1.OR.INTEGR.GT.4.OR.
     3    LIMIT.LT.2) GO TO 999
      IER = 0
C
C           COMPUTE THE MODIFIED CHEBYSHEV MOMENTS.
C
      CALL QMOMO(ALFA,BETA,RI,RJ,RG,RH,INTEGR)
C
C           INTEGRATE OVER THE INTERVALS (A,(A+B)/2)
C           AND ((A+B)/2,B).
C
      CENTRE = 0.5E+00*(B+A)
      CALL QC25S(F,A,B,A,CENTRE,ALFA,BETA,RI,RJ,RG,RH,AREA1,
     1  ERROR1,RESAS1,INTEGR,NEV)
      NEVAL = NEV
      CALL QC25S(F,A,B,CENTRE,B,ALFA,BETA,RI,RJ,RG,RH,AREA2,
     1  ERROR2,RESAS2,INTEGR,NEV)
      LAST = 2
      NEVAL = NEVAL+NEV
      RESULT = AREA1+AREA2
      ABSERR = ERROR1+ERROR2
C
C           TEST ON ACCURACY.
C
      ERRBND = MAX(EPSABS,EPSREL*ABS(RESULT))
C
C           INITIALIZATION
C           --------------
C
      IF(ERROR2.GT.ERROR1) GO TO 10
      ALIST(1) = A
      ALIST(2) = CENTRE
      BLIST(1) = CENTRE
      BLIST(2) = B
      RLIST(1) = AREA1
      RLIST(2) = AREA2
      ELIST(1) = ERROR1
      ELIST(2) = ERROR2
      GO TO 20
   10 ALIST(1) = CENTRE
      ALIST(2) = A
      BLIST(1) = B
      BLIST(2) = CENTRE
      RLIST(1) = AREA2
      RLIST(2) = AREA1
      ELIST(1) = ERROR2
      ELIST(2) = ERROR1
   20 IORD(1) = 1
      IORD(2) = 2
      IF(LIMIT.EQ.2) IER = 1
      IF(ABSERR.LE.ERRBND.OR.IER.EQ.1) GO TO 999
      ERRMAX = ELIST(1)
      MAXERR = 1
      NRMAX = 1
      AREA = RESULT
      ERRSUM = ABSERR
      IROFF1 = 0
      IROFF2 = 0
C
C            MAIN DO-LOOP
C            ------------
C
      DO 60 LAST = 3,LIMIT
C
C           BISECT THE SUBINTERVAL WITH LARGEST ERROR ESTIMATE.
C
        A1 = ALIST(MAXERR)
        B1 = 0.5E+00*(ALIST(MAXERR)+BLIST(MAXERR))
        A2 = B1
        B2 = BLIST(MAXERR)
C
        CALL QC25S(F,A,B,A1,B1,ALFA,BETA,RI,RJ,RG,RH,AREA1,
     1  ERROR1,RESAS1,INTEGR,NEV)
        NEVAL = NEVAL+NEV
        CALL QC25S(F,A,B,A2,B2,ALFA,BETA,RI,RJ,RG,RH,AREA2,
     1  ERROR2,RESAS2,INTEGR,NEV)
        NEVAL = NEVAL+NEV
C
C           IMPROVE PREVIOUS APPROXIMATIONS INTEGRAL AND ERROR
C           AND TEST FOR ACCURACY.
C
        AREA12 = AREA1+AREA2
        ERRO12 = ERROR1+ERROR2
        ERRSUM = ERRSUM+ERRO12-ERRMAX
        AREA = AREA+AREA12-RLIST(MAXERR)
        IF(A.EQ.A1.OR.B.EQ.B2) GO TO 30
        IF(RESAS1.EQ.ERROR1.OR.RESAS2.EQ.ERROR2) GO TO 30
C
C           TEST FOR ROUNDOFF ERROR.
C
        IF(ABS(RLIST(MAXERR)-AREA12).LT.0.1E-04*ABS(AREA12)
     1  .AND.ERRO12.GE.0.99E+00*ERRMAX) IROFF1 = IROFF1+1
        IF(LAST.GT.10.AND.ERRO12.GT.ERRMAX) IROFF2 = IROFF2+1
   30   RLIST(MAXERR) = AREA1
        RLIST(LAST) = AREA2
C
C           TEST ON ACCURACY.
C
        ERRBND = MAX(EPSABS,EPSREL*ABS(AREA))
        IF(ERRSUM.LE.ERRBND) GO TO 35
C
C           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF INTERVAL
C           BISECTIONS EXCEEDS LIMIT.
C
        IF(LAST.EQ.LIMIT) IER = 1
C
C
C           SET ERROR FLAG IN THE CASE OF ROUNDOFF ERROR.
C
        IF(IROFF1.GE.6.OR.IROFF2.GE.20) IER = 2
C
C           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
C           AT INTERIOR POINTS OF INTEGRATION RANGE.
C
        IF(MAX(ABS(A1),ABS(B2)).LE.(0.1E+01+0.1E+03*EPMACH)*
     1  (ABS(A2)+0.1E+04*UFLOW)) IER = 3
C
C           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
C
   35   IF(ERROR2.GT.ERROR1) GO TO 40
        ALIST(LAST) = A2
        BLIST(MAXERR) = B1
        BLIST(LAST) = B2
        ELIST(MAXERR) = ERROR1
        ELIST(LAST) = ERROR2
        GO TO 50
   40   ALIST(MAXERR) = A2
        ALIST(LAST) = A1
        BLIST(LAST) = B1
        RLIST(MAXERR) = AREA2
        RLIST(LAST) = AREA1
        ELIST(MAXERR) = ERROR2
        ELIST(LAST) = ERROR1
C
C           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
C           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
C           SUBINTERVAL WITH LARGEST ERROR ESTIMATE (TO BE
C           BISECTED NEXT).
C
   50   CALL QPSRT(LIMIT,LAST,MAXERR,ERRMAX,ELIST,IORD,NRMAX)
C ***JUMP OUT OF DO-LOOP
        IF (IER.NE.0.OR.ERRSUM.LE.ERRBND) GO TO 70
   60 CONTINUE
C
C           COMPUTE FINAL RESULT.
C           ---------------------
C
   70 RESULT = 0.0E+00
      DO 80 K=1,LAST
        RESULT = RESULT+RLIST(K)
   80 CONTINUE
      ABSERR = ERRSUM
  999 RETURN
      END