int reaeig1(float **a, int n, float em[], float val[], float **vec)
{
	int *allocate_integer_vector(int, int);
	float *allocate_real_vector(int, int);
	float **allocate_real_matrix(int, int, int, int);
	void free_integer_vector(int *, int);
	void free_real_vector(float *, int);
	void free_real_matrix(float **, int, int, int);
	void tfmreahes(float **, int, float [], int []);
	void bakreahes2(float **, int, int, int, int [], float **);
	void eqilbr(float **, int, float [], float [], int []);
	void baklbr(int, int, int, float [], int [], float **);
	int reavalqri(float **, int, float [], float []);
	void reaveches(float **, int, float, float [], float []);
	void reascl(float **, int, int, int);
	int i,k,max,j,l,*ind,*ind0;
	float residu,r,machtol,*d,*v,**b;

	ind=allocate_integer_vector(1,n);
	ind0=allocate_integer_vector(1,n);
	d=allocate_real_vector(1,n);
	v=allocate_real_vector(1,n);
	b=allocate_real_matrix(1,n,1,n);

	residu=0.0;
	max=0;
	eqilbr(a,n,em,d,ind0);
	tfmreahes(a,n,em,ind);
	for (i=1; i<=n; i++)
		for (j=((i == 1) ? 1 : i-1); j<=n; j++) b[i][j]=a[i][j];
	k=reavalqri(b,n,em,val);
	for (i=k+1; i<=n; i++)
		for (j=i+1; j<=n; j++)
			if (val[j] > val[i]) {
				r=val[i];
				val[i]=val[j];
				val[j]=r;
			}
	machtol=em[0]*em[1];
	for (l=k+1; l<=n; l++) {
		if (l > 1)
			if (val[l-1]-val[l] < machtol) val[l]=val[l-1]-machtol;
		for (i=1; i<=n; i++)
			for (j=((i == 1) ? 1 : i-1); j<=n; j++) b[i][j]=a[i][j];
		reaveches(b,n,val[l],em,v);
		if (em[7] > residu) residu=em[7];
		if (em[9] > max) max=em[9];
		for (j=1; j<=n; j++) vec[j][l]=v[j];
	}
	em[7]=residu;
	em[9]=max;
	bakreahes2(a,n,k+1,n,ind,vec);
	baklbr(n,k+1,n,d,ind0,vec);
	reascl(vec,n,k+1,n);
	free_integer_vector(ind,1);
	free_integer_vector(ind0,1);
	free_real_vector(d,1);
	free_real_vector(v,1);
	free_real_matrix(b,1,n,1);
	return k;
}

