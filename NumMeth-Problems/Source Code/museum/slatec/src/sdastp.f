      SUBROUTINE SDASTP (X, Y, YPRIME, NEQ, RES, JAC, H, WT, JSTART,
     *   IDID, RPAR, IPAR, PHI, DELTA, E, WM, IWM, ALPHA, BETA, GAMMA,
     *   PSI, SIGMA, CJ, CJOLD, HOLD, S, HMIN, UROUND, IPHASE, JCALC, K,
     *   KOLD, NS, NONNEG, NTEMP)
C
      INTEGER  NEQ, JSTART, IDID, IPAR(*), IWM(*), IPHASE, JCALC, K,
     *   KOLD, NS, NONNEG, NTEMP
      REAL  X, Y(*), YPRIME(*), H, WT(*), RPAR(*), PHI(NEQ,*), DELTA(*),
     *   E(*), WM(*), ALPHA(*), BETA(*), GAMMA(*), PSI(*), SIGMA(*), CJ,
     *   CJOLD, HOLD, S, HMIN, UROUND
      EXTERNAL  RES, JAC
C
      EXTERNAL  SDAJAC, SDANRM, SDASLV, SDATRP
      REAL  SDANRM
C
      INTEGER  I, IER, IRES, J, J1, KDIFF, KM1, KNEW, KP1, KP2, LCTF,
     *   LETF, LMXORD, LNJE, LNRE, LNST, M, MAXIT, NCF, NEF, NSF, NSP1
      REAL  ALPHA0, ALPHAS, CJLAST, CK, DELNRM, ENORM, ERK, ERKM1,
     *   ERKM2, ERKP1, ERR, EST, HNEW, OLDNRM, PNORM, R, RATE, TEMP1,
     *   TEMP2, TERK, TERKM1, TERKM2, TERKP1, XOLD, XRATE
      LOGICAL  CONVGD
C
      PARAMETER (LMXORD=3)
      PARAMETER (LNST=11)
      PARAMETER (LNRE=12)
      PARAMETER (LNJE=13)
      PARAMETER (LETF=14)
      PARAMETER (LCTF=15)
C
      DATA MAXIT/4/
      DATA XRATE/0.25E0/
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 1.
C     INITIALIZE. ON THE FIRST CALL,SET
C     THE ORDER TO 1 AND INITIALIZE
C     OTHER VARIABLES.
C-----------------------------------------------------------------------
C
C     INITIALIZATIONS FOR ALL CALLS
C***FIRST EXECUTABLE STATEMENT  SDASTP
      IDID=1
      XOLD=X
      NCF=0
      NSF=0
      NEF=0
      IF(JSTART .NE. 0) GO TO 120
C
C     IF THIS IS THE FIRST STEP,PERFORM
C     OTHER INITIALIZATIONS
      IWM(LETF) = 0
      IWM(LCTF) = 0
      K=1
      KOLD=0
      HOLD=0.0E0
      JSTART=1
      PSI(1)=H
      CJOLD = 1.0E0/H
      CJ = CJOLD
      S = 100.E0
      JCALC = -1
      DELNRM=1.0E0
      IPHASE = 0
      NS=0
120   CONTINUE
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 2
C     COMPUTE COEFFICIENTS OF FORMULAS FOR
C     THIS STEP.
C-----------------------------------------------------------------------
200   CONTINUE
      KP1=K+1
      KP2=K+2
      KM1=K-1
      XOLD=X
      IF(H.NE.HOLD.OR.K .NE. KOLD) NS = 0
      NS=MIN(NS+1,KOLD+2)
      NSP1=NS+1
      IF(KP1 .LT. NS)GO TO 230
C
      BETA(1)=1.0E0
      ALPHA(1)=1.0E0
      TEMP1=H
      GAMMA(1)=0.0E0
      SIGMA(1)=1.0E0
      DO 210 I=2,KP1
         TEMP2=PSI(I-1)
         PSI(I-1)=TEMP1
         BETA(I)=BETA(I-1)*PSI(I-1)/TEMP2
         TEMP1=TEMP2+H
         ALPHA(I)=H/TEMP1
         SIGMA(I)=(I-1)*SIGMA(I-1)*ALPHA(I)
         GAMMA(I)=GAMMA(I-1)+ALPHA(I-1)/H
210      CONTINUE
      PSI(KP1)=TEMP1
