      COMPLEX FUNCTION CTANH (Z)
      COMPLEX Z, CI, CTAN
      SAVE CI
      DATA CI /(0.,1.)/
C***FIRST EXECUTABLE STATEMENT  CTANH
      CTANH = -CI*CTAN(CI*Z)
C
      RETURN
      END
