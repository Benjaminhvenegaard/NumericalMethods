      SUBROUTINE SVECS (NCOMP, LNFC, YHP, WORK, IWORK, INHOMO, IFLAG)
C
      DIMENSION YHP(NCOMP,*),WORK(*),IWORK(*)
      COMMON /ML18JR/ AE,RE,TOL,NXPTS,NIC,NOPG,MXNON,NDISK,NTAPE,NEQ,
     1                INDPVT,INTEG,NPS,NTP,NEQIVP,NUMORT,LNFCC,
     2                ICOCO
C***FIRST EXECUTABLE STATEMENT  SVECS
      IF (LNFC .EQ. 1) GO TO 5
      NIV=LNFC
      LNFC=2*LNFC
      LNFCC=2*LNFCC
      KP=LNFC+2+LNFCC
      IDP=INDPVT
      INDPVT=0
      CALL MGSBV(NCOMP,LNFC,YHP,NCOMP,NIV,IFLAG,WORK(1),WORK(KP),
     1         IWORK(1),INHOMO,YHP(1,LNFC+1),WORK(LNFC+2),DUM)
      LNFC=LNFC/2
      LNFCC=LNFCC/2
      INDPVT=IDP
      IF (IFLAG .EQ. 0  .AND.  NIV .EQ. LNFC) GO TO 5
      IFLAG=99
      RETURN
    5 DO 6 K=1,NCOMP
    6 YHP(K,LNFC+1)=YHP(K,LNFCC+1)
      IFLAG=1
      RETURN
      END
