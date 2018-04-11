      SUBROUTINE DPSORT (DX, N, IPERM, KFLAG, IER)
C     .. Scalar Arguments ..
      INTEGER IER, KFLAG, N
C     .. Array Arguments ..
      DOUBLE PRECISION DX(*)
      INTEGER IPERM(*)
C     .. Local Scalars ..
      DOUBLE PRECISION R, TEMP
      INTEGER I, IJ, INDX, INDX0, ISTRT, J, K, KK, L, LM, LMT, M, NN
C     .. Local Arrays ..
      INTEGER IL(21), IU(21)
C     .. External Subroutines ..
      EXTERNAL XERMSG
C     .. Intrinsic Functions ..
      INTRINSIC ABS, INT
C***FIRST EXECUTABLE STATEMENT  DPSORT
      IER = 0
      NN = N
      IF (NN .LT. 1) THEN
         IER = 1
         CALL XERMSG ('SLATEC', 'DPSORT',
     +    'The number of values to be sorted, N, is not positive.',
     +    IER, 1)
         RETURN
      ENDIF
C
      KK = ABS(KFLAG)
      IF (KK.NE.1 .AND. KK.NE.2) THEN
         IER = 2
         CALL XERMSG ('SLATEC', 'DPSORT',
     +    'The sort control parameter, KFLAG, is not 2, 1, -1, or -2.',
     +    IER, 1)
         RETURN
      ENDIF
C
C     Initialize permutation vector
C
      DO 10 I=1,NN
         IPERM(I) = I
   10 CONTINUE
C
C     Return if only one value is to be sorted
C
      IF (NN .EQ. 1) RETURN
C
C     Alter array DX to get decreasing order if needed
C
      IF (KFLAG .LE. -1) THEN
         DO 20 I=1,NN
            DX(I) = -DX(I)
   20    CONTINUE
      ENDIF
C
C     Sort DX only
C
      M = 1
      I = 1
      J = NN
      R = .375D0
C
   30 IF (I .EQ. J) GO TO 80
      IF (R .LE. 0.5898437D0) THEN
         R = R+3.90625D-2
      ELSE
         R = R-0.21875D0
      ENDIF
C
   40 K = I
C
C     Select a central element of the array and save it in location L
C
      IJ = I + INT((J-I)*R)
      LM = IPERM(IJ)
C
C     If first element of array is greater than LM, interchange with LM
C
      IF (DX(IPERM(I)) .GT. DX(LM)) THEN
         IPERM(IJ) = IPERM(I)
         IPERM(I) = LM
         LM = IPERM(IJ)
      ENDIF
      L = J
C
C     If last element of array is less than LM, interchange with LM
C
      IF (DX(IPERM(J)) .LT. DX(LM)) THEN
         IPERM(IJ) = IPERM(J)
         IPERM(J) = LM
         LM = IPERM(IJ)
C
C        If first element of array is greater than LM, interchange
C        with LM
C
         IF (DX(IPERM(I)) .GT. DX(LM)) THEN
            IPERM(IJ) = IPERM(I)
            IPERM(I) = LM
            LM = IPERM(IJ)
         ENDIF
      ENDIF
      GO TO 60
   50 LMT = IPERM(L)
      IPERM(L) = IPERM(K)
      IPERM(K) = LMT
C
C     Find an element in the second half of the array which is smaller
C     than LM
C
   60 L = L-1
      IF (DX(IPERM(L)) .GT. DX(LM)) GO TO 60
C
C     Find an element in the first half of the array which is greater
C     than LM
C
   70 K = K+1
      IF (DX(IPERM(K)) .LT. DX(LM)) GO TO 70
C
C     Interchange these elements
C
      IF (K .LE. L) GO TO 50
C
C     Save upper and lower subscripts of the array yet to be sorted
C
      IF (L-I .GT. J-K) THEN
         IL(M) = I
         IU(M) = L
         I = K
         M = M+1
      ELSE
         IL(M) = K
         IU(M) = J
         J = L
         M = M+1
      ENDIF
      GO TO 90
C
C     Begin again on another portion of the unsorted array
C
   80 M = M-1
      IF (M .EQ. 0) GO TO 120
      I = IL(M)
      J = IU(M)
C
   90 IF (J-I .GE. 1) GO TO 40
      IF (I .EQ. 1) GO TO 30
      I = I-1
C
  100 I = I+1
      IF (I .EQ. J) GO TO 80
      LM = IPERM(I+1)
      IF (DX(IPERM(I)) .LE. DX(LM)) GO TO 100
      K = I
C
  110 IPERM(K+1) = IPERM(K)
      K = K-1
      IF (DX(LM) .LT. DX(IPERM(K))) GO TO 110
      IPERM(K+1) = LM
      GO TO 100
C
C     Clean up
C
  120 IF (KFLAG .LE. -1) THEN
         DO 130 I=1,NN
            DX(I) = -DX(I)
  130    CONTINUE
      ENDIF
C
C     Rearrange the values of DX if desired
C
      IF (KK .EQ. 2) THEN
C
C        Use the IPERM vector as a flag.
C        If IPERM(I) < 0, then the I-th value is in correct location
C
         DO 150 ISTRT=1,NN
            IF (IPERM(ISTRT) .GE. 0) THEN
               INDX = ISTRT
               INDX0 = INDX
               TEMP = DX(ISTRT)
  140          IF (IPERM(INDX) .GT. 0) THEN
                  DX(INDX) = DX(IPERM(INDX))
                  INDX0 = INDX
                  IPERM(INDX) = -IPERM(INDX)
                  INDX = ABS(IPERM(INDX))
                  GO TO 140
               ENDIF
               DX(INDX0) = TEMP
            ENDIF
  150    CONTINUE
C
C        Revert the signs of the IPERM values
C
         DO 160 I=1,NN
            IPERM(I) = -IPERM(I)
  160    CONTINUE
C
      ENDIF
C
      RETURN
      END
