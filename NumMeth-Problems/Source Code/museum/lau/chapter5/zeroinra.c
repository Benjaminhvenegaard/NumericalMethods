#include <float.h>
#include <math.h>

int zeroinrat(float *x, float *y, float (*fx)(float),
					float (*tolx)(float))
{
	int ext,first,extrapolate;
	float b,fb,a,fa,d,fd,c,fc,fdb,fda,w,mb,tol,m,p,q;

	b = *x;
	fb=(*fx)(*x);
	a = *x = *y;
	fa=(*fx)(*x);
	first=1;
	c=a;
	fc=fa;
	ext=0;
	extrapolate=1;
	while (extrapolate) {
		if (fabs(fc) < fabs(fb)) {
			if (c != a) {
				d=a;
				fd=fa;
			}
			a=b;
			fa=fb;
			b = *x =c;
			fb=fc;
			c=a;
			fc=fa;
		}
		tol=(*tolx)(*x);
		m=(c+b)*0.5;
		mb=m-b;
		if (fabs(mb) > tol) {
			if (ext > 3)
				w=mb;
			else {
				if (mb == 0.0)
					tol=0.0;
				else
					if (mb < 0.0) tol = -tol;
				p=(b-a)*fb;
				if (first) {
					q=fa-fb;
					first=0;
				} else {
					fdb=(fd-fb)/(d-b);
					fda=(fd-fa)/(d-a);
					p *= fda;
					q=fdb*fa-fda*fb;
				}
				if (p < 0.0) {
					p = -p;
					q = -q;
				}
				if (ext == 3) p *= 2.0;
				w=(p<FLT_MIN || p<=q*tol) ? tol : ((p<mb*q) ? p/q : mb);
			}
			d=a;
			fd=fa;
			a=b;
			fa=fb;
			*x = b += w;
			fb=(*fx)(*x);
			if ((fc >= 0.0) ? (fb >= 0.0) : (fb <= 0.0)) {
				c=a;
				fc=fa;
				ext=0;
			} else
				ext = (w == mb) ? 0 : ext+1;
		} else
			break;
	}
	*y = c;
	return ((fc >= 0.0) ? (fb <= 0.0) : (fb >= 0.0));
}
