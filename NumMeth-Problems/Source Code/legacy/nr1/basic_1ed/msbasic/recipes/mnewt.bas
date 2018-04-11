DECLARE SUB USRFUN (X!(), ALPHA!(), BETA!())
DECLARE SUB LUDCMP (A!(), N!, NP!, INDX!(), D!)
DECLARE SUB LUBKSB (A!(), N!, NP!, INDX!(), B!())

SUB MNEWT (NTRIAL, X(), N, TOLX, TOLF)
DIM ALPHA(N, N), BETA(N), INDX(N)
FOR K = 1 TO NTRIAL
  CALL USRFUN(X(), ALPHA(), BETA())
  ERRF = 0!
  FOR I = 1 TO N
    ERRF = ERRF + ABS(BETA(I))
  NEXT I
  IF ERRF <= TOLF THEN EXIT FOR
  CALL LUDCMP(ALPHA(), N, N, INDX(), D)
  CALL LUBKSB(ALPHA(), N, N, INDX(), BETA())
  ERRX = 0!
  FOR I = 1 TO N
    ERRX = ERRX + ABS(BETA(I))
    X(I) = X(I) + BETA(I)
  NEXT I
  IF ERRX <= TOLX THEN EXIT FOR
NEXT K
ERASE INDX, BETA, ALPHA
END SUB