230   CONTINUE
C
C     COMPUTE ALPHAS, ALPHA0
      ALPHAS = 0.0E0
      ALPHA0 = 0.0E0
      DO 240 I = 1,K
        ALPHAS = ALPHAS - 1.0E0/I
        ALPHA0 = ALPHA0 - ALPHA(I)
240     CONTINUE
C
C     COMPUTE LEADING COEFFICIENT CJ
      CJLAST = CJ
      CJ = -ALPHAS/H
C
C     COMPUTE VARIABLE STEPSIZE ERROR COEFFICIENT CK
      CK = ABS(ALPHA(KP1) + ALPHAS - ALPHA0)
      CK = MAX(CK,ALPHA(KP1))
C
C     DECIDE WHETHER NEW JACOBIAN IS NEEDED
      TEMP1 = (1.0E0 - XRATE)/(1.0E0 + XRATE)
      TEMP2 = 1.0E0/TEMP1
      IF (CJ/CJOLD .LT. TEMP1 .OR. CJ/CJOLD .GT. TEMP2) JCALC = -1
      IF (CJ .NE. CJLAST) S = 100.E0
C
C     CHANGE PHI TO PHI STAR
      IF(KP1 .LT. NSP1) GO TO 280
      DO 270 J=NSP1,KP1
         DO 260 I=1,NEQ
260         PHI(I,J)=BETA(J)*PHI(I,J)
270      CONTINUE
280   CONTINUE
C
C     UPDATE TIME
      X=X+H
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 3
C     PREDICT THE SOLUTION AND DERIVATIVE,
C     AND SOLVE THE CORRECTOR EQUATION
C-----------------------------------------------------------------------
C
C     FIRST,PREDICT THE SOLUTION AND DERIVATIVE
300   CONTINUE
      DO 310 I=1,NEQ
         Y(I)=PHI(I,1)
310      YPRIME(I)=0.0E0
      DO 330 J=2,KP1
         DO 320 I=1,NEQ
            Y(I)=Y(I)+PHI(I,J)
320         YPRIME(I)=YPRIME(I)+GAMMA(J)*PHI(I,J)
330   CONTINUE
      PNORM = SDANRM (NEQ,Y,WT,RPAR,IPAR)
C
C
C
C     SOLVE THE CORRECTOR EQUATION USING A
C     MODIFIED NEWTON SCHEME.
      CONVGD= .TRUE.
      M=0
      IWM(LNRE)=IWM(LNRE)+1
      IRES = 0
      CALL RES(X,Y,YPRIME,DELTA,IRES,RPAR,IPAR)
      IF (IRES .LT. 0) GO TO 380
C
C
C     IF INDICATED,REEVALUATE THE
C     ITERATION MATRIX PD = DG/DY + CJ*DG/DYPRIME
C     (WHERE G(X,Y,YPRIME)=0). SET
C     JCALC TO 0 AS AN INDICATOR THAT
C     THIS HAS BEEN DONE.
      IF(JCALC .NE. -1)GO TO 340
      IWM(LNJE)=IWM(LNJE)+1
      JCALC=0
      CALL SDAJAC(NEQ,X,Y,YPRIME,DELTA,CJ,H,
     * IER,WT,E,WM,IWM,RES,IRES,UROUND,JAC,RPAR,
     * IPAR,NTEMP)
      CJOLD=CJ
      S = 100.E0
      IF (IRES .LT. 0) GO TO 380
      IF(IER .NE. 0)GO TO 380
      NSF=0
C
C
C     INITIALIZE THE ERROR ACCUMULATION VECTOR E.
340   CONTINUE
      DO 345 I=1,NEQ
345      E(I)=0.0E0
C
C
C     CORRECTOR LOOP.
350   CONTINUE
C
C     MULTIPLY RESIDUAL BY TEMP1 TO ACCELERATE CONVERGENCE
      TEMP1 = 2.0E0/(1.0E0 + CJ/CJOLD)
      DO 355 I = 1,NEQ
355     DELTA(I) = DELTA(I) * TEMP1
C
C     COMPUTE A NEW ITERATE (BACK-SUBSTITUTION).
C     STORE THE CORRECTION IN DELTA.
      CALL SDASLV(NEQ,DELTA,WM,IWM)
C
C     UPDATE Y, E, AND YPRIME
      DO 360 I=1,NEQ
         Y(I)=Y(I)-DELTA(I)
         E(I)=E(I)-DELTA(I)
