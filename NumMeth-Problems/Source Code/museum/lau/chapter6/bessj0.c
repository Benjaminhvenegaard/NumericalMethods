#include <math.h>

float bessj0(float x)
{
	if (x == 0.0) return 1.0;
	if (fabs(x) < 8.0) {
		int i;
		float z,z2,b0,b1,b2;
		static float ar[15]={-0.75885e-15, 0.4125321e-13,
			-0.194383469e-11, 0.7848696314e-10, -0.267925353056e-8,
			0.7608163592419e-7, -0.176194690776215e-5,
			0.324603288210051e-4, -0.46062616620628e-3,
			0.48191800694676e-2, -0.34893769411409e-1,
			0.158067102332097, -0.37009499387265, 0.265178613203337,
			-0.872344235285222e-2};
		x /= 8.0;
		z=2.0*x*x-1.0;
		z2=z+z;
		b1=b2=0.0;
		for (i=0; i<=14; i++) {
			b0=z2*b1-b2+ar[i];
			b2=b1;
			b1=b0;
		}
		return z*b1-b2+0.15772797147489;
	} else {
		void besspq0(float, float *, float *);
		float c,cosx,sinx,p0,q0;
		x=fabs(x);
		c=0.797884560802865/sqrt(x);
		cosx=cos(x-0.706858347057703e1);
		sinx=sin(x-0.706858347057703e1);
		besspq0(x,&p0,&q0);
		return c*(p0*cosx-q0*sinx);
	}
}
