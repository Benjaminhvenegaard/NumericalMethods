      SUBROUTINE DRC6J (L2, L3, L4, L5, L6, L1MIN, L1MAX, SIXCOF, NDIM,
     +   IER)
C
      INTEGER NDIM, IER
      DOUBLE PRECISION L2, L3, L4, L5, L6, L1MIN, L1MAX, SIXCOF(NDIM)
C
      INTEGER I, INDEX, LSTEP, N, NFIN, NFINP1, NFINP2, NFINP3, NLIM,
     +        NSTEP2
      DOUBLE PRECISION A1, A1S, A2, A2S, C1, C1OLD, C2, CNORM, D1MACH,
     +                 DENOM, DV, EPS, HUGE, L1, NEWFAC, OLDFAC, ONE,
     +                 RATIO, SIGN1, SIGN2, SRHUGE, SRTINY, SUM1, SUM2,
     +                 SUMBAC, SUMFOR, SUMUNI, THREE, THRESH, TINY, TWO,
     +                 X, X1, X2, X3, Y, Y1, Y2, Y3, ZERO
C
      DATA  ZERO,EPS,ONE,TWO,THREE /0.0D0,0.01D0,1.0D0,2.0D0,3.0D0/
C
C***FIRST EXECUTABLE STATEMENT  DRC6J
      IER=0
C  HUGE is the square root of one twentieth of the largest floating
C  point number, approximately.
      HUGE = SQRT(D1MACH(2)/20.0D0)
      SRHUGE = SQRT(HUGE)
      TINY = 1.0D0/HUGE
      SRTINY = 1.0D0/SRHUGE
C
C     LMATCH = ZERO
C
C  Check error conditions 1, 2, and 3.
      IF((MOD(L2+L3+L5+L6+EPS,ONE).GE.EPS+EPS).OR.
     +   (MOD(L4+L2+L6+EPS,ONE).GE.EPS+EPS))THEN
         IER=1
         CALL XERMSG('SLATEC','DRC6J','L2+L3+L5+L6 or L4+L2+L6 not '//
     +      'integer.',IER,1)
         RETURN
      ELSEIF((L4+L2-L6.LT.ZERO).OR.(L4-L2+L6.LT.ZERO).OR.
     +   (-L4+L2+L6.LT.ZERO))THEN
         IER=2
         CALL XERMSG('SLATEC','DRC6J','L4, L2, L6 triangular '//
     +      'condition not satisfied.',IER,1)
         RETURN
      ELSEIF((L4-L5+L3.LT.ZERO).OR.(L4+L5-L3.LT.ZERO).OR.
     +   (-L4+L5+L3.LT.ZERO))THEN
         IER=3
         CALL XERMSG('SLATEC','DRC6J','L4, L5, L3 triangular '//
     +      'condition not satisfied.',IER,1)
         RETURN
      ENDIF
C
C  Limits for L1
C
      L1MIN = MAX(ABS(L2-L3),ABS(L5-L6))
      L1MAX = MIN(L2+L3,L5+L6)
C
C  Check error condition 4.
      IF(MOD(L1MAX-L1MIN+EPS,ONE).GE.EPS+EPS)THEN
         IER=4
         CALL XERMSG('SLATEC','DRC6J','L1MAX-L1MIN not integer.',IER,1)
         RETURN
      ENDIF
      IF(L1MIN.LT.L1MAX-EPS)   GO TO 20
      IF(L1MIN.LT.L1MAX+EPS)   GO TO 10
C
C  Check error condition 5.
      IER=5
      CALL XERMSG('SLATEC','DRC6J','L1MIN greater than L1MAX.',IER,1)
      RETURN
C
C
C  This is reached in case that L1 can take only one value
C
   10 CONTINUE
C     LSCALE = 0
      SIXCOF(1) = (-ONE) ** INT(L2+L3+L5+L6+EPS) /
     1            SQRT((L1MIN+L1MIN+ONE)*(L4+L4+ONE))
      RETURN
C
C
C  This is reached in case that L1 can take more than one value.
C
   20 CONTINUE
C     LSCALE = 0
      NFIN = INT(L1MAX-L1MIN+ONE+EPS)
      IF(NDIM-NFIN)   21, 23, 23
C
C  Check error condition 6.
   21 IER = 6
      CALL XERMSG('SLATEC','DRC6J','Dimension of result array for 6j '//
     +            'coefficients too small.',IER,1)
      RETURN
C
C
C  Start of forward recursion
C
   23 L1 = L1MIN
      NEWFAC = 0.0D0
      C1 = 0.0D0
      SIXCOF(1) = SRTINY
      SUM1 = (L1+L1+ONE) * TINY
