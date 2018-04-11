DECLARE SUB AVEVAR (DATQ!(), N!, AVE!, VAR!)
DECLARE FUNCTION BETAI! (A!, B!, X!)

SUB TTEST (DATA1(), N1, DATA2(), N2, T, PROB)
CALL AVEVAR(DATA1(), N1, AVE1, VAR1)
CALL AVEVAR(DATA2(), N2, AVE2, VAR2)
DF = N1 + N2 - 2
VAR = ((N1 - 1) * VAR1 + (N2 - 1) * VAR2) / DF
T = (AVE1 - AVE2) / SQR(VAR * (1! / N1 + 1! / N2))
PROB = BETAI(.5 * DF, .5, DF / (DF + T ^ 2))
END SUB
