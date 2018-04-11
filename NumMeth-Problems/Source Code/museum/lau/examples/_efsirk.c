#include <math.h>
#include <stdio.h>

float lnx;

void der(int m, float y[], float *delta)
{
	float y2;

	y2=y[2];
	*delta = -exp(y2);
	lnx=log(y2);
	y[1]=(y[1]-lnx)*(*delta)+1.0/y2;
	y[2]=1.0;
}

void jac(int m, float **j, float y[], float *delta)
{
	float y2;

	y2=y[2];
	j[1][1]=(*delta);
	j[1][2]=(y[1]-lnx-1.0/y2)*(*delta)-1.0/(y2*y2);
	j[2][1]=j[2][2]=0.0;
}

void outp(float x, float xe, int m, float y[],
			float delta, float **j, int n)
{
	float y1;

	if (x == xe) {
		y1=y[1];
		lnx=log(x);
		printf("\n N =%3d    X =%4.1f    Y(X) = %7.5f"
			"	  DELTA = %4.2f\n ABS.ERR. = %7.2e"
			"   REL.ERR. = %7.2e\n",
			n,x,y1,delta,fabs(y1-lnx),fabs((y1-lnx)/lnx));
	}
}

void main ()
{
	void efsirk(float *, float, int, float [], float *,
			void (*)(int, float[], float *),
			void (*)(int, float **, float [], float *),
			float **, int *, float, float, float, float, int,
			void (*)(float, float, int, float [],
								float, float **, int));
	int n;
	float x,xe,delta,y[3],**j;

	j=allocate_real_matrix(1,2,1,2);
	printf("EFSIRK delivers:\n");
	xe=0.4;
	x=0.01;
	y[1]=log(0.01);
	y[2]=x;
	efsirk(&x,xe,2,y,&delta,der,jac,j,&n,1.0e-2,1.0e-2,0.005,1.5,
			0,outp);
	xe=8.0;
	efsirk(&x,xe,2,y,&delta,der,jac,j,&n,1.0e-2,1.0e-2,0.005,1.5,
			0,outp);
	free_real_matrix(j,1,2,1);
}

