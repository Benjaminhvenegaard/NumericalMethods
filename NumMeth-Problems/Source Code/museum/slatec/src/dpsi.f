      DOUBLE PRECISION FUNCTION DPSI (X)
      DOUBLE PRECISION X, PSICS(42), APSICS(16), AUX, DXREL, PI, XBIG,
     1  Y, DCOT, DCSEVL, D1MACH
      LOGICAL FIRST
      EXTERNAL DCOT
      SAVE PSICS, APSICS, PI, NTPSI, NTAPSI, XBIG, DXREL, FIRST
      DATA PSICS(  1) / -.3805708083 5217921520 4376776670 39 D-1     /
      DATA PSICS(  2) / +.4914153930 2938712748 2046996542 77 D+0     /
      DATA PSICS(  3) / -.5681574782 1244730242 8920647340 81 D-1     /
      DATA PSICS(  4) / +.8357821225 9143131362 7756507478 62 D-2     /
      DATA PSICS(  5) / -.1333232857 9943425998 0792741723 93 D-2     /
      DATA PSICS(  6) / +.2203132870 6930824892 8723979795 21 D-3     /
      DATA PSICS(  7) / -.3704023817 8456883592 8890869492 29 D-4     /
      DATA PSICS(  8) / +.6283793654 8549898933 6514187176 90 D-5     /
      DATA PSICS(  9) / -.1071263908 5061849855 2835417470 74 D-5     /
      DATA PSICS( 10) / +.1831283946 5484165805 7315898103 78 D-6     /
      DATA PSICS( 11) / -.3135350936 1808509869 0057797968 85 D-7     /
      DATA PSICS( 12) / +.5372808776 2007766260 4719191436 15 D-8     /
      DATA PSICS( 13) / -.9211681415 9784275717 8806326247 30 D-9     /
      DATA PSICS( 14) / +.1579812652 1481822782 2528840328 23 D-9     /
      DATA PSICS( 15) / -.2709864613 2380443065 4405894097 07 D-10    /
      DATA PSICS( 16) / +.4648722859 9096834872 9473195295 49 D-11    /
      DATA PSICS( 17) / -.7975272563 8303689726 5047977727 37 D-12    /
      DATA PSICS( 18) / +.1368272385 7476992249 2510538928 38 D-12    /
      DATA PSICS( 19) / -.2347515606 0658972717 3206779807 19 D-13    /
      DATA PSICS( 20) / +.4027630715 5603541107 9079250062 81 D-14    /
      DATA PSICS( 21) / -.6910251853 1179037846 5474229747 71 D-15    /
      DATA PSICS( 22) / +.1185604713 8863349552 9291395257 68 D-15    /
      DATA PSICS( 23) / -.2034168961 6261559308 1542104842 23 D-16    /
      DATA PSICS( 24) / +.3490074968 6463043850 3742329323 51 D-17    /
      DATA PSICS( 25) / -.5988014693 4976711003 0110813934 93 D-18    /
      DATA PSICS( 26) / +.1027380162 8080588258 3980057122 13 D-18    /
      DATA PSICS( 27) / -.1762704942 4561071368 3592601053 86 D-19    /
      DATA PSICS( 28) / +.3024322801 8156920457 4540354901 33 D-20    /
      DATA PSICS( 29) / -.5188916830 2092313774 2860888746 66 D-21    /
      DATA PSICS( 30) / +.8902773034 5845713905 0058874879 99 D-22    /
      DATA PSICS( 31) / -.1527474289 9426728392 8949719040 00 D-22    /
      DATA PSICS( 32) / +.2620731479 8962083136 3583180799 99 D-23    /
      DATA PSICS( 33) / -.4496464273 8220696772 5983880533 33 D-24    /
      DATA PSICS( 34) / +.7714712959 6345107028 9193642666 66 D-25    /
      DATA PSICS( 35) / -.1323635476 1887702968 1026389333 33 D-25    /
      DATA PSICS( 36) / +.2270999436 2408300091 2773119999 99 D-26    /
      DATA PSICS( 37) / -.3896419021 5374115954 4913919999 99 D-27    /
      DATA PSICS( 38) / +.6685198138 8855302310 6798933333 33 D-28    /
      DATA PSICS( 39) / -.1146998665 4920864872 5299199999 99 D-28    /
      DATA PSICS( 40) / +.1967938588 6541405920 5154133333 33 D-29    /
      DATA PSICS( 41) / -.3376448818 9750979801 9072000000 00 D-30    /
      DATA PSICS( 42) / +.5793070319 3214159246 6773333333 33 D-31    /
      DATA APSICS(  1) / -.8327107910 6929076017 4456932269 D-3        /
      DATA APSICS(  2) / -.4162518421 9273935282 1627121990 D-3        /
      DATA APSICS(  3) / +.1034315609 7874129117 4463193961 D-6        /
      DATA APSICS(  4) / -.1214681841 3590415298 7299556365 D-9        /
      DATA APSICS(  5) / +.3113694319 9835615552 1240278178 D-12       /
      DATA APSICS(  6) / -.1364613371 9317704177 6516100945 D-14       /
      DATA APSICS(  7) / +.9020517513 1541656513 0837974000 D-17       /
      DATA APSICS(  8) / -.8315429974 2159146482 9933635466 D-19       /
      DATA APSICS(  9) / +.1012242570 7390725418 8479482666 D-20       /
      DATA APSICS( 10) / -.1562702494 3562250762 0478933333 D-22       /
      DATA APSICS( 11) / +.2965427168 0890389613 3226666666 D-24       /
      DATA APSICS( 12) / -.6746868867 6570216374 1866666666 D-26       /
      DATA APSICS( 13) / +.1803453116 9718990421 3333333333 D-27       /
      DATA APSICS( 14) / -.5569016182 4598360746 6666666666 D-29       /
      DATA APSICS( 15) / +.1958679226 0773625173 3333333333 D-30       /
      DATA APSICS( 16) / -.7751958925 2333568000 0000000000 D-32       /
      DATA PI / 3.1415926535 8979323846 2643383279 50 D0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DPSI
      IF (FIRST) THEN
         NTPSI = INITDS (PSICS, 42, 0.1*REAL(D1MACH(3)) )
         NTAPSI = INITDS (APSICS, 16, 0.1*REAL(D1MACH(3)) )
