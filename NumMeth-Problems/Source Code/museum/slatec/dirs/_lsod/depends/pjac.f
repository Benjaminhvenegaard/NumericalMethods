      SUBROUTINE PJAC (NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F,
     +   JAC, RPAR, IPAR)
C
CLLL. OPTIMIZE
      INTEGER NEQ, NYH, IWM, I, I1, I2, IER, II, IOWND, IOWNS, J, J1,
     1   JJ, JSTART, KFLAG, L, LENP, MAXORD, MBA, MBAND, MEB1, MEBAND,
     2   METH, MITER, ML, ML3, MU, N, NFE, NJE, NQ, NQU, NST
      EXTERNAL F, JAC
      REAL Y, YH, EWT, FTEM, SAVF, WM,
     1   ROWND, ROWNS, EL0, H, HMIN, HMXI, HU, TN, UROUND,
     2   CON, DI, FAC, HL0, R, R0, SRUR, YI, YJ, YJJ, VNWRMS
      DIMENSION         Y(*), YH(NYH,*), EWT(*), FTEM(*), SAVF(*),
     1   WM(*), IWM(*), RPAR(*), IPAR(*)
      COMMON /DEBDF1/ ROWND, ROWNS(210),
     1   EL0, H, HMIN, HMXI, HU, TN, UROUND, IOWND(14), IOWNS(6),
     2   IER, JSTART, KFLAG, L, METH, MITER, MAXORD, N, NQ, NST, NFE,
     3   NJE, NQU
C-----------------------------------------------------------------------
C PJAC IS CALLED BY STOD  TO COMPUTE AND PROCESS THE MATRIX
C P = I - H*EL(1)*J , WHERE J IS AN APPROXIMATION TO THE JACOBIAN.
C HERE J IS COMPUTED BY THE USER-SUPPLIED ROUTINE JAC IF
C MITER = 1 OR 4, OR BY FINITE DIFFERENCING IF MITER = 2, 3, OR 5.
C IF MITER = 3, A DIAGONAL APPROXIMATION TO J IS USED.
C J IS STORED IN WM AND REPLACED BY P.  IF MITER .NE. 3, P IS THEN
C SUBJECTED TO LU DECOMPOSITION IN PREPARATION FOR LATER SOLUTION
C OF LINEAR SYSTEMS WITH P AS COEFFICIENT MATRIX. THIS IS DONE
C BY SGEFA IF MITER = 1 OR 2, AND BY SGBFA IF MITER = 4 OR 5.
C
C IN ADDITION TO VARIABLES DESCRIBED PREVIOUSLY, COMMUNICATION
C WITH PJAC USES THE FOLLOWING..
C Y    = ARRAY CONTAINING PREDICTED VALUES ON ENTRY.
C FTEM = WORK ARRAY OF LENGTH N (ACOR IN STOD ).
C SAVF = ARRAY CONTAINING F EVALUATED AT PREDICTED Y.
C WM   = REAL WORK SPACE FOR MATRICES.  ON OUTPUT IT CONTAINS THE
C        INVERSE DIAGONAL MATRIX IF MITER = 3 AND THE LU DECOMPOSITION
C        OF P IF MITER IS 1, 2 , 4, OR 5.
C        STORAGE OF MATRIX ELEMENTS STARTS AT WM(3).
C        WM ALSO CONTAINS THE FOLLOWING MATRIX-RELATED DATA..
C        WM(1) = SQRT(UROUND), USED IN NUMERICAL JACOBIAN INCREMENTS.
C        WM(2) = H*EL0, SAVED FOR LATER USE IF MITER = 3.
C IWM  = INTEGER WORK SPACE CONTAINING PIVOT INFORMATION, STARTING AT
C        IWM(21), IF MITER IS 1, 2, 4, OR 5.  IWM ALSO CONTAINS THE
C        BAND PARAMETERS ML = IWM(1) AND MU = IWM(2) IF MITER IS 4 OR 5.
C EL0  = EL(1) (INPUT).
C IER  = OUTPUT ERROR FLAG,  = 0 IF NO TROUBLE, .NE. 0 IF
C        P MATRIX FOUND TO BE SINGULAR.
C THIS ROUTINE ALSO USES THE COMMON VARIABLES EL0, H, TN, UROUND,
C MITER, N, NFE, AND NJE.
C-----------------------------------------------------------------------
C***FIRST EXECUTABLE STATEMENT  PJAC
      NJE = NJE + 1
      HL0 = H*EL0
      GO TO (100, 200, 300, 400, 500), MITER
C IF MITER = 1, CALL JAC AND MULTIPLY BY SCALAR. -----------------------
 100  LENP = N*N
      DO 110 I = 1,LENP
 110    WM(I+2) = 0.0E0
      CALL JAC (TN, Y, WM(3), N, RPAR, IPAR)
      CON = -HL0
      DO 120 I = 1,LENP
 120    WM(I+2) = WM(I+2)*CON
      GO TO 240