360      YPRIME(I)=YPRIME(I)-CJ*DELTA(I)
C
C     TEST FOR CONVERGENCE OF THE ITERATION
      DELNRM=SDANRM(NEQ,DELTA,WT,RPAR,IPAR)
      IF (DELNRM .LE. 100.E0*UROUND*PNORM) GO TO 375
      IF (M .GT. 0) GO TO 365
         OLDNRM = DELNRM
         GO TO 367
365   RATE = (DELNRM/OLDNRM)**(1.0E0/M)
      IF (RATE .GT. 0.90E0) GO TO 370
      S = RATE/(1.0E0 - RATE)
367   IF (S*DELNRM .LE. 0.33E0) GO TO 375
C
C     THE CORRECTOR HAS NOT YET CONVERGED.
C     UPDATE M AND TEST WHETHER THE
C     MAXIMUM NUMBER OF ITERATIONS HAVE
C     BEEN TRIED.
      M=M+1
      IF(M.GE.MAXIT)GO TO 370
C
C     EVALUATE THE RESIDUAL
C     AND GO BACK TO DO ANOTHER ITERATION
      IWM(LNRE)=IWM(LNRE)+1
      IRES = 0
      CALL RES(X,Y,YPRIME,DELTA,IRES,
     *  RPAR,IPAR)
      IF (IRES .LT. 0) GO TO 380
      GO TO 350
C
C
C     THE CORRECTOR FAILED TO CONVERGE IN MAXIT
C     ITERATIONS. IF THE ITERATION MATRIX
C     IS NOT CURRENT,RE-DO THE STEP WITH
C     A NEW ITERATION MATRIX.
370   CONTINUE
      IF(JCALC.EQ.0)GO TO 380
      JCALC=-1
      GO TO 300
C
C
C     THE ITERATION HAS CONVERGED.  IF NONNEGATIVITY OF SOLUTION IS
C     REQUIRED, SET THE SOLUTION NONNEGATIVE, IF THE PERTURBATION
C     TO DO IT IS SMALL ENOUGH.  IF THE CHANGE IS TOO LARGE, THEN
C     CONSIDER THE CORRECTOR ITERATION TO HAVE FAILED.
375   IF(NONNEG .EQ. 0) GO TO 390
      DO 377 I = 1,NEQ
377      DELTA(I) = MIN(Y(I),0.0E0)
      DELNRM = SDANRM(NEQ,DELTA,WT,RPAR,IPAR)
      IF(DELNRM .GT. 0.33E0) GO TO 380
      DO 378 I = 1,NEQ
378      E(I) = E(I) - DELTA(I)
      GO TO 390
C
C
C     EXITS FROM BLOCK 3
C     NO CONVERGENCE WITH CURRENT ITERATION
C     MATRIX,OR SINGULAR ITERATION MATRIX
380   CONVGD= .FALSE.
390   JCALC = 1
      IF(.NOT.CONVGD)GO TO 600
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 4
C     ESTIMATE THE ERRORS AT ORDERS K,K-1,K-2
C     AS IF CONSTANT STEPSIZE WAS USED. ESTIMATE
C     THE LOCAL ERROR AT ORDER K AND TEST
C     WHETHER THE CURRENT STEP IS SUCCESSFUL.
C-----------------------------------------------------------------------
C
C     ESTIMATE ERRORS AT ORDERS K,K-1,K-2
      ENORM = SDANRM(NEQ,E,WT,RPAR,IPAR)
      ERK = SIGMA(K+1)*ENORM
      TERK = (K+1)*ERK
      EST = ERK
      KNEW=K
      IF(K .EQ. 1)GO TO 430
      DO 405 I = 1,NEQ
405     DELTA(I) = PHI(I,KP1) + E(I)
      ERKM1=SIGMA(K)*SDANRM(NEQ,DELTA,WT,RPAR,IPAR)
      TERKM1 = K*ERKM1
      IF(K .GT. 2)GO TO 410
      IF(TERKM1 .LE. 0.5E0*TERK)GO TO 420
      GO TO 430
410   CONTINUE
      DO 415 I = 1,NEQ
415     DELTA(I) = PHI(I,K) + DELTA(I)
      ERKM2=SIGMA(K-1)*SDANRM(NEQ,DELTA,WT,RPAR,IPAR)
      TERKM2 = (K-1)*ERKM2
      IF(MAX(TERKM1,TERKM2).GT.TERK)GO TO 430