C
         XBIG = 1.0D0/SQRT(D1MACH(3))
         DXREL = SQRT(D1MACH(4))
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
C
      IF (Y.GT.10.0D0) GO TO 50
C
C DPSI(X) FOR ABS(X) .LE. 2
C
      N = X
      IF (X.LT.0.D0) N = N - 1
      Y = X - N
      N = N - 1
      DPSI = DCSEVL (2.D0*Y-1.D0, PSICS, NTPSI)
      IF (N.EQ.0) RETURN
C
      IF (N.GT.0) GO TO 30
C
      N = -N
      IF (X .EQ. 0.D0) CALL XERMSG ('SLATEC', 'DPSI', 'X IS 0', 2, 2)
      IF (X .LT. 0.D0 .AND. X+N-2 .EQ. 0.D0) CALL XERMSG ('SLATEC',
     +   'DPSI', 'X IS A NEGATIVE INTEGER', 3, 2)
      IF (X .LT. (-0.5D0) .AND. ABS((X-AINT(X-0.5D0))/X) .LT. DXREL)
     +   CALL XERMSG ('SLATEC', 'DPSI',
     +   'ANSWER LT HALF PRECISION BECAUSE X TOO NEAR NEGATIVE INTEGER',
     +   1, 1)
C
      DO 20 I=1,N
        DPSI = DPSI - 1.D0/(X+I-1)
 20   CONTINUE
      RETURN
C
C DPSI(X) FOR X .GE. 2.0 AND X .LE. 10.0
C
 30   DO 40 I=1,N
        DPSI = DPSI + 1.0D0/(Y+I)
 40   CONTINUE
      RETURN
C
C DPSI(X) FOR ABS(X) .GT. 10.0
C
 50   AUX = 0.D0
      IF (Y.LT.XBIG) AUX = DCSEVL (2.D0*(10.D0/Y)**2-1.D0, APSICS,
     1  NTAPSI)
C
      IF (X.LT.0.D0) DPSI = LOG(ABS(X)) - 0.5D0/X + AUX
     1  - PI*DCOT(PI*X)
      IF (X.GT.0.D0) DPSI = LOG(X) - 0.5D0/X + AUX
      RETURN
C
      END