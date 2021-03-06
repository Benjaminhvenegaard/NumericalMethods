DECLARE FUNCTION GAMMQ! (A!, X!)

SUB CHSONE (BINS(), EBINS(), NBINS, KNSTRN, DF, CHSQ, PROB)
DF = NBINS - 1 - KNSTRN
CHSQ = 0!
FOR J = 1 TO NBINS
  IF EBINS(J) <= 0! THEN PRINT "bad expected number": EXIT SUB
  CHSQ = CHSQ + (BINS(J) - EBINS(J)) ^ 2 / EBINS(J)
NEXT J
PROB = GAMMQ(.5 * DF, .5 * CHSQ)
END SUB