C
      LSTEP = 1
   30 LSTEP = LSTEP + 1
      L1 = L1 + ONE
C
      OLDFAC = NEWFAC
      A1 = (L1+L2+L3+ONE) * (L1-L2+L3) * (L1+L2-L3) * (-L1+L2+L3+ONE)
      A2 = (L1+L5+L6+ONE) * (L1-L5+L6) * (L1+L5-L6) * (-L1+L5+L6+ONE)
      NEWFAC = SQRT(A1*A2)
C
      IF(L1.LT.ONE+EPS)   GO TO 40
C
      DV = TWO * ( L2*(L2+ONE)*L5*(L5+ONE) + L3*(L3+ONE)*L6*(L6+ONE)
     1           - L1*(L1-ONE)*L4*(L4+ONE) )
     2                   - (L2*(L2+ONE) + L3*(L3+ONE) - L1*(L1-ONE))
     3                   * (L5*(L5+ONE) + L6*(L6+ONE) - L1*(L1-ONE))
C
      DENOM = (L1-ONE) * NEWFAC
C
      IF(LSTEP-2)  32, 32, 31
C
   31 C1OLD = ABS(C1)
   32 C1 = - (L1+L1-ONE) * DV / DENOM
      GO TO 50
C
C  If L1 = 1, (L1 - 1) has to be factored out of DV, hence
C
   40 C1 = - TWO * ( L2*(L2+ONE) + L5*(L5+ONE) - L4*(L4+ONE) )
     1 / NEWFAC
C
   50 IF(LSTEP.GT.2)   GO TO 60
C
C  If L1 = L1MIN + 1, the third term in recursion equation vanishes
C
      X = SRTINY * C1
      SIXCOF(2) = X
      SUM1 = SUM1 + TINY * (L1+L1+ONE) * C1 * C1
C
      IF(LSTEP.EQ.NFIN)   GO TO 220
      GO TO 30
C
C
   60 C2 = - L1 * OLDFAC / DENOM
C
C  Recursion to the next 6j coefficient X
C
      X = C1 * SIXCOF(LSTEP-1) + C2 * SIXCOF(LSTEP-2)
      SIXCOF(LSTEP) = X
C
      SUMFOR = SUM1
      SUM1 = SUM1 + (L1+L1+ONE) * X * X
      IF(LSTEP.EQ.NFIN)   GO TO 100
C
C  See if last unnormalized 6j coefficient exceeds SRHUGE
C
      IF(ABS(X).LT.SRHUGE)   GO TO 80
C
C  This is reached if last 6j coefficient larger than SRHUGE,
C  so that the recursion series SIXCOF(1), ... ,SIXCOF(LSTEP)
C  has to be rescaled to prevent overflow
C
C     LSCALE = LSCALE + 1
      DO 70 I=1,LSTEP
      IF(ABS(SIXCOF(I)).LT.SRTINY)   SIXCOF(I) = ZERO
   70 SIXCOF(I) = SIXCOF(I) / SRHUGE
      SUM1 = SUM1 / HUGE
      SUMFOR = SUMFOR / HUGE
      X = X / SRHUGE
C
C
C  As long as the coefficient ABS(C1) is decreasing, the recursion
C  proceeds towards increasing 6j values and, hence, is numerically
C  stable.  Once an increase of ABS(C1) is detected, the recursion
C  direction is reversed.
C
   80 IF(C1OLD-ABS(C1))   100, 100, 30
C
C
C  Keep three 6j coefficients around LMATCH for comparison later
C  with backward recursion.
C
  100 CONTINUE
C     LMATCH = L1 - 1
      X1 = X
      X2 = SIXCOF(LSTEP-1)
      X3 = SIXCOF(LSTEP-2)
C
C
C
C  Starting backward recursion from L1MAX taking NSTEP2 steps, so
C  that forward and backward recursion overlap at the three points
C  L1 = LMATCH+1, LMATCH, LMATCH-1.
C
      NFINP1 = NFIN + 1
      NFINP2 = NFIN + 2
      NFINP3 = NFIN + 3
      NSTEP2 = NFIN - LSTEP + 3
      L1 = L1MAX
C
      SIXCOF(NFIN) = SRTINY
      SUM2 = (L1+L1+ONE) * TINY
C
C
      L1 = L1 + TWO
      LSTEP = 1
  110 LSTEP = LSTEP + 1
      L1 = L1 - ONE
C
      OLDFAC = NEWFAC
      A1S = (L1+L2+L3)*(L1-L2+L3-ONE)*(L1+L2-L3-ONE)*(-L1+L2+L3+TWO)
      A2S = (L1+L5+L6)*(L1-L5+L6-ONE)*(L1+L5-L6-ONE)*(-L1+L5+L6+TWO)
      NEWFAC = SQRT(A1S*A2S)
