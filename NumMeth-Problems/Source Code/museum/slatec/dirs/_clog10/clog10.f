      COMPLEX FUNCTION CLOG10 (Z)
      COMPLEX Z
      SAVE ALOGE
      DATA ALOGE / 0.4342944819 0325182765E0 /
C***FIRST EXECUTABLE STATEMENT  CLOG10
      CLOG10 = ALOGE * LOG(Z)
C
      RETURN
      END