C     LOWER THE ORDER
420   CONTINUE
      KNEW=K-1
      EST = ERKM1
C
C
C     CALCULATE THE LOCAL ERROR FOR THE CURRENT STEP
C     TO SEE IF THE STEP WAS SUCCESSFUL
430   CONTINUE
      ERR = CK * ENORM
      IF(ERR .GT. 1.0E0)GO TO 600
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 5
C     THE STEP IS SUCCESSFUL. DETERMINE
C     THE BEST ORDER AND STEPSIZE FOR
C     THE NEXT STEP. UPDATE THE DIFFERENCES
C     FOR THE NEXT STEP.
C-----------------------------------------------------------------------
      IDID=1
      IWM(LNST)=IWM(LNST)+1
      KDIFF=K-KOLD
      KOLD=K
      HOLD=H
C
C
C     ESTIMATE THE ERROR AT ORDER K+1 UNLESS:
C        ALREADY DECIDED TO LOWER ORDER, OR
C        ALREADY USING MAXIMUM ORDER, OR
C        STEPSIZE NOT CONSTANT, OR
C        ORDER RAISED IN PREVIOUS STEP
      IF(KNEW.EQ.KM1.OR.K.EQ.IWM(LMXORD))IPHASE=1
      IF(IPHASE .EQ. 0)GO TO 545
      IF(KNEW.EQ.KM1)GO TO 540
      IF(K.EQ.IWM(LMXORD)) GO TO 550
      IF(KP1.GE.NS.OR.KDIFF.EQ.1)GO TO 550
      DO 510 I=1,NEQ
510      DELTA(I)=E(I)-PHI(I,KP2)
      ERKP1 = (1.0E0/(K+2))*SDANRM(NEQ,DELTA,WT,RPAR,IPAR)
      TERKP1 = (K+2)*ERKP1
      IF(K.GT.1)GO TO 520
      IF(TERKP1.GE.0.5E0*TERK)GO TO 550
      GO TO 530
520   IF(TERKM1.LE.MIN(TERK,TERKP1))GO TO 540
      IF(TERKP1.GE.TERK.OR.K.EQ.IWM(LMXORD))GO TO 550
C
C     RAISE ORDER
530   K=KP1
      EST = ERKP1
      GO TO 550
C
C     LOWER ORDER
540   K=KM1
      EST = ERKM1
      GO TO 550
C
C     IF IPHASE = 0, INCREASE ORDER BY ONE AND MULTIPLY STEPSIZE BY
C     FACTOR TWO
545   K = KP1
      HNEW = H*2.0E0
      H = HNEW
      GO TO 575
C
C
C     DETERMINE THE APPROPRIATE STEPSIZE FOR
C     THE NEXT STEP.
550   HNEW=H
      TEMP2=K+1
      R=(2.0E0*EST+0.0001E0)**(-1.0E0/TEMP2)
      IF(R .LT. 2.0E0) GO TO 555
      HNEW = 2.0E0*H
      GO TO 560
555   IF(R .GT. 1.0E0) GO TO 560
      R = MAX(0.5E0,MIN(0.9E0,R))
      HNEW = H*R
560   H=HNEW
C
C
C     UPDATE DIFFERENCES FOR NEXT STEP
575   CONTINUE
      IF(KOLD.EQ.IWM(LMXORD))GO TO 585
      DO 580 I=1,NEQ
580      PHI(I,KP2)=E(I)
585   CONTINUE
      DO 590 I=1,NEQ
590      PHI(I,KP1)=PHI(I,KP1)+E(I)
      DO 595 J1=2,KP1
         J=KP1-J1+1
         DO 595 I=1,NEQ
595      PHI(I,J)=PHI(I,J)+PHI(I,J+1)
      RETURN
C
C
C
C
C
C-----------------------------------------------------------------------
C     BLOCK 6
C     THE STEP IS UNSUCCESSFUL. RESTORE X,PSI,PHI
C     DETERMINE APPROPRIATE STEPSIZE FOR
C     CONTINUING THE INTEGRATION, OR EXIT WITH
C     AN ERROR FLAG IF THERE HAVE BEEN MANY
C     FAILURES.
C-----------------------------------------------------------------------
600   IPHASE = 1
C
C     RESTORE X,PHI,PSI
      X=XOLD
      IF(KP1.LT.NSP1)GO TO 630
      DO 620 J=NSP1,KP1
         TEMP1=1.0E0/BETA(J)
         DO 610 I=1,NEQ
