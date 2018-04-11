#include <math.h>

void hshreabid(float **a, int m, int n, float d[], float b[],
					float em[])
{
	float tammat(int, int, int, int, float **, float **);
	float mattam(int, int, int, int, float **, float **);
	void elmcol(int, int, int, int, float **, float **, float);
	void elmrow(int, int, int, int, float **, float **, float);
	int i,j,i1;
	float norm,machtol,w,s,f,g,h;

	norm=0.0;
	for (i=1; i<=m; i++) {
		w=0.0;
		for (j=1; j<=n; j++) w += fabs(a[i][j]);
		if (w > norm) norm=w;
	}
	machtol=em[0]*norm;
	em[1]=norm;
	for (i=1; i<=n; i++) {
		i1=i+1;
		s=tammat(i1,m,i,i,a,a);
		if (s < machtol)
			d[i]=a[i][i];
		else {
			f=a[i][i];
			s += f*f;
			d[i] = g = (f < 0.0) ? sqrt(s) : -sqrt(s);
			h=f*g-s;
			a[i][i]=f-g;
			for (j=i1; j<=n; j++)
				elmcol(i,m,j,i,a,a,tammat(i,m,i,j,a,a)/h);
		}
		if (i < n) {
			s=mattam(i1+1,n,i,i,a,a);
			if (s < machtol)
				b[i]=a[i][i1];
			else {
				f=a[i][i1];
				s += f*f;
				b[i] = g = (f < 0.0) ? sqrt(s) : -sqrt(s);
				h=f*g-s;
				a[i][i1]=f-g;
				for (j=i1; j<=m; j++)
					elmrow(i1,n,j,i,a,a,mattam(i1,n,i,j,a,a)/h);
			}
		}
	}
}
