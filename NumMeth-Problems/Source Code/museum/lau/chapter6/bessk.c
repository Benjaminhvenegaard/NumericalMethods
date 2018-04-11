#include <math.h>

void bessk(float x, int n, float k[])
{
	void bessk01(float, float *, float *);
	int i;
	float k0,k1,k2;

	bessk01(x,&k0,&k1);
	k[0]=k0;
	if (n > 0) k[1]=k1;
	x=2.0/x;
	for (i=2; i<=n; i++) {
		k[i]=k2=k0+x*(i-1)*k1;
		k0=k1;
		k1=k2;
	}
}
