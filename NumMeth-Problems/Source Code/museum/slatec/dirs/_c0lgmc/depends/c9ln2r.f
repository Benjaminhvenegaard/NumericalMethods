      COMPLEX FUNCTION C9LN2R (Z)
      COMPLEX Z
C***FIRST EXECUTABLE STATEMENT  C9LN2R
      X = REAL (Z)
      Y = AIMAG (Z)
C
      CABSZ = ABS(Z)
      IF (CABSZ.GT.0.8125) GO TO 20
C
      C9LN2R = CMPLX (1.0/3.0, 0.0)
      IF (CABSZ.EQ.0.0) RETURN
C
      XZ = X/CABSZ
      YZ = Y/CABSZ
C
      ARG = 2.0*XZ + CABSZ
      RPART = 0.5*ARG**3*R9LN2R(CABSZ*ARG) - XZ - 0.25*CABSZ
      Y1X = YZ/(1.0+X)
      AIPART = Y1X * (XZ**2 + Y1X**2*R9ATN1(CABSZ*Y1X) )
C
      C9LN2R = CMPLX(XZ,-YZ)**3 * CMPLX(RPART,AIPART)
      RETURN
C
 20   C9LN2R = (LOG(1.0+Z) - Z*(1.0-0.5*Z)) / Z**3
      RETURN
C
      END
