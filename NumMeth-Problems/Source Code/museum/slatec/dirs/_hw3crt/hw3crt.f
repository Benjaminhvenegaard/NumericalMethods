      SUBROUTINE HW3CRT (XS, XF, L, LBDCND, BDXS, BDXF, YS, YF, M,
     +   MBDCND, BDYS, BDYF, ZS, ZF, N, NBDCND, BDZS, BDZF, ELMBDA,
     +   LDIMF, MDIMF, F, PERTRB, IERROR, W)
C
C
      DIMENSION       BDXS(MDIMF,*)          ,BDXF(MDIMF,*)          ,
     1                BDYS(LDIMF,*)          ,BDYF(LDIMF,*)          ,
     2                BDZS(LDIMF,*)          ,BDZF(LDIMF,*)          ,
     3                F(LDIMF,MDIMF,*)       ,W(*)
C***FIRST EXECUTABLE STATEMENT  HW3CRT
      IERROR = 0
      IF (XF .LE. XS) IERROR = 1
      IF (L .LT. 5) IERROR = 2
      IF (LBDCND.LT.0 .OR. LBDCND.GT.4) IERROR = 3
      IF (YF .LE. YS) IERROR = 4
      IF (M .LT. 5) IERROR = 5
      IF (MBDCND.LT.0 .OR. MBDCND.GT.4) IERROR = 6
      IF (ZF .LE. ZS) IERROR = 7
      IF (N .LT. 5) IERROR = 8
      IF (NBDCND.LT.0 .OR. NBDCND.GT.4) IERROR = 9
      IF (LDIMF .LT. L+1) IERROR = 10
      IF (MDIMF .LT. M+1) IERROR = 11
      IF (IERROR .NE. 0) GO TO 188
      DY = (YF-YS)/M
      TWBYDY = 2./DY
      C2 = 1./(DY**2)
      MSTART = 1
      MSTOP = M
      MP1 = M+1
      MP = MBDCND+1
      GO TO (104,101,101,102,102),MP
  101 MSTART = 2
  102 GO TO (104,104,103,103,104),MP
  103 MSTOP = MP1
  104 MUNK = MSTOP-MSTART+1
      DZ = (ZF-ZS)/N
      TWBYDZ = 2./DZ
      NP = NBDCND+1
      C3 = 1./(DZ**2)
      NP1 = N+1
      NSTART = 1
      NSTOP = N
      GO TO (108,105,105,106,106),NP
  105 NSTART = 2
  106 GO TO (108,108,107,107,108),NP
  107 NSTOP = NP1
  108 NUNK = NSTOP-NSTART+1
      LP1 = L+1
      DX = (XF-XS)/L
      C1 = 1./(DX**2)
      TWBYDX = 2./DX
      LP = LBDCND+1
      LSTART = 1
      LSTOP = L
C
C     ENTER BOUNDARY DATA FOR X-BOUNDARIES.
C
      GO TO (122,109,109,112,112),LP
  109 LSTART = 2
      DO 111 J=MSTART,MSTOP
         DO 110 K=NSTART,NSTOP
            F(2,J,K) = F(2,J,K)-C1*F(1,J,K)
  110    CONTINUE
  111 CONTINUE
      GO TO 115
  112 DO 114 J=MSTART,MSTOP
         DO 113 K=NSTART,NSTOP
            F(1,J,K) = F(1,J,K)+TWBYDX*BDXS(J,K)
  113    CONTINUE
  114 CONTINUE
  115 GO TO (122,116,119,119,116),LP
  116 DO 118 J=MSTART,MSTOP
         DO 117 K=NSTART,NSTOP
            F(L,J,K) = F(L,J,K)-C1*F(LP1,J,K)
  117    CONTINUE
  118 CONTINUE
      GO TO 122
  119 LSTOP = LP1
      DO 121 J=MSTART,MSTOP
         DO 120 K=NSTART,NSTOP
            F(LP1,J,K) = F(LP1,J,K)-TWBYDX*BDXF(J,K)
  120    CONTINUE
  121 CONTINUE
  122 LUNK = LSTOP-LSTART+1
