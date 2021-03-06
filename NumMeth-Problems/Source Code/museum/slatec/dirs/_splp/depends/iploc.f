      INTEGER FUNCTION IPLOC (LOC, SX, IX)
      REAL SX(*)
      INTEGER IX(*)
C***FIRST EXECUTABLE STATEMENT  IPLOC
      IF (LOC.LE.0) THEN
         CALL XERMSG ('SLATEC', 'IPLOC',
     +     'A value of LOC, the first argument, .LE. 0 was encountered',
     +     55, 1)
         IPLOC = 0
         RETURN
      ENDIF
C
C     Two cases exist:  (1.LE.LOC.LE.K) .OR. (LOC.GT.K).
C
      K = IX(3) + 4
      LMX = IX(1)
      LMXM1 = LMX - 1
      IF (LOC.LE.K) THEN
         IPLOC = LOC
         RETURN
      ENDIF
C
C     Compute length of the page, starting address of the page, page
C     number and relative working address.
C
      LPG = LMX-K
      ITEMP = LOC - K - 1
      IPAGE = ITEMP/LPG + 1
      IPLOC = MOD(ITEMP,LPG) + K + 1
      NP = ABS(IX(LMXM1))
C
C     Determine if a page fault has occurred.  If so, write page NP
C     and read page IPAGE.  Write the page only if it has been
C     modified.
C
      IF (IPAGE.NE.NP) THEN
         IF (SX(LMX).EQ.1.0) THEN
            SX(LMX) = 0.0
            KEY = 2
            CALL PRWPGE (KEY, NP, LPG, SX, IX)
         ENDIF
         KEY = 1
         CALL PRWPGE (KEY, IPAGE, LPG, SX, IX)
      ENDIF
      RETURN
      END
