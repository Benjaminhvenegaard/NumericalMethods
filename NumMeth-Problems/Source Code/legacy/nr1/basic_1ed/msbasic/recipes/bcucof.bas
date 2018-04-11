DATA 1.,0.,-3.,2.,0.,0.,0.,0.,-3.,0.,9.,-6.,2.,0.,-6.,4.,0.,0.,0.,0.,0.,0.,0.
DATA 0.,3.,0.,-9.,6.,-2.,0.,6.,-4.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,9.,-6.,0.,0.
DATA -6.,4.,0.,0.,3.,-2.,0.,0.,0.,0.,0.,0.,-9.,6.,0.,0.,6.,-4.,0.,0.,0.,0.,1.
DATA 0.,-3.,2.,-2.,0.,6.,-4.,1.,0.,-3.,2.,0.,0.,0.,0.,0.,0.,0.,0.,-1.,0.,3.
DATA -2.,1.,0.,-3.,2.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,-3.,2.,0.,0.,3.,-2.,0.,0.
DATA 0.,0.,0.,0.,3.,-2.,0.,0.,-6.,4.,0.,0.,3.,-2.,0.,1.,-2.,1.,0.,0.,0.,0.,0.
DATA -3.,6.,-3.,0.,2.,-4.,2.,0.,0.,0.,0.,0.,0.,0.,0.,0.,3.,-6.,3.,0.,-2.,4.
DATA -2.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,-3.,3.,0.,0.,2.,-2.,0.,0.,-1.,1.,0.,0.
DATA 0.,0.,0.,0.,3.,-3.,0.,0.,-2.,2.,0.,0.,0.,0.,0.,1.,-2.,1.,0.,-2.,4.,-2.,0.
DATA 1.,-2.,1.,0.,0.,0.,0.,0.,0.,0.,0.,0.,-1.,2.,-1.,0.,1.,-2.,1.,0.,0.,0.,0.
DATA 0.,0.,0.,0.,0.,0.,1.,-1.,0.,0.,-1.,1.,0.,0.,0.,0.,0.,0.,-1.,1.,0.,0.,2.
DATA -2.,0.,0.,-1.,1.

SUB BCUCOF (Y(), Y1(), Y2(), Y12(), D1, D2, C())
DIM CL(16), X(16), WT(16, 16)
RESTORE
FOR J = 1 TO 16
  FOR I = 1 TO 16
    READ WT(I, J)
  NEXT I
NEXT J
D1D2 = D1 * D2
FOR I = 1 TO 4
  X(I) = Y(I)
  X(I + 4) = Y1(I) * D1
  X(I + 8) = Y2(I) * D2
  X(I + 12) = Y12(I) * D1D2
NEXT I
FOR I = 1 TO 16
  XX = 0!
  FOR K = 1 TO 16
    XX = XX + WT(I, K) * X(K)
  NEXT K
  CL(I) = XX
NEXT I
L = 0
FOR I = 1 TO 4
  FOR J = 1 TO 4
    L = L + 1
    C(I, J) = CL(L)
  NEXT J
NEXT I
ERASE WT, X, CL
END SUB