C
C     ENTER BOUNDARY DATA FOR Y-BOUNDARIES.
C
      GO TO (136,123,123,126,126),MP
  123 DO 125 I=LSTART,LSTOP
         DO 124 K=NSTART,NSTOP
            F(I,2,K) = F(I,2,K)-C2*F(I,1,K)
  124    CONTINUE
  125 CONTINUE
      GO TO 129
  126 DO 128 I=LSTART,LSTOP
         DO 127 K=NSTART,NSTOP
            F(I,1,K) = F(I,1,K)+TWBYDY*BDYS(I,K)
  127    CONTINUE
  128 CONTINUE
  129 GO TO (136,130,133,133,130),MP
  130 DO 132 I=LSTART,LSTOP
         DO 131 K=NSTART,NSTOP
            F(I,M,K) = F(I,M,K)-C2*F(I,MP1,K)
  131    CONTINUE
  132 CONTINUE
      GO TO 136
  133 DO 135 I=LSTART,LSTOP
         DO 134 K=NSTART,NSTOP
            F(I,MP1,K) = F(I,MP1,K)-TWBYDY*BDYF(I,K)
  134    CONTINUE
  135 CONTINUE
  136 CONTINUE
C
C     ENTER BOUNDARY DATA FOR Z-BOUNDARIES.
C
      GO TO (150,137,137,140,140),NP
  137 DO 139 I=LSTART,LSTOP
         DO 138 J=MSTART,MSTOP
            F(I,J,2) = F(I,J,2)-C3*F(I,J,1)
  138    CONTINUE
  139 CONTINUE
      GO TO 143
  140 DO 142 I=LSTART,LSTOP
         DO 141 J=MSTART,MSTOP
            F(I,J,1) = F(I,J,1)+TWBYDZ*BDZS(I,J)
  141    CONTINUE
  142 CONTINUE
  143 GO TO (150,144,147,147,144),NP
  144 DO 146 I=LSTART,LSTOP
         DO 145 J=MSTART,MSTOP
            F(I,J,N) = F(I,J,N)-C3*F(I,J,NP1)
  145    CONTINUE
  146 CONTINUE
      GO TO 150
  147 DO 149 I=LSTART,LSTOP
         DO 148 J=MSTART,MSTOP
            F(I,J,NP1) = F(I,J,NP1)-TWBYDZ*BDZF(I,J)
  148    CONTINUE
  149 CONTINUE
C
C     DEFINE A,B,C COEFFICIENTS IN W-ARRAY.
C
  150 CONTINUE
      IWB = NUNK+1
      IWC = IWB+NUNK
      IWW = IWC+NUNK
      DO 151 K=1,NUNK
         I = IWC+K-1
         W(K) = C3
         W(I) = C3
         I = IWB+K-1
         W(I) = -2.*C3+ELMBDA
  151 CONTINUE
      GO TO (155,155,153,152,152),NP
  152 W(IWC) = 2.*C3
  153 GO TO (155,155,154,154,155),NP
  154 W(IWB-1) = 2.*C3
  155 CONTINUE
      PERTRB = 0.