C IF MITER = 2, MAKE N CALLS TO F TO APPROXIMATE J. --------------------
 200  FAC = VNWRMS (N, SAVF, EWT)
      R0 = 1000.0E0*ABS(H)*UROUND*N*FAC
      IF (R0 .EQ. 0.0E0) R0 = 1.0E0
      SRUR = WM(1)
      J1 = 2
      DO 230 J = 1,N
        YJ = Y(J)
        R = MAX(SRUR*ABS(YJ),R0*EWT(J))
        Y(J) = Y(J) + R
        FAC = -HL0/R
        CALL F (TN, Y, FTEM, RPAR, IPAR)
        DO 220 I = 1,N
 220      WM(I+J1) = (FTEM(I) - SAVF(I))*FAC
        Y(J) = YJ
        J1 = J1 + N
 230    CONTINUE
      NFE = NFE + N
C ADD IDENTITY MATRIX. -------------------------------------------------
 240  J = 3
      DO 250 I = 1,N
        WM(J) = WM(J) + 1.0E0
 250    J = J + (N + 1)
C DO LU DECOMPOSITION ON P. --------------------------------------------
      CALL SGEFA (WM(3), N, N, IWM(21), IER)
      RETURN
C IF MITER = 3, CONSTRUCT A DIAGONAL APPROXIMATION TO J AND P. ---------
 300  WM(2) = HL0
      IER = 0
      R = EL0*0.1E0
      DO 310 I = 1,N
 310    Y(I) = Y(I) + R*(H*SAVF(I) - YH(I,2))
      CALL F (TN, Y, WM(3), RPAR, IPAR)
      NFE = NFE + 1
      DO 320 I = 1,N
        R0 = H*SAVF(I) - YH(I,2)
        DI = 0.1E0*R0 - H*(WM(I+2) - SAVF(I))
        WM(I+2) = 1.0E0
        IF (ABS(R0) .LT. UROUND*EWT(I)) GO TO 320
        IF (ABS(DI) .EQ. 0.0E0) GO TO 330
        WM(I+2) = 0.1E0*R0/DI
 320    CONTINUE
      RETURN
 330  IER = -1
      RETURN
C IF MITER = 4, CALL JAC AND MULTIPLY BY SCALAR. -----------------------
 400  ML = IWM(1)
      MU = IWM(2)
      ML3 =  3
      MBAND = ML + MU + 1
      MEBAND = MBAND + ML
      LENP = MEBAND*N
      DO 410 I = 1,LENP
 410    WM(I+2) = 0.0E0
      CALL JAC (TN, Y, WM(ML3), MEBAND, RPAR, IPAR)
      CON = -HL0
      DO 420 I = 1,LENP
 420    WM(I+2) = WM(I+2)*CON
      GO TO 570
C IF MITER = 5, MAKE MBAND CALLS TO F TO APPROXIMATE J. ----------------
 500  ML = IWM(1)
      MU = IWM(2)
      MBAND = ML + MU + 1
      MBA = MIN(MBAND,N)
      MEBAND = MBAND + ML
      MEB1 = MEBAND - 1
      SRUR = WM(1)
      FAC = VNWRMS (N, SAVF, EWT)
      R0 = 1000.0E0*ABS(H)*UROUND*N*FAC
      IF (R0 .EQ. 0.0E0) R0 = 1.0E0
      DO 560 J = 1,MBA
        DO 530 I = J,N,MBAND
          YI = Y(I)
          R = MAX(SRUR*ABS(YI),R0*EWT(I))
 530      Y(I) = Y(I) + R
        CALL F (TN, Y, FTEM, RPAR, IPAR)
        DO 550 JJ = J,N,MBAND
          Y(JJ) = YH(JJ,1)
          YJJ = Y(JJ)
          R = MAX(SRUR*ABS(YJJ),R0*EWT(JJ))
          FAC = -HL0/R
          I1 = MAX(JJ-MU,1)
          I2 = MIN(JJ+ML,N)
          II = JJ*MEB1 - ML + 2
          DO 540 I = I1,I2
 540        WM(II+I) = (FTEM(I) - SAVF(I))*FAC
 550      CONTINUE
 560    CONTINUE
      NFE = NFE + MBA
C ADD IDENTITY MATRIX. -------------------------------------------------
 570  II = MBAND + 2
      DO 580 I = 1,N
        WM(II) = WM(II) + 1.0E0
 580    II = II + MEBAND
C DO LU DECOMPOSITION OF P. --------------------------------------------
      CALL SGBFA (WM(3), MEBAND, N, ML, MU, IWM(21), IER)
      RETURN
C----------------------- END OF SUBROUTINE PJAC -----------------------
      END
