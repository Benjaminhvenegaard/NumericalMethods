      DOUBLE PRECISION FUNCTION DGAMRN (X)
      INTEGER I, I1M11, K, MX, NX
      INTEGER I1MACH
      DOUBLE PRECISION FLN, GR, RLN, S, TOL, TRM, X, XDMY, XINC, XM,
     * XMIN, XP, XSQ
      DOUBLE PRECISION D1MACH
      DIMENSION GR(12)
      SAVE GR
C
      DATA GR(1), GR(2), GR(3), GR(4), GR(5), GR(6), GR(7), GR(8),
     * GR(9), GR(10), GR(11), GR(12) /1.00000000000000000D+00,
     * -1.56250000000000000D-02,2.56347656250000000D-03,
     * -1.27983093261718750D-03,1.34351104497909546D-03,
     * -2.43289663922041655D-03,6.75423753364157164D-03,
     * -2.66369606131178216D-02,1.41527455519564332D-01,
     * -9.74384543032201613D-01,8.43686251229783675D+00,
     * -8.97258321640552515D+01/
C
C***FIRST EXECUTABLE STATEMENT  DGAMRN
      NX = INT(X)
      TOL = MAX(D1MACH(4),1.0D-18)
      I1M11 = I1MACH(14)
      RLN = D1MACH(5)*I1M11
      FLN = MIN(RLN,20.0D0)
      FLN = MAX(FLN,3.0D0)
      FLN = FLN - 3.0D0
      XM = 2.0D0 + FLN*(0.2366D0+0.01723D0*FLN)
      MX = INT(XM) + 1
      XMIN = MX
      XDMY = X - 0.25D0
      XINC = 0.0D0
      IF (X.GE.XMIN) GO TO 10
      XINC = XMIN - NX
      XDMY = XDMY + XINC
   10 CONTINUE
      S = 1.0D0
      IF (XDMY*TOL.GT.1.0D0) GO TO 30
      XSQ = 1.0D0/(XDMY*XDMY)
      XP = XSQ
      DO 20 K=2,12
        TRM = GR(K)*XP
        IF (ABS(TRM).LT.TOL) GO TO 30
        S = S + TRM
        XP = XP*XSQ
   20 CONTINUE
   30 CONTINUE
      S = S/SQRT(XDMY)
      IF (XINC.NE.0.0D0) GO TO 40
      DGAMRN = S
      RETURN
   40 CONTINUE
      NX = INT(XINC)
      XP = 0.0D0
      DO 50 I=1,NX
        S = S*(1.0D0+0.5D0/(X+XP))
        XP = XP + 1.0D0
   50 CONTINUE
      DGAMRN = S
      RETURN
      END
