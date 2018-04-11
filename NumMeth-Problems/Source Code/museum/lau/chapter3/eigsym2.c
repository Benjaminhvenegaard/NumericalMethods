void eigsym2(float **a, int n, int numval, float val[],
				float **vec, float em[])
{
	float *allocate_real_vector(int, int);
	void free_real_vector(float *, int);
	void tfmsymtri2(float **, int, float [], float [], float [],
						float []);
	void valsymtri(float [], float [], int, int, int,
						float [], float []);
	void vecsymtri(float [], float [], int, int, int,
						float [], float **, float []);
	void baksymtri2(float **, int, int, int, float **);
	float *b,*bb,*d;

	b=allocate_real_vector(1,n);
	bb=allocate_real_vector(1,n);
	d=allocate_real_vector(1,n);
	tfmsymtri2(a,n,d,b,bb,em);
	valsymtri(d,bb,n,1,numval,val,em);
	vecsymtri(d,b,n,1,numval,val,vec,em);
	baksymtri2(a,n,1,numval,vec);
	free_real_vector(b,1);
	free_real_vector(bb,1);
	free_real_vector(d,1);
}

