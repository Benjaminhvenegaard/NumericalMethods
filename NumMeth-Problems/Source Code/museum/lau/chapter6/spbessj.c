#include <math.h>

void spherbessj(float x, int n, float j[])
{
	if (x == 0.0) {
		j[0]=1.0;
		for (; n>=1; n--) j[n]=0.0;
	} else if (n == 0) {
		float x2;
		if (fabs(x) < 0.015) {
			x2=x*x/6.0;
			j[0]=1.0+x2*(x2*0.3-1.0);
		} else
			j[0]=sin(x)/x;
	} else {
		int start(float, int, int);
		int m;
		float r,s;
		r=0.0;
		m=start(x,n,0);
		for (; m>=1; m--) {
			r=1.0/((m+m+1)/x-r);
			if (m <= n) j[m]=r;
		}
		if (x < 0.015) {
			s=x*x/6.0;
			j[0]=r=s*(s*0.3-1.0)+1.0;
		} else
			j[0]=r=sin(x)/x;
		for (m=1; m<=n; m++) r = j[m] *= r;
	}
}