C
C     FOR SINGULAR PROBLEMS ADJUST DATA TO INSURE A SOLUTION WILL EXIST.
C
      GO TO (156,172,172,156,172),LP
  156 GO TO (157,172,172,157,172),MP
  157 GO TO (158,172,172,158,172),NP
  158 IF (ELMBDA) 172,160,159
  159 IERROR = 12
      GO TO 172
  160 CONTINUE
      MSTPM1 = MSTOP-1
      LSTPM1 = LSTOP-1
      NSTPM1 = NSTOP-1
      XLP = (2+LP)/3
      YLP = (2+MP)/3
      ZLP = (2+NP)/3
      S1 = 0.
      DO 164 K=2,NSTPM1
         DO 162 J=2,MSTPM1
            DO 161 I=2,LSTPM1
               S1 = S1+F(I,J,K)
  161       CONTINUE
            S1 = S1+(F(1,J,K)+F(LSTOP,J,K))/XLP
  162    CONTINUE
         S2 = 0.
         DO 163 I=2,LSTPM1
            S2 = S2+F(I,1,K)+F(I,MSTOP,K)
  163    CONTINUE
         S2 = (S2+(F(1,1,K)+F(1,MSTOP,K)+F(LSTOP,1,K)+F(LSTOP,MSTOP,K))/
     1                                                          XLP)/YLP
         S1 = S1+S2
  164 CONTINUE
      S = (F(1,1,1)+F(LSTOP,1,1)+F(1,1,NSTOP)+F(LSTOP,1,NSTOP)+
     1    F(1,MSTOP,1)+F(LSTOP,MSTOP,1)+F(1,MSTOP,NSTOP)+
     2                                   F(LSTOP,MSTOP,NSTOP))/(XLP*YLP)
      DO 166 J=2,MSTPM1
         DO 165 I=2,LSTPM1
            S = S+F(I,J,1)+F(I,J,NSTOP)
  165    CONTINUE
  166 CONTINUE
      S2 = 0.
      DO 167 I=2,LSTPM1
         S2 = S2+F(I,1,1)+F(I,1,NSTOP)+F(I,MSTOP,1)+F(I,MSTOP,NSTOP)
  167 CONTINUE
      S = S2/YLP+S
      S2 = 0.
      DO 168 J=2,MSTPM1
         S2 = S2+F(1,J,1)+F(1,J,NSTOP)+F(LSTOP,J,1)+F(LSTOP,J,NSTOP)
  168 CONTINUE
      S = S2/XLP+S
      PERTRB = (S/ZLP+S1)/((LUNK+1.-XLP)*(MUNK+1.-YLP)*
     1                                              (NUNK+1.-ZLP))
      DO 171 I=1,LUNK
         DO 170 J=1,MUNK
            DO 169 K=1,NUNK
               F(I,J,K) = F(I,J,K)-PERTRB
  169       CONTINUE
  170    CONTINUE
  171 CONTINUE
  172 CONTINUE
      NPEROD = 0
      IF (NBDCND .EQ. 0) GO TO 173
      NPEROD = 1
      W(1) = 0.
      W(IWW-1) = 0.
  173 CONTINUE
      CALL POIS3D (LBDCND,LUNK,C1,MBDCND,MUNK,C2,NPEROD,NUNK,W,W(IWB),
     1             W(IWC),LDIMF,MDIMF,F(LSTART,MSTART,NSTART),IR,W(IWW))
C
C     FILL IN SIDES FOR PERIODIC BOUNDARY CONDITIONS.
C
      IF (LP .NE. 1) GO TO 180
      IF (MP .NE. 1) GO TO 175
      DO 174 K=NSTART,NSTOP
         F(1,MP1,K) = F(1,1,K)
  174 CONTINUE
      MSTOP = MP1
  175 IF (NP .NE. 1) GO TO 177
      DO 176 J=MSTART,MSTOP
         F(1,J,NP1) = F(1,J,1)
  176 CONTINUE
      NSTOP = NP1
  177 DO 179 J=MSTART,MSTOP
         DO 178 K=NSTART,NSTOP
            F(LP1,J,K) = F(1,J,K)
  178    CONTINUE
  179 CONTINUE
  180 CONTINUE
      IF (MP .NE. 1) GO TO 185
      IF (NP .NE. 1) GO TO 182
      DO 181 I=LSTART,LSTOP
         F(I,1,NP1) = F(I,1,1)
  181 CONTINUE
      NSTOP = NP1
  182 DO 184 I=LSTART,LSTOP
         DO 183 K=NSTART,NSTOP
            F(I,MP1,K) = F(I,1,K)
  183    CONTINUE
  184 CONTINUE
  185 CONTINUE
      IF (NP .NE. 1) GO TO 188
      DO 187 I=LSTART,LSTOP
         DO 186 J=MSTART,MSTOP
            F(I,J,NP1) = F(I,J,1)
  186    CONTINUE
  187 CONTINUE
  188 CONTINUE
      RETURN
      END
