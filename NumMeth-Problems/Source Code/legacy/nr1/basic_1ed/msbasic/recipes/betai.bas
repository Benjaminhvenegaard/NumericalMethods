DECLARE FUNCTION BETAI! (A!, B!, X!)
DECLARE FUNCTION BETACF! (A!, B!, X!)
DECLARE FUNCTION GAMMLN! (X!)

FUNCTION BETAI (A, B, X)
IF X < 0! OR X > 1! THEN PRINT "bad argument X in BETAI": EXIT FUNCTION
IF X = 0! OR X = 1! THEN
  BT = 0!
ELSE
  BT = EXP(GAMMLN(A + B) - GAMMLN(A) - GAMMLN(B) + A * LOG(X) + B * LOG(1! - X))
END IF
IF X < (A + 1!) / (A + B + 2!) THEN
  BETAI = BT * BETACF(A, B, X) / A
ELSE
  BETAI = 1! - BT * BETACF(B, A, 1! - X) / B
END IF
END FUNCTION