C
      DV = TWO * ( L2*(L2+ONE)*L5*(L5+ONE) + L3*(L3+ONE)*L6*(L6+ONE)
     1           - L1*(L1-ONE)*L4*(L4+ONE) )
     2                   - (L2*(L2+ONE) + L3*(L3+ONE) - L1*(L1-ONE))
     3                   * (L5*(L5+ONE) + L6*(L6+ONE) - L1*(L1-ONE))
C
      DENOM = L1 * NEWFAC
      C1 = - (L1+L1-ONE) * DV / DENOM
      IF(LSTEP.GT.2)   GO TO 120
C
C  If L1 = L1MAX + 1 the third term in the recursion equation vanishes
C
      Y = SRTINY * C1
      SIXCOF(NFIN-1) = Y
      IF(LSTEP.EQ.NSTEP2)   GO TO 200
      SUMBAC = SUM2
      SUM2 = SUM2 + (L1+L1-THREE) * C1 * C1 * TINY
      GO TO 110
C
C
  120 C2 = - (L1-ONE) * OLDFAC / DENOM
C
C  Recursion to the next 6j coefficient Y
C
      Y = C1 * SIXCOF(NFINP2-LSTEP) + C2 * SIXCOF(NFINP3-LSTEP)
      IF(LSTEP.EQ.NSTEP2)   GO TO 200
      SIXCOF(NFINP1-LSTEP) = Y
      SUMBAC = SUM2
      SUM2 = SUM2 + (L1+L1-THREE) * Y * Y
C
C  See if last unnormalized 6j coefficient exceeds SRHUGE
C
      IF(ABS(Y).LT.SRHUGE)   GO TO 110
C
C  This is reached if last 6j coefficient larger than SRHUGE,
C  so that the recursion series SIXCOF(NFIN), ... ,SIXCOF(NFIN-LSTEP+1)
C  has to be rescaled to prevent overflow
C
C     LSCALE = LSCALE + 1
      DO 130 I=1,LSTEP
      INDEX = NFIN-I+1
      IF(ABS(SIXCOF(INDEX)).LT.SRTINY)   SIXCOF(INDEX) = ZERO
  130 SIXCOF(INDEX) = SIXCOF(INDEX) / SRHUGE
      SUMBAC = SUMBAC / HUGE
      SUM2 = SUM2 / HUGE
C
      GO TO 110
C
C
C  The forward recursion 6j coefficients X1, X2, X3 are to be matched
C  with the corresponding backward recursion values Y1, Y2, Y3.
C
  200 Y3 = Y
      Y2 = SIXCOF(NFINP2-LSTEP)
      Y1 = SIXCOF(NFINP3-LSTEP)
C
C
C  Determine now RATIO such that YI = RATIO * XI  (I=1,2,3) holds
C  with minimal error.
C
      RATIO = ( X1*Y1 + X2*Y2 + X3*Y3 ) / ( X1*X1 + X2*X2 + X3*X3 )
      NLIM = NFIN - NSTEP2 + 1
C
      IF(ABS(RATIO).LT.ONE)   GO TO 211
C
      DO 210 N=1,NLIM
  210 SIXCOF(N) = RATIO * SIXCOF(N)
      SUMUNI = RATIO * RATIO * SUMFOR + SUMBAC
      GO TO 230
C
  211 NLIM = NLIM + 1
      RATIO = ONE / RATIO
      DO 212 N=NLIM,NFIN
  212 SIXCOF(N) = RATIO * SIXCOF(N)
      SUMUNI = SUMFOR + RATIO*RATIO*SUMBAC
      GO TO 230
C
  220 SUMUNI = SUM1
C
C
C  Normalize 6j coefficients
C
  230 CNORM = ONE / SQRT((L4+L4+ONE)*SUMUNI)
C
C  Sign convention for last 6j coefficient determines overall phase
C
      SIGN1 = SIGN(ONE,SIXCOF(NFIN))
      SIGN2 = (-ONE) ** INT(L2+L3+L5+L6+EPS)
      IF(SIGN1*SIGN2) 235,235,236
  235 CNORM = - CNORM
C
  236 IF(ABS(CNORM).LT.ONE)   GO TO 250
C
      DO 240 N=1,NFIN
  240 SIXCOF(N) = CNORM * SIXCOF(N)
      RETURN
C
  250 THRESH = TINY / ABS(CNORM)
      DO 251 N=1,NFIN
      IF(ABS(SIXCOF(N)).LT.THRESH)   SIXCOF(N) = ZERO
  251 SIXCOF(N) = CNORM * SIXCOF(N)
C
      RETURN
      END
