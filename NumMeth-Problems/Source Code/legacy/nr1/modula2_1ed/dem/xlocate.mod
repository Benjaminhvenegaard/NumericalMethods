MODULE XLocate; (* driver for routine Locate *) 
 
   FROM Search   IMPORT Locate;
   FROM NRMath   IMPORT Exp;
   FROM NRSystem IMPORT Float;
   FROM NRIO     IMPORT ReadLn, WriteLn, WriteInt, WriteReal, WriteString, 
                        Error;
   FROM NRVect   IMPORT Vector, DisposeVector, PtrToReals, CreateVector,  
                        NilVector, VectorPtr;

   CONST 
      n = 100; 
   VAR 
      i, j: INTEGER; 
      x: REAL; 
      XX: Vector; 
      xx: PtrToReals; 
       
BEGIN 
(* create array to be searched *) 
   CreateVector(n, XX, xx);
   IF (XX # NilVector) THEN
	   FOR i := 0 TO n-1 DO 
	      xx^[i] := Exp(Float(i+1)/20.0)-74.0
	   END; 
	   WriteString('result of:  j := 0 indicates x too small'); WriteLn; 
	   WriteString('            '); 
	   WriteString('j := 100 indicates x too large'); WriteLn; WriteLn; 
	   WriteString('   locate '); 
	   WriteString('     j'); 
	   WriteString('      xx(j)'); 
	   WriteString('     xx(j+1)'); 
	   WriteLn; (* do test *) 
	   FOR i := 0 TO 18 DO 
	      x := -100.0+200.0*Float(i+1)/20.0; 
	      Locate(XX, x, j); 
	      IF (j < n-1) AND (j >= 0) THEN 
	         WriteReal(x, 10, 4); 
	         WriteInt(j+1, 6); 
	         WriteReal(xx^[j], 12, 6); 
	         WriteReal(xx^[j+1], 12, 6); 
	         WriteLn
	      ELSIF j = n-1 THEN 
	         WriteReal(x, 10, 4); 
	         WriteInt(j+1, 6); 
	         WriteReal(xx^[j], 12, 6); 
	         WriteString('   upper lim'); 
	         WriteLn
	      ELSE 
	         WriteReal(x, 10, 4); 
	         WriteInt(j+1, 6); 
	         WriteString('   lower lim'); 
	         WriteReal(xx^[j+1], 12, 6); 
	         WriteLn
	      END
	   END;
	   ReadLn;
	ELSE
	   Error('XLocate', 'Not enough memory!');
	END;
	IF (XX # NilVector) THEN DisposeVector(XX) END;
END XLocate.
