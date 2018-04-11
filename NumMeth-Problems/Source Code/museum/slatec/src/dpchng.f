      SUBROUTINE DPCHNG (II, XVAL, IPLACE, SX, IX, IRCX)
      DIMENSION IX(*)
      INTEGER IDLOC
      DOUBLE PRECISION SX(*),XVAL,ZERO,ONE,SXLAST,SXVAL
      SAVE ZERO, ONE
      DATA ZERO,ONE /0.D0,1.D0/
C***FIRST EXECUTABLE STATEMENT  DPCHNG
      IOPT=1
C
C     DETERMINE NULL-CASES..
      IF(II.EQ.0) RETURN
C
C     CHECK VALIDITY OF ROW/COL. INDEX.
C
      IF (.NOT.(IRCX.EQ.0)) GO TO 20002
      NERR=55
      CALL XERMSG ('SLATEC', 'DPCHNG', 'IRCX=0', NERR, IOPT)
20002 LMX = IX(1)
C
C     LMX IS THE LENGTH OF THE IN-MEMORY STORAGE AREA.
C
      IF (.NOT.(IRCX.LT.0)) GO TO 20005
C
C     CHECK SUBSCRIPTS OF THE ROW. THE ROW NUMBER MUST BE .LE. M AND
C     THE INDEX MUST BE .LE. N.
C
      IF (.NOT.(IX(2).LT.-IRCX .OR. IX(3).LT.ABS(II))) GO TO 20008
      NERR=55
      CALL XERMSG ('SLATEC', 'DPCHNG',
     +   'SUBSCRIPTS FOR ARRAY ELEMENT TO BE ACCESSED WERE OUT OF ' //
     +   'BOUNDS', NERR, IOPT)
20008 GO TO 20006
C
C     CHECK SUBSCRIPTS OF THE COLUMN. THE COL. NUMBER MUST BE .LE. N AND
C     THE INDEX MUST BE .LE. M.
C
20005 IF (.NOT.(IX(3).LT.IRCX .OR. IX(2).LT.ABS(II))) GO TO 20011
      NERR=55
      CALL XERMSG ('SLATEC', 'DPCHNG',
     +   'SUBSCRIPTS FOR ARRAY ELEMENT TO BE ACCESSED WERE OUT OF ' //
     +   'BOUNDS', NERR, IOPT)
20011 CONTINUE
C
C     SET I TO BE THE ELEMENT OF ROW/COLUMN J TO BE CHANGED.
C
20006 IF (.NOT.(IRCX.GT.0)) GO TO 20014
      I = ABS(II)
      J = ABS(IRCX)
      GO TO 20015
20014 I = ABS(IRCX)
      J = ABS(II)
C
C     THE INTEGER LL POINTS TO THE START OF THE MATRIX ELEMENT DATA.
C
20015 LL=IX(3)+4
      II = ABS(II)
      LPG = LMX - LL
C
C     SET IPLACE TO START OUR SCAN FOR THE ELEMENT AT THE BEGINNING
C     OF THE VECTOR.
C
      IF (.NOT.(J.EQ.1)) GO TO 20017
      IPLACE=LL+1
      GO TO 20018
20017 IPLACE=IX(J+3)+1
C
C     IEND POINTS TO THE LAST ELEMENT OF THE VECTOR TO BE SCANNED.
C
20018 IEND = IX(J+4)
C
C     SCAN THROUGH SEVERAL PAGES, IF NECESSARY, TO FIND MATRIX ELEMENT.
C
      IPL = IDLOC(IPLACE,SX,IX)
      NP = ABS(IX(LMX-1))
      GO TO 20021
20020 IF (ILAST.EQ.IEND) GO TO 20022
C
C     THE VIRTUAL END OF DATA FOR THIS PAGE IS ILAST.
C
20021 ILAST = MIN(IEND,NP*LPG+LL-2)
C
C     THE RELATIVE END OF DATA FOR THIS PAGE IS IL.
C     SEARCH FOR A MATRIX VALUE WITH AN INDEX .GE. I ON THE PRESENT
C     PAGE.
C
      IL = IDLOC(ILAST,SX,IX)
      IL = MIN(IL,LMX-2)
20023 IF (.NOT.(.NOT.(IPL.GE.IL .OR. IX(IPL).GE.I))) GO TO 20024
      IPL=IPL+1
      GO TO 20023
C
C     SET IPLACE AND STORE DATA ITEM IF FOUND.
C
20024 IF (.NOT.(IX(IPL).EQ.I .AND. IPL.LE.IL)) GO TO 20025
      SX(IPL) = XVAL
      SX(LMX) = ONE
      RETURN
