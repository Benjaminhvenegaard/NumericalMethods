      FUNCTION ALI (X)
C***FIRST EXECUTABLE STATEMENT  ALI
      IF (X .LE. 0.0) CALL XERMSG ('SLATEC', 'ALI',
     +   'LOG INTEGRAL UNDEFINED FOR X LE 0', 1, 2)
      IF (X .EQ. 1.0) CALL XERMSG ('SLATEC', 'ALI',
     +   'LOG INTEGRAL UNDEFINED FOR X = 1', 2, 2)
C
      ALI = EI (LOG(X) )
C
      RETURN
      END