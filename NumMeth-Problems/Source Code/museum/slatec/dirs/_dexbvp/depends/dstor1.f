      SUBROUTINE DSTOR1 (U, YH, V, YP, NTEMP, NDISK, NTAPE)
      INTEGER IGOFX, INHOMO, IVP, J, NCOMP, NCTNF, NDISK, NFC, NTAPE,
     1     NTEMP
      DOUBLE PRECISION C, U(*), V(*), XSAV, YH(*), YP(*)
C
C     ******************************************************************
C
      COMMON /DML8SZ/ C,XSAV,IGOFX,INHOMO,IVP,NCOMP,NFC
C
C      *****************************************************************
C
C     BEGIN BLOCK PERMITTING ...EXITS TO 80
C***FIRST EXECUTABLE STATEMENT  DSTOR1
         NCTNF = NCOMP*NFC
         DO 10 J = 1, NCTNF
            U(J) = YH(J)
   10    CONTINUE
         IF (INHOMO .EQ. 1) GO TO 30
C
C           ZERO PARTICULAR SOLUTION
C
C     ......EXIT
            IF (NTEMP .EQ. 1) GO TO 80
            DO 20 J = 1, NCOMP
               V(J) = 0.0D0
   20       CONTINUE
         GO TO 70
   30    CONTINUE
C
C           NONZERO PARTICULAR SOLUTION
C
            IF (NTEMP .EQ. 0) GO TO 50
C
               DO 40 J = 1, NCOMP
                  V(J) = YP(J)
   40          CONTINUE
C     .........EXIT
               GO TO 80
   50       CONTINUE
C
            DO 60 J = 1, NCOMP
               V(J) = C*YP(J)
   60       CONTINUE
   70    CONTINUE
C
C        IS OUTPUT INFORMATION TO BE WRITTEN TO DISK
C
         IF (NDISK .EQ. 1)
     1      WRITE (NTAPE) (V(J), J = 1, NCOMP),(U(J), J = 1, NCTNF)
   80 CONTINUE
C
      RETURN
      END
