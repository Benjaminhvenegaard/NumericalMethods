#include <math.h>
#include <stdio.h>
void main ()
{
	void besspqa01(float, float, float *, float *, float *, float *);
	int i;
	float p,q,r,s;
	static float x[7]={1.0, 3.0, 5.0, 10.0, 15.0, 20.0, 50.0};

	printf("BESSPQA01 delivers:\n");
	for (i=0; i<=6; i++) {
		besspqa01(0.0,x[i],&p,&q,&r,&s);
		printf(" %5.0f   %e\n",x[i],fabs(p*r+q*s-1.0));
	}
}