C
C     EXIT FROM LOOP IF ITEM WAS FOUND.
C
20025 IF(IX(IPL).GT.I .AND. IPL.LE.IL) ILAST = IEND
      IF (.NOT.(ILAST.NE.IEND)) GO TO 20028
      IPL = LL + 1
      NP = NP + 1
20028 GO TO 20020
C
C     INSERT NEW DATA ITEM INTO LOCATION AT IPLACE(IPL).
C
20022 IF (.NOT.(IPL.GT.IL.OR.(IPL.EQ.IL.AND.I.GT.IX(IPL)))) GO TO 20031
      IPL = IL + 1
      IF(IPL.EQ.LMX-1) IPL = IPL + 2
20031 IPLACE = (NP-1)*LPG + IPL
C
C     GO TO A NEW PAGE, IF NECESSARY, TO INSERT THE ITEM.
C
      IF (.NOT.(IPL.LE.LMX .OR. IX(LMX-1).GE.0)) GO TO 20034
      IPL=IDLOC(IPLACE,SX,IX)
20034 IEND = IX(LL)
      NP = ABS(IX(LMX-1))
      SXVAL = XVAL
C
C     LOOP THROUGH ALL SUBSEQUENT PAGES OF THE MATRIX MOVING DATA DOWN.
C     THIS IS NECESSARY TO MAKE ROOM FOR THE NEW MATRIX ELEMENT AND
C     KEEP THE ENTRIES SORTED.
C
      GO TO 20038
20037 IF (IX(LMX-1).LE.0) GO TO 20039
20038 ILAST = MIN(IEND,NP*LPG+LL-2)
      IL = IDLOC(ILAST,SX,IX)
      IL = MIN(IL,LMX-2)
      SXLAST = SX(IL)
      IXLAST = IX(IL)
      ISTART = IPL + 1
      IF (.NOT.(ISTART.LE.IL)) GO TO 20040
      K = ISTART + IL
      DO 50 JJ=ISTART,IL
      SX(K-JJ) = SX(K-JJ-1)
      IX(K-JJ) = IX(K-JJ-1)
50    CONTINUE
      SX(LMX) = ONE
20040 IF (.NOT.(IPL.LE.LMX)) GO TO 20043
      SX(IPL) = SXVAL
      IX(IPL) = I
      SXVAL = SXLAST
      I = IXLAST
      SX(LMX) = ONE
      IF (.NOT.(IX(LMX-1).GT.0)) GO TO 20046
      IPL = LL + 1
      NP = NP + 1
20046 CONTINUE
20043 GO TO 20037
20039 NP = ABS(IX(LMX-1))
C
C     DETERMINE IF A NEW PAGE IS TO BE CREATED FOR THE LAST ELEMENT
C     MOVED DOWN.
C
      IL = IL + 1
      IF (.NOT.(IL.EQ.LMX-1)) GO TO 20049
C
C     CREATE A NEW PAGE.
C
      IX(LMX-1) = NP
C
C     WRITE THE OLD PAGE.
C
      SX(LMX) = ZERO
      KEY = 2
      CALL DPRWPG(KEY,NP,LPG,SX,IX)
      SX(LMX) = ONE
C
C     STORE LAST ELEMENT MOVED DOWN IN A NEW PAGE.
C
      IPL = LL + 1
      NP = NP + 1
      IX(LMX-1) = -NP
      SX(IPL) = SXVAL
      IX(IPL) = I
      GO TO 20050
C
C     LAST ELEMENT MOVED REMAINED ON THE OLD PAGE.
C
20049 IF (.NOT.(IPL.NE.IL)) GO TO 20052
      SX(IL) = SXVAL
      IX(IL) = I
      SX(LMX) = ONE
20052 CONTINUE
C
C     INCREMENT POINTERS TO LAST ELEMENT IN VECTORS J,J+1,... .
C
20050 JSTART = J + 4
      JJ=JSTART
      N20055=LL
      GO TO 20056
20055 JJ=JJ+1
20056 IF ((N20055-JJ).LT.0) GO TO 20057
      IX(JJ) = IX(JJ) + 1
      IF(MOD(IX(JJ)-LL,LPG).EQ.LPG-1) IX(JJ) = IX(JJ) + 2
      GO TO 20055
C
C     IPLACE POINTS TO THE INSERTED DATA ITEM.
C
20057 IPL=IDLOC(IPLACE,SX,IX)
      RETURN
      END
