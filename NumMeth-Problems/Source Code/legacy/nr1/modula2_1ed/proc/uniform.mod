IMPLEMENTATION MODULE Uniform;

   FROM NRMath   IMPORT MODD, DIVD, Random;
   FROM NRSystem IMPORT LongInt, D, SI, DI, Float, FloatDS, Trunc, TruncSD;
   FROM NRIO     IMPORT Error;

   CONST
      Max1 = 97;
      Max2 = 55;
      M1  =    1771875;                        (* constants for Ran1 *)
      IA1 =      2416;
      IC1 =     374441;
      RM1 = 5.64E-7; (* 1/M1. *)
      M2  =    134456;
      IA2 =      8121;
      IC2 =     28411;
      RM2 = 7.4373773E-6; (* 1/M2. *)
      M3  =    243000;
      IA3 =      4561;
      IC3 =     51349;
      M  =    714025;             (* constants for Ran2 *)
      IA =      1366;
      IC =    150889;
      RM = 1.4005112E-6; (* 1/M. *)
      MBig  =       4.0E6;          (* constants for Ran3 *)(* According to Knuth, any large MBig, and any smaller (but
                                                              still large) MSeed can be substituted for these values. *)
      MSeed = 1618033.0;
      MZ    =       0.0;
      Fac   =       2.5E-7; (* 1/MBig. *)

   VAR
      Ran0Y:   REAL;                      (* globals for Ran0 *)
      Ran0V:   ARRAY [1..Max1] OF REAL;
	   (*
	     The exact array size 97 is
	     unimportant.
	   *)
	   Ran1Ix1, Ran1Ix2, Ran1Ix3: LongInt;(* See section1.2 for discussion of LongInt. *)
      Ran1R:   ARRAY [1..Max1] OF REAL;
	   Ran2Iy:  LongInt;                   (* globals for Ran2 *)(* See section 1.2 for discussion of LongInt. *)
      Ran2Ir:  ARRAY [1..Max1] OF REAL;
      Ran3Inext,                          (* globals for Ran3 *)
      Ran3Inextp: INTEGER;
      Ran3Ma:     ARRAY [1..Max2] OF REAL;
	   (*
	     The array size 55 is special and
	     should not be modified; see Knuth.
	   *)

      Init0, Init1, Init3: INTEGER;
      Init2: LongInt;

   PROCEDURE Ran0(VAR init: INTEGER): REAL; 
      VAR 
         dum: REAL;
         j:   INTEGER; 
   BEGIN 
      IF (init < 0) OR (Init0 = 0) THEN 
         Init0 := 1;
	      FOR j := 1 TO Max1 DO (* Exercise the system routine, especially
                                important if the system's multiplier is small. *)
	         dum:= Random();
	      END; 
	      FOR j := 1 TO Max1 DO (* Then save 97 values *)
	         Ran0V[j] := Random();
	      END; 
	      Ran0Y := Random(); (* and a 98^th. *)
         init := 1;
      END;
      j := 1+Trunc(Float(Max1)*Ran0Y); (* This is where we start if not initializing.
                                          The previously saved random number Ran0Y is used
                                          to get an index j between 1 and 97.  Then the 
                                          corresponding Ran0V[j] is used both for the next y
                                          and as the output number. *)
      IF (1 <= j) AND (j <= Max1 ) THEN 
	      Ran0Y := Ran0V[j]; 
	      Ran0V[j] := Random(); 
      ELSE
         Error('Ran0', 'Index overflow'); 
      END;
      RETURN Ran0Y;(* Finally, refill the table entry with
                      the next random number from tRandom. *)
   END Ran0;

   PROCEDURE DIVDLong(a, b: REAL): LongInt;
      (* Entier of a, b. a, b should be integer numbers *)
   BEGIN
      RETURN TruncSD(a/b);
   END DIVDLong;

   PROCEDURE MODDLong(a, b: REAL): LongInt;
      (* Rem of a/b *)
   BEGIN
      RETURN TruncSD(a - b * FloatDS(DIVDLong(a, b)));
   END MODDLong;

   PROCEDURE Ran1(VAR init: INTEGER): REAL;
      VAR
         j: INTEGER;
         ran1Result: REAL;
         work: REAL;
   BEGIN
      IF (init < 0) OR (Init1 = 0) THEN
	      Init1 := 1;
	      work := FloatDS(IC1)-Float(init);
	      Ran1Ix1 := MODDLong( work, FloatDS(M1) ); (* Seed the first routine, *)
	      Ran1Ix1 := MODDLong( FloatDS(IA1)*FloatDS(Ran1Ix1)+FloatDS(IC1), FloatDS(M1) );
	      Ran1Ix2 := MODDLong( FloatDS(Ran1Ix1), FloatDS(M2) ); (* and use it to seed the second *)
	      Ran1Ix1 := MODDLong( FloatDS(IA1)*FloatDS(Ran1Ix1)+FloatDS(IC1), FloatDS(M1) );
	      Ran1Ix3 := MODDLong( FloatDS(Ran1Ix1), FloatDS(M3) ); (* and third routines. *)
	      FOR j := 1 TO Max1 DO (* Fill the table with sequential uniform
                                deviates generated by the first two routines. *)
            work := FloatDS(IA1) * FloatDS(Ran1Ix1) + FloatDS(IC1);
	         Ran1Ix1 := MODDLong( work, FloatDS(M1) );
	         work := FloatDS(IA2) * FloatDS(Ran1Ix2) + FloatDS(IC2);
	         Ran1Ix2 := MODDLong( work, FloatDS(M2) );
	         Ran1R[j] := (FloatDS(Ran1Ix1)+FloatDS(Ran1Ix2)*RM2)*RM1  (* Combine low- and high-order pieces. *)
	      END;
	      init := 1;
	   END;
      Ran1Ix1 := MODDLong( FloatDS(IA1)*FloatDS(Ran1Ix1)+FloatDS(IC1), FloatDS(M1)); (* Except when initializing, this
                                                is where we start.  Generate the next number for each sequence. *)
      Ran1Ix2 := MODDLong( FloatDS(IA2)*FloatDS(Ran1Ix2)+FloatDS(IC2), FloatDS(M2));
      Ran1Ix3 := MODDLong( FloatDS(IA3)*FloatDS(Ran1Ix3)+FloatDS(IC3), FloatDS(M3));
      j := 1+SI(DIVD( DI(Max1)*Ran1Ix3, M3)); (* Use the third sequence to get an integer
                                                 between 1 and 97. *)
      IF (1 <= j) AND (j <= Max1 ) THEN
         ran1Result := Ran1R[j]; (* Return that table entry, *)
         Ran1R[j] := (FloatDS(Ran1Ix1)+FloatDS(Ran1Ix2)*RM2)*RM1; (* and refill it. *)
      ELSE
         Error('Ran1', 'Index overflow');
      END;
      RETURN ran1Result;
   END Ran1; 

   PROCEDURE Ran2(VAR init: LongInt): REAL; 
      VAR 
         j: INTEGER; 
         ran2Result: REAL; 
   BEGIN 
      IF (init < 0) OR (Init2 = 0) THEN
         Init2 := 1;
	      init := MODD( IC-init, M); 
	      FOR j := 1 TO Max1 DO 
	         init := MODD( IA*init+IC, M); 
			   (*
			     Initialize the shuffle table.
			   *)
	         Ran2Ir[j] := FloatDS(init);
	      END; 
	      init := MODD( IA*init+IC, M); 
	      Ran2Iy := init(* Compare to Ran0, above. *)
      END;
      j := 1+SI(DIVD(DI(Max1)*Ran2Iy, M)); (* Here is where we start except on initialization. *)
      IF (1 <= j) AND (j <= Max1 ) THEN 
	      Ran2Iy := TruncSD(Ran2Ir[j]); 
	      ran2Result := FloatDS(Ran2Iy)*RM; 
	      init := MODD( (IA*init+IC), M); 
	      Ran2Ir[j] := FloatDS(init); 
	   ELSE
         Error('Ran2', 'Index overflow'); 
      END; 
      RETURN ran2Result
   END Ran2; 

   PROCEDURE Ran3(VAR init: INTEGER): REAL; 
      VAR 
         i, ii, k: INTEGER; 
         mj, mk: REAL; 
   BEGIN 
      IF (init < 0) OR (Init3 = 0) THEN
	   (*
	     Initialization.
	   *)
         Init3 := 1;
	      mj := MSeed+Float(init); (* Initialize MA[55] using the seed
                                   init and the large number MSeed. *)
	      IF mj >= 0.0 THEN 
	         mj := mj-MBig*Float(Trunc(mj/MBig))
			   (*
			     The above IF statement is 
			     tmj := mj MOD mbig for real variables.
			     Replace  with the following commented statement for LongInt version.
			   *)
	      ELSE 
	         mj := MBig-ABS(mj)+MBig*Float(Trunc(ABS(mj)/MBig))
	      END; (*    mj := mj MOD MBig; *) 
	      Ran3Ma[Max2] := mj; 
	      mk := Float(1); 
	      FOR i := 1 TO Max2-1 DO (* Now initialize the rest of the table, *)
	         ii := 21*i MOD Max2; 
			   (*
			     in a slightly random order,
			   *)
	         Ran3Ma[ii] := mk; (* with numbers that are not especially
                               random. *)
	         mk := mj-mk; 
	         IF mk < MZ THEN 
	            mk := mk+MBig
	         END; 
	         mj := Ran3Ma[ii]
	      END; 
	      FOR k := 1 TO 4 DO (* We randomize them by ``warming up
                             the generator." *)
	         FOR i := 1 TO Max2 DO 
	            Ran3Ma[i] := Ran3Ma[i]-Ran3Ma[1+((i+30) MOD Max2)]; 
	            IF Ran3Ma[i] < MZ THEN 
	               Ran3Ma[i] := Ran3Ma[i]+MBig
	            END
	         END;
	      END; 
	      Ran3Inext := 0; (* Prepare indices for our first generated
                          number. *)
	      Ran3Inextp := 31; (* The constant 31 is special; see Knuth. *)
         init := 1;
      END;
      Ran3Inext := Ran3Inext+1; (* Here is where we start, except on
                                   initialization. Increment Ran3Inext,
                                   wrapping around 56 to 1. *)
      IF Ran3Inext = Max2+1 THEN 
         Ran3Inext := 1
      END; 
      Ran3Inextp := Ran3Inextp+1; (* Ditto for Ran3Inextp. *)
      IF Ran3Inextp = Max2+1 THEN 
         Ran3Inextp := 1
      END; 
      mj := Ran3Ma[Ran3Inext]-Ran3Ma[Ran3Inextp]; (* Create a new random number subtractively. *)
      IF mj < MZ THEN mj := mj+MBig END; (* Be sure that it is in range. *)
      Ran3Ma[Ran3Inext] := mj; (* Store it, *)
      RETURN mj*Fac; (* and output the derived uniform deviate. *)
   END Ran3; 

BEGIN
   Init0 := 0;
   Init1 := 0;
   Init2 := 0;
   Init3 := 0;
END Uniform.