610         PHI(I,J)=TEMP1*PHI(I,J)
620      CONTINUE
630   CONTINUE
      DO 640 I=2,KP1
640      PSI(I-1)=PSI(I)-H
C
C
C     TEST WHETHER FAILURE IS DUE TO CORRECTOR ITERATION
C     OR ERROR TEST
      IF(CONVGD)GO TO 660
      IWM(LCTF)=IWM(LCTF)+1
C
C
C     THE NEWTON ITERATION FAILED TO CONVERGE WITH
C     A CURRENT ITERATION MATRIX.  DETERMINE THE CAUSE
C     OF THE FAILURE AND TAKE APPROPRIATE ACTION.
      IF(IER.EQ.0)GO TO 650
C
C     THE ITERATION MATRIX IS SINGULAR. REDUCE
C     THE STEPSIZE BY A FACTOR OF 4. IF
C     THIS HAPPENS THREE TIMES IN A ROW ON
C     THE SAME STEP, RETURN WITH AN ERROR FLAG
      NSF=NSF+1
      R = 0.25E0
      H=H*R
      IF (NSF .LT. 3 .AND. ABS(H) .GE. HMIN) GO TO 690
      IDID=-8
      GO TO 675
C
C
C     THE NEWTON ITERATION FAILED TO CONVERGE FOR A REASON
C     OTHER THAN A SINGULAR ITERATION MATRIX.  IF IRES = -2, THEN
C     RETURN.  OTHERWISE, REDUCE THE STEPSIZE AND TRY AGAIN, UNLESS
C     TOO MANY FAILURES HAVE OCCURRED.
650   CONTINUE
      IF (IRES .GT. -2) GO TO 655
      IDID = -11
      GO TO 675
655   NCF = NCF + 1
      R = 0.25E0
      H = H*R
      IF (NCF .LT. 10 .AND. ABS(H) .GE. HMIN) GO TO 690
      IDID = -7
      IF (IRES .LT. 0) IDID = -10
      IF (NEF .GE. 3) IDID = -9
      GO TO 675
C
C
C     THE NEWTON SCHEME CONVERGED, AND THE CAUSE
C     OF THE FAILURE WAS THE ERROR ESTIMATE
C     EXCEEDING THE TOLERANCE.
660   NEF=NEF+1
      IWM(LETF)=IWM(LETF)+1
      IF (NEF .GT. 1) GO TO 665
C
C     ON FIRST ERROR TEST FAILURE, KEEP CURRENT ORDER OR LOWER
C     ORDER BY ONE.  COMPUTE NEW STEPSIZE BASED ON DIFFERENCES
C     OF THE SOLUTION.
      K = KNEW
      TEMP2 = K + 1
      R = 0.90E0*(2.0E0*EST+0.0001E0)**(-1.0E0/TEMP2)
      R = MAX(0.25E0,MIN(0.9E0,R))
      H = H*R
      IF (ABS(H) .GE. HMIN) GO TO 690
      IDID = -6
      GO TO 675
C
C     ON SECOND ERROR TEST FAILURE, USE THE CURRENT ORDER OR
C     DECREASE ORDER BY ONE.  REDUCE THE STEPSIZE BY A FACTOR OF
C     FOUR.
665   IF (NEF .GT. 2) GO TO 670
      K = KNEW
      H = 0.25E0*H
      IF (ABS(H) .GE. HMIN) GO TO 690
      IDID = -6
      GO TO 675
C
C     ON THIRD AND SUBSEQUENT ERROR TEST FAILURES, SET THE ORDER TO
C     ONE AND REDUCE THE STEPSIZE BY A FACTOR OF FOUR.
670   K = 1
      H = 0.25E0*H
      IF (ABS(H) .GE. HMIN) GO TO 690
      IDID = -6
      GO TO 675
C
C
C
C
C     FOR ALL CRASHES, RESTORE Y TO ITS LAST VALUE,
C     INTERPOLATE TO FIND YPRIME AT LAST X, AND RETURN
675   CONTINUE
      CALL SDATRP(X,X,Y,YPRIME,NEQ,K,PHI,PSI)
      RETURN
C
C
C     GO BACK AND TRY THIS STEP AGAIN
690   GO TO 200
C
C------END OF SUBROUTINE SDASTP------
      END
