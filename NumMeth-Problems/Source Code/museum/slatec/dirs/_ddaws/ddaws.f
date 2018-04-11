      DOUBLE PRECISION FUNCTION DDAWS (X)
      DOUBLE PRECISION X, DAWCS(21), DAW2CS(45), DAWACS(75), XBIG,
     1  XMAX, XSML, Y, DCSEVL, D1MACH
      LOGICAL FIRST
      SAVE DAWCS, DAW2CS, DAWACS, NTDAW, NTDAW2, NTDAWA,
     1 XSML, XBIG, XMAX, FIRST
      DATA DAWCS(  1) / -.6351734375 1459492010 6512773629 3 D-2      /
      DATA DAWCS(  2) / -.2294071479 6773869398 9982412586 6 D+0      /
      DATA DAWCS(  3) / +.2213050093 9084764416 8397916178 6 D-1      /
      DATA DAWCS(  4) / -.1549265453 8929850467 4305775337 5 D-2      /
      DATA DAWCS(  5) / +.8497327715 6849174567 7754294806 6 D-4      /
      DATA DAWCS(  6) / -.3828266270 9720149249 9409952130 9 D-5      /
      DATA DAWCS(  7) / +.1462854806 2501631977 5714894953 9 D-6      /
      DATA DAWCS(  8) / -.4851982381 8259917988 4671542511 4 D-8      /
      DATA DAWCS(  9) / +.1421463577 7591397903 4756818330 4 D-9      /
      DATA DAWCS( 10) / -.3728836087 9205965253 3549305408 8 D-11     /
      DATA DAWCS( 11) / +.8854942961 7782033701 9456523136 9 D-13     /
      DATA DAWCS( 12) / -.1920757131 3502063554 2164841749 3 D-14     /
      DATA DAWCS( 13) / +.3834325867 2463275882 4107443925 3 D-16     /
      DATA DAWCS( 14) / -.7089154168 1758816335 8409932799 9 D-18     /
      DATA DAWCS( 15) / +.1220552135 8894576744 1690112000 0 D-19     /
      DATA DAWCS( 16) / -.1966204826 6053487602 9945173333 3 D-21     /
      DATA DAWCS( 17) / +.2975845541 3765971891 1317333333 3 D-23     /
      DATA DAWCS( 18) / -.4247069514 8005969510 3999999999 9 D-25     /
      DATA DAWCS( 19) / +.5734270767 3917427985 0666666666 6 D-27     /
      DATA DAWCS( 20) / -.7345836823 1784502613 3333333333 3 D-29     /
      DATA DAWCS( 21) / +.8951937667 5165525333 3333333333 3 D-31     /
      DATA DAW2CS(  1) / -.5688654410 5215527114 1605337336 74 D-1     /
      DATA DAW2CS(  2) / -.3181134699 6168131279 3228780488 22 D+0     /
      DATA DAW2CS(  3) / +.2087384541 3642236789 7415801988 58 D+0     /
      DATA DAW2CS(  4) / -.1247540991 3779131214 0734983147 84 D+0     /
      DATA DAW2CS(  5) / +.6786930518 6676777092 8475164236 76 D-1     /
      DATA DAW2CS(  6) / -.3365914489 5270939503 0682309665 87 D-1     /
      DATA DAW2CS(  7) / +.1526078127 1987971743 6824603816 40 D-1     /
      DATA DAW2CS(  8) / -.6348370962 5962148230 5860947885 35 D-2     /
      DATA DAW2CS(  9) / +.2432674092 0748520596 8659661093 43 D-2     /
      DATA DAW2CS( 10) / -.8621954149 1065032038 5269835496 37 D-3     /
      DATA DAW2CS( 11) / +.2837657333 6321625302 8576365382 95 D-3     /
      DATA DAW2CS( 12) / -.8705754987 4170423699 3965814643 35 D-4     /
      DATA DAW2CS( 13) / +.2498684998 5481658331 8000441372 76 D-4     /
      DATA DAW2CS( 14) / -.6731928676 4160294344 6030503395 20 D-5     /
      DATA DAW2CS( 15) / +.1707857878 5573543710 5045240478 44 D-5     /
      DATA DAW2CS( 16) / -.4091755122 6475381271 8965924900 38 D-6     /
      DATA DAW2CS( 17) / +.9282829221 6755773260 7517853122 73 D-7     /
      DATA DAW2CS( 18) / -.1999140361 0147617829 8450963321 98 D-7     /
      DATA DAW2CS( 19) / +.4096349064 4082195241 2104878689 17 D-8     /
      DATA DAW2CS( 20) / -.8003240954 0993168075 7067817535 61 D-9     /
      DATA DAW2CS( 21) / +.1493850312 8761465059 1432255501 10 D-9     /
      DATA DAW2CS( 22) / -.2668799988 5622329284 9246510633 39 D-10    /
      DATA DAW2CS( 23) / +.4571221698 5159458151 4056177241 03 D-11    /
      DATA DAW2CS( 24) / -.7518730522 2043565872 2437273267 71 D-12    /
      DATA DAW2CS( 25) / +.1189310005 2629681879 0298289873 02 D-12    /
      DATA DAW2CS( 26) / -.1811690793 3852346973 4903182630 84 D-13    /
      DATA DAW2CS( 27) / +.2661173368 4358969193 0016121996 26 D-14    /
      DATA DAW2CS( 28) / -.3773886305 2129419795 4441099059 30 D-15    /
      DATA DAW2CS( 29) / +.5172795378 9087172679 6800822293 29 D-16    /
      DATA DAW2CS( 30) / -.6860368408 4077500979 4195646701 02 D-17    /
      DATA DAW2CS( 31) / +.8812375135 4161071806 4693373217 45 D-18    /
      DATA DAW2CS( 32) / -.1097424824 9996606292 1062996246 52 D-18    /
      DATA DAW2CS( 33) / +.1326119932 6367178513 5955458916 35 D-19    /
      DATA DAW2CS( 34) / -.1556273276 8137380785 4887765715 62 D-20    /
      DATA DAW2CS( 35) / +.1775142558 3655720607 8334155707 73 D-21    /
      DATA DAW2CS( 36) / -.1969500696 7006578384 9536087654 39 D-22    /
      DATA DAW2CS( 37) / +.2127007489 6998699661 9240101205 33 D-23    /
      DATA DAW2CS( 38) / -.2237539812 4627973794 1821139626 66 D-24    /
      DATA DAW2CS( 39) / +.2294276857 8582348946 9713831253 33 D-25    /
      DATA DAW2CS( 40) / -.2294378884 6552928693 3295923199 99 D-26    /
      DATA DAW2CS( 41) / +.2239170210 0592453618 3422976000 00 D-27    /
      DATA DAW2CS( 42) / -.2133823061 6608897703 6782250666 66 D-28    /
      DATA DAW2CS( 43) / +.1986619658 5123531518 0284586666 66 D-29    /
      DATA DAW2CS( 44) / -.1807929586 6694391771 9551999999 99 D-30    /
      DATA DAW2CS( 45) / +.1609068601 5283030305 4506666666 66 D-31    /
      DATA DAWACS(  1) / +.1690485637 7657037554 2263743884 9 D-1      /
      DATA DAWACS(  2) / +.8683252278 4069579905 3610785076 8 D-2      /
      DATA DAWACS(  3) / +.2424864042 4177154532 7770345988 9 D-3      /
      DATA DAWACS(  4) / +.1261182399 5726900016 5194924037 7 D-4      /
      DATA DAWACS(  5) / +.1066453314 6361769557 0569112590 6 D-5      /
      DATA DAWACS(  6) / +.1358159794 7907276113 4842450572 8 D-6      /
      DATA DAWACS(  7) / +.2171042356 5772983989 0431274474 3 D-7      /
      DATA DAWACS(  8) / +.2867010501 8052952703 4367680481 3 D-8      /
      DATA DAWACS(  9) / -.1901336393 0358201122 8249237802 4 D-9      /
      DATA DAWACS( 10) / -.3097780484 3952011255 3206577426 8 D-9      /
      DATA DAWACS( 11) / -.1029414876 0575092473 9813228641 3 D-9      /
      DATA DAWACS( 12) / -.6260356459 4595761504 1758728312 1 D-11     /
      DATA DAWACS( 13) / +.8563132497 4464512162 6230316627 6 D-11     /
      DATA DAWACS( 14) / +.3033045148 0756592929 7626627625 7 D-11     /
      DATA DAWACS( 15) / -.2523618306 8092913726 3088693882 6 D-12     /
      DATA DAWACS( 16) / -.4210604795 4406645131 7546193451 0 D-12     /
      DATA DAWACS( 17) / -.4431140826 6462383121 4342945203 6 D-13     /
      DATA DAWACS( 18) / +.4911210272 8412052059 4003706511 7 D-13     /
      DATA DAWACS( 19) / +.1235856242 2839034070 7647795473 9 D-13     /
      DATA DAWACS( 20) / -.5788733199 0165692469 5576507106 9 D-14     /
      DATA DAWACS( 21) / -.2282723294 8073586209 7818395703 0 D-14     /
      DATA DAWACS( 22) / +.7637149411 0141264763 1236291759 0 D-15     /
      DATA DAWACS( 23) / +.3851546883 5668117287 7759400209 5 D-15     /
      DATA DAWACS( 24) / -.1199932056 9282905928 0323728304 5 D-15     /
      DATA DAWACS( 25) / -.6313439150 0945723473 3427028525 0 D-16     /
      DATA DAWACS( 26) / +.2239559965 9729753752 5491279023 7 D-16     /
      DATA DAWACS( 27) / +.9987925830 0764959951 3289120074 9 D-17     /
      DATA DAWACS( 28) / -.4681068274 3224953345 3624650725 2 D-17     /
      DATA DAWACS( 29) / -.1436303644 3497213372 4162875153 4 D-17     /
      DATA DAWACS( 30) / +.1020822731 4105411129 7790803213 0 D-17     /
      DATA DAWACS( 31) / +.1538908873 1360920728 3738982237 2 D-18     /
      DATA DAWACS( 32) / -.2189157877 6457938888 9479092605 6 D-18     /
      DATA DAWACS( 33) / +.2156879197 9386517503 9235915251 7 D-20     /
      DATA DAWACS( 34) / +.4370219827 4424498511 3479255739 5 D-19     /
      DATA DAWACS( 35) / -.8234581460 9772072410 9892790517 7 D-20     /
      DATA DAWACS( 36) / -.7498648721 2564662229 0320283542 0 D-20     /
      DATA DAWACS( 37) / +.3282536720 7356716109 5761293003 9 D-20     /
      DATA DAWACS( 38) / +.8858064309 5039211160 7656151515 1 D-21     /
      DATA DAWACS( 39) / -.9185087111 7270029880 9446053148 5 D-21     /
      DATA DAWACS( 40) / +.2978962223 7887489883 1416604579 1 D-22     /
      DATA DAWACS( 41) / +.1972132136 6184718831 5950546804 1 D-21     /
      DATA DAWACS( 42) / -.5974775596 3629066380 8958499511 7 D-22     /
      DATA DAWACS( 43) / -.2834410031 5038509654 4382518244 1 D-22     /
      DATA DAWACS( 44) / +.2209560791 1315545147 7715048901 2 D-22     /
      DATA DAWACS( 45) / -.5439955741 8971443000 7948030771 1 D-25     /
      DATA DAWACS( 46) / -.5213549243 2948486680 1713669647 0 D-23     /
      DATA DAWACS( 47) / +.1702350556 8131141990 6567149907 6 D-23     /
      DATA DAWACS( 48) / +.6917400860 8361483430 2218566019 7 D-24     /
      DATA DAWACS( 49) / -.6540941793 0027525122 3944512580 2 D-24     /
      DATA DAWACS( 50) / +.6093576580 4393289603 7182465463 6 D-25     /
      DATA DAWACS( 51) / +.1408070432 9051874615 0194508027 2 D-24     /
      DATA DAWACS( 52) / -.6785886121 0548463311 6767494375 5 D-25     /
      DATA DAWACS( 53) / -.9799732036 2142957117 4158310222 5 D-26     /
      DATA DAWACS( 54) / +.2121244903 0990413325 9896093916 0 D-25     /
      DATA DAWACS( 55) / -.5954455022 5487909382 3880215448 7 D-26     /
      DATA DAWACS( 56) / -.3093088861 8754701778 3884723204 9 D-26     /
      DATA DAWACS( 57) / +.2854389216 3445246824 0069198610 4 D-26     /
      DATA DAWACS( 58) / -.3951289447 3793055660 2347727181 1 D-27     /
      DATA DAWACS( 59) / -.5906000648 6076284781 1684089445 3 D-27     /
      DATA DAWACS( 60) / +.3670236964 6686870036 4788998060 9 D-27     /
      DATA DAWACS( 61) / -.4839958238 0422762565 9830303894 1 D-29     /
      DATA DAWACS( 62) / -.9799265984 2104438695 9740401702 2 D-28     /
      DATA DAWACS( 63) / +.4684773732 6121306061 5890880430 0 D-28     /
      DATA DAWACS( 64) / +.5030877696 9934610516 4766760315 5 D-29     /
      DATA DAWACS( 65) / -.1547395051 7060282392 4755206829 5 D-28     /
      DATA DAWACS( 66) / +.6112180185 0864192439 7600566271 4 D-29     /
      DATA DAWACS( 67) / +.1357913399 1248116503 4360273615 8 D-29     /
      DATA DAWACS( 68) / -.2417687752 7686730883 8530429904 4 D-29     /
      DATA DAWACS( 69) / +.8369074582 0742989452 9288758729 1 D-30     /
      DATA DAWACS( 70) / +.2665413042 7889791658 3831940156 6 D-30     /
      DATA DAWACS( 71) / -.3811653692 3548903369 3569100371 2 D-30     /
      DATA DAWACS( 72) / +.1230054721 8849514643 7170687258 5 D-30     /
      DATA DAWACS( 73) / +.4622506399 0414935088 0553692998 3 D-31     /
      DATA DAWACS( 74) / -.6120087296 8816777229 1143559300 1 D-31     /
      DATA DAWACS( 75) / +.1966024640 1931646869 5623021789 6 D-31     /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DDAWS
      IF (FIRST) THEN
         EPS = D1MACH(3)
         NTDAW = INITDS (DAWCS, 21, 0.1*EPS)
         NTDAW2 = INITDS (DAW2CS, 45, 0.1*EPS)
         NTDAWA = INITDS (DAWACS, 75, 0.1*EPS)
C
         XSML = SQRT(1.5*EPS)
         XBIG = SQRT (0.5/EPS)
         XMAX = EXP (MIN (-LOG(2.D0*D1MACH(1)), LOG(D1MACH(2)))
     1     - 0.001D0)
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.1.0D0) GO TO 20
C
      DDAWS = X
      IF (Y.LE.XSML) RETURN
C
      DDAWS = X * (.75D0 + DCSEVL (2.D0*Y*Y-1.D0, DAWCS, NTDAW))
      RETURN
C
 20   IF (Y.GT.4.D0) GO TO 30
      DDAWS = X * (.25D0 + DCSEVL (.125D0*Y*Y-1.D0, DAW2CS, NTDAW2))
      RETURN
C
 30   IF (Y.GT.XMAX) GO TO 40
      DDAWS = 0.5D0/X
      IF (Y.GT.XBIG) RETURN
C
      DDAWS = (0.5D0 + DCSEVL (32.D0/Y**2-1.D0, DAWACS, NTDAWA)) / X
      RETURN
C
 40   CALL XERMSG ('SLATEC', 'DDAWS', 'ABS(X) SO LARGE DAWS UNDERFLOWS',
     +   1, 1)
      DDAWS = 0.0D0
      RETURN
C
      END
