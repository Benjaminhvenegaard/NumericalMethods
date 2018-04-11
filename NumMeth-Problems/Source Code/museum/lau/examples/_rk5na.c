#include <math.h>
#include <stdio.h>

float b(int n, float x[])
{
	return x[1];
}

float fxj(int n, int k, float x[])
{
	return ((k == 0) ? x[1] : 10.0*(1.0-x[0]*x[0])*x[1]-x[0]);
}

void main ()
{
	void rk5na(float [], float [], float (*)(int, float[]),
					float (*)(int, int, float[]), float [], float [],
					int, int, int, int);
	int j,first;
	float e[6],xa[2],x[2],d[5];

	for (j=0; j<=3; j++) e[j]=1.0e-4;
	e[4]=e[5]=1.0e-5;
	d[1]=0.0;
	xa[0]=2.0;  xa[1]=0.0;
	j=0;
	printf("Results:\n     x[0]        x[1]         s\n"
			" %9.5f   %9.5f   %9.5f\n",xa[0],xa[1],fabs(d[1]));
	do {
		first=(j == 0);
		rk5na(x,xa,b,fxj,e,d,first,1,1,0);
		j++;
		printf(" %9.5f   %9.5f   %9.5f\n",x[0],x[1],fabs(d[1]));
	} while (j < 4);
}

