DECLARE SUB SPLINE (X!(), Y!(), N!, YP1!, YPN!, Y2!())
DECLARE SUB SPLINT (XA!(), YA!(), Y2A!(), N!, X!, Y!)

SUB SPLIN2 (X1A(), X2A(), YA(), Y2A(), M, N, X1, X2, Y)
DIM YTMP(N), Y2TMP(N), YYTMP(N)
FOR J = 1 TO M
  FOR K = 1 TO N
    YTMP(K) = YA(J, K)
    Y2TMP(K) = Y2A(J, K)
  NEXT K
  CALL SPLINT(X2A(), YTMP(), Y2TMP(), N, X2, YYTMP(J))
NEXT J
CALL SPLINE(X1A(), YYTMP(), M, 1E+30, 1E+30, Y2TMP())
CALL SPLINT(X1A(), YYTMP(), Y2TMP(), M, X1, Y)
ERASE YYTMP, Y2TMP, YTMP
END SUB

