      SUBROUTINE ZDIV (AR, AI, BR, BI, CR, CI)
      DOUBLE PRECISION AR, AI, BR, BI, CR, CI, BM, CA, CB, CC, CD
      DOUBLE PRECISION ZABS
      EXTERNAL ZABS
C***FIRST EXECUTABLE STATEMENT  ZDIV
      BM = 1.0D0/ZABS(BR,BI)
      CC = BR*BM
      CD = BI*BM
      CA = (AR*CC+AI*CD)*BM
      CB = (AI*CC-AR*CD)*BM
      CR = CA
      CI = CB
      RETURN
      END
