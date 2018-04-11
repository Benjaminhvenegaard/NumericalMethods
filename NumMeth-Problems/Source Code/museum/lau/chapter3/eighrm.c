void eighrm(float **a, int n, int numval, float val[], float **vecr,
				float **veci, float em[])
{
	float *allocate_real_vector(int, int);
	void free_real_vector(float *, int);
	void hshhrmtri(float **, int, float [], float [], float [],
						float [], float [], float []);
	void valsymtri(float [], float [], int, int, int,
						float [], float []);
	void vecsymtri(float [], float [], int, int, int,
						float [], float **, float []);
	void bakhrmtri(float **, int, int, int, float **,
						float **, float [], float []);
	float *bb,*tr,*ti,*d,*b;

	bb=allocate_real_vector(1,n-1);
	tr=allocate_real_vector(1,n-1);
	ti=allocate_real_vector(1,n-1);
	d=allocate_real_vector(1,n);
	b=allocate_real_vector(1,n);
	hshhrmtri(a,n,d,b,bb,em,tr,ti);
	valsymtri(d,bb,n,1,numval,val,em);
	b[n]=0.0;
	vecsymtri(d,b,n,1,numval,val,vecr,em);
	bakhrmtri(a,n,1,numval,vecr,veci,tr,ti);
	free_real_vector(bb,1);
	free_real_vector(tr,1);
	free_real_vector(ti,1);
	free_real_vector(d,1);
	free_real_vector(b,1);
}

