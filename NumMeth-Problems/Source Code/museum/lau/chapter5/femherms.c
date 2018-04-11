#include <float.h>
#include <math.h>

void femhermsym(float x[], float y[], int n, float (*p)(float),
			float (*q)(float), float (*r)(float), float (*f)(float),
			int order, float e[])
{
	float *allocate_real_vector(int, int);
	void free_real_vector(float *, int);
	void chldecsolbnd(float [], int, int, float [], float []);
	void femhermsymeval(int, int, float (*)(float),
			float (*)(float), float (*)(float), float (*)(float),
			float *, float *, float *, float *, float *,
			float *, float *, float *, float *, float *,
			float *, float *, float *, float *, float *, float);
	int l,n2,v,w;
	float *a,em[4],a11,a12,a13,a14,a22,a23,a24,a33,a34,a44,ya,yb,za,
			zb,b1,b2,b3,b4,d1,d2,e1,r1,r2,xl1,xl;

	a=allocate_real_vector(1,8*(n-1));
	l=1;
	w=v=0;
	n2=n+n-2;
	xl1=x[0];
	xl=x[1];
	ya=e[1];
	za=e[2];
	yb=e[3];
	zb=e[4];
	/* element matvec evaluation */
	femhermsymeval(order,l,p,q,r,f,&a11,&a12,&a13,&a14,&a22,
			&a23,&a24,&a33,&a34,&a44,&b1,&b2,&b3,&b4,&xl,xl1);
	em[2]=FLT_EPSILON;
	r1=b3-a13*ya-a23*za;
	d1=a33;
	d2=a44;
	r2=b4-a14*ya-a24*za;
	e1=a34;
	l++;
	while (l < n) {
		xl1=xl;
		xl=x[l];
		/* element matvec evaluation */
		femhermsymeval(order,l,p,q,r,f,&a11,&a12,&a13,&a14,&a22,
				&a23,&a24,&a33,&a34,&a44,&b1,&b2,&b3,&b4,&xl,xl1);
		a[w+1]=d1+a11;
		a[w+4]=e1+a12;
		a[w+7]=a13;
		a[w+10]=a14;
		a[w+5]=d2+a22;
		a[w+8]=a23;
		a[w+11]=a24;
		a[w+14]=0.0;
		y[v+1]=r1+b1;
		y[v+2]=r2+b2;
		r1=b3;
		r2=b4;
		v += 2;
		w += 8;
		d1=a33;
		d2=a44;
		e1=a34;
		l++;
	}
	l=n;
	xl1=xl;
	xl=x[l];
	/* element matvec evaluation */
	femhermsymeval(order,l,p,q,r,f,&a11,&a12,&a13,&a14,&a22,
			&a23,&a24,&a33,&a34,&a44,&b1,&b2,&b3,&b4,&xl,xl1);
	y[n2-1]=r1+b1-a13*yb-a14*zb;
	y[n2]=r2+b2-a23*yb-a24*zb;
	a[w+1]=d1+a11;
	a[w+4]=e1+a12;
	a[w+5]=d2+a22;
	chldecsolbnd(a,n2,3,em,y);
	free_real_vector(a,1);
}

void femhermsymeval(int order, int l, float (*p)(float),
			float (*q)(float), float (*r)(float), float (*f)(float),
			float *a11, float *a12, float *a13, float *a14, float *a22,
			float *a23, float *a24, float *a33, float *a34, float *a44,
			float *b1, float *b2, float *b3, float *b4, float *xl,
			float xl1)
{
	/* this function is internally used by FEMHERMSYM */

	static float p3,p4,p5,q3,q4,q5,r3,r4,r5,f3,f4,f5;

	if (order == 4) {
		float x2,h,h2,h3,p1,p2,q1,q2,r1,r2,f1,f2,b11,b12,b13,b14,b22,
				b23,b24,b33,b34,b44,s11,s12,s13,s14,s22,s23,s24,s33,s34,
				s44,m11,m12,m13,m14,m22,m23,m24,m33,m34,m44;
		h=(*xl)-xl1;
		h2=h*h;
		h3=h*h2;
		x2=(xl1+(*xl))/2.0;
		if (l == 1) {
			p3=(*p)(xl1);
			q3=(*q)(xl1);
			r3=(*r)(xl1);
			f3=(*f)(xl1);
		}
		/* element bending matrix */
		p1=p3;
		p2=(*p)(x2);
		p3=(*p)(*xl);
		b11=6.0*(p1+p3);
		b12=4.0*p1+2.0*p3;
		b13 = -b11;
		b14=b11-b12;
		b22=(4.0*p1+p2+p3)/1.5;
		b23 = -b12;
		b24=b12-b22;
		b33=b11;
		b34 = -b14;
		b44=b14-b24;
		/* element stiffness matrix */
		q1=q3;
		q2=(*q)(x2);
		q3=(*q)(*xl);
		s11=1.5*q2;
		s12=q2/4.0;
		s13 = -s11;
		s14=s12;
		s24=q2/24.0;
		s22=q1/6.0+s24;
		s23 = -s12;
		s33=s11;
		s34 = -s12;
		s44=s24+q3/6.0;
		/* element mass matrix */
		r1=r3;
		r2=(*r)(x2);
		r3=(*r)(*xl);
		m11=(r1+r2)/6.0;
		m12=r2/24.0;
		m13=r2/6.0;
		m14 = -m12;
		m22=r2/96.0;
		m23 = -m14;
		m24 = -m22;
		m33=(r2+r3)/6.0;
		m34=m14;
		m44=m22;
		/* element load vector */
		f1=f3;
		f2=(*f)(x2);
		f3=(*f)(*xl);
		*b1=h*(f1+2.0*f2)/6.0;
		*b3=h*(f3+2.0*f2)/6.0;
		*b2=h2*f2/12.0;
		*b4 = -(*b2);
		*a11=b11/h3+s11/h+m11*h;
		*a12=b12/h2+s12+m12*h2;
		*a13=b13/h3+s13/h+m13*h;
		*a14=b14/h2+s14+m14*h2;
		*a22=b22/h+s22*h+m22*h3;
		*a23=b23/h2+s23+m23*h2;
		*a24=b24/h+s24*h+m24*h3;
		*a34=b34/h2+s34+m34*h2;
		*a33=b33/h3+s33/h+m33*h;
		*a44=b44/h+s44*h+m44*h3;
	} else if (order == 6) {
		float h,h2,h3,x2,x3,p1,p2,p3,q1,q2,q3,r1,r2,r3,f1,f2,f3,b11,b12,
				b13,b14,b15,b22,b23,b24,b25,b33,b34,b35,b44,b45,b55,s11,
				s12,s13,s14,s15,s22,s23,s24,s25,s33,s34,s35,s44,s45,s55,
				m11,m12,m13,m14,m15,m22,m23,m24,m25,m33,m34,m35,m44,m45,
				m55,a15,a25,a35,a45,a55,c1,c2,c3,c4,b5;
		if (l == 1) {
			p4=(*p)(xl1);
			q4=(*q)(xl1);
			r4=(*r)(xl1);
			f4=(*f)(xl1);
		}
		h=(*xl)-xl1;
		h2=h*h;
		h3=h*h2;
		x2=0.27639320225*h+xl1;
		x3=xl1+(*xl)-x2;
		/* element bending matrix */
		p1=p4;
		p2=(*p)(x2);
		p3=(*p)(x3);
		p4=(*p)(*xl);
		b11=4.0333333333333e1*p1+1.1124913866738e-1*p2+
				1.4422084194664e1*p3+8.3333333333333e0*p4;
		b12=1.4666666666667e1*p1-3.3191425091659e-1*p2+
				2.7985809175818e0*p3+1.6666666666667e0*p4;
		b13=1.8333333333333e1*(p1+p4)+1.2666666666667e0*(p2+p3);
		b15 = -(b11+b13);
		b14 = -(b12+b13+b15/2.0);
		b22=5.3333333333333e0*p1+9.9027346441674e-1*p2+
				5.4305986891624e-1*p3+3.3333333333333e-1*p4;
		b23=6.6666666666667e0*p1-3.7791278464167e0*p2+
				2.4579451308295e-1*p3+3.6666666666667e0*p4;
		b25 = -(b12+b23);
		b24 = -(b22+b23+b25/2.0);
		b33=8.3333333333333e0*p1+1.4422084194666e1*p2+
				1.1124913866726e-1*p3+4.0333333333333e1*p4;
		b35 = -(b13+b33);
		b34 = -(b23+b33+b35/2.0);
		b45 = -(b14+b34);
		b44 = -(b24+b34+b45/2.0);
		b55 = -(b15+b35);
		/* element stiffness matrix */
		q1=q4;
		q2=(*q)(x2);
		q3=(*q)(x3);
		q4=(*q)(*xl);
		s11=2.8844168389330e0*q2+2.2249827733448e-2*q3;
		s12=2.5671051872498e-1*q2+3.2894812749994e-3*q3;
		s13=2.5333333333333e-1*(q2+q3);
		s14 = -3.7453559925005e-2*q2-2.2546440074988e-2*q3;
		s15 = -(s13+s11);
		s22=8.3333333333333e-2*q1+2.2847006554164e-2*q2+
				4.8632677916445e-4*q3;
		s23=2.2546440075002e-2*q2+3.7453559924873e-2*q3;
		s24 = -3.3333333333333e-3*(q2+q3);
		s25 = -(s12+s23);
		s33=2.2249827733471e-2*q2+2.8844168389330e0*q3;
		s34 = -3.2894812750127e-3*q2-2.5671051872496e-1*q3;
		s35 = -(s13+s33);
		s44=4.8632677916788e-4*q2+2.2847006554161e-2*q3+
				8.3333333333338e-2*q4;
		s45 = -(s14+s34);
		s55 = -(s15+s35);
		/* element mass matrix */
		r1=r4;
		r2=(*r)(x2);
		r3=(*r)(x3);
		r4=(*r)(*xl);
		m11=8.3333333333333e-2*r1+1.0129076086083e-1*r2+
				7.3759058058380e-3*r3;
		m12=1.3296181273333e-2*r2+1.3704853933353e-3*r3;
		m13 = -2.7333333333333e-2*(r2+r3);
		m14=5.0786893258335e-3*r2+3.5879773408333e-3*r3;
		m15=1.3147987115999e-1*r2-3.5479871159991e-2*r3;
		m22=1.7453559925000e-3*r2+2.5464400750059e-4*r3;
		m23 = -3.5879773408336e-3*r2-5.0786893258385e-3*r3;
		m24=6.6666666666667e-4*(r2+r3);
		m25=1.7259029213333e-2*r2-6.5923625466719e-3*r3;
		m33=7.3759058058380e-3*r2+1.0129076086083e-1*r3+
				8.3333333333333e-2*r4;
		m34 = -1.3704853933333e-3*r2-1.3296181273333e-2*r3;
		m35 = -3.5479871159992e-2*r2+1.3147987115999e-1*r3;
		m44=2.5464400750008e-4*r2+1.7453559924997e-3*r3;
		m45=6.5923625466656e-3*r2-1.7259029213330e-2*r3;
		m55=0.17066666666667e0*(r2+r3);
		/* element load vector */
		f1=f4;
		f2=(*f)(x2);
		f3=(*f)(x3);
		f4=(*f)(*xl);
		*b1=8.3333333333333e-2*f1+2.0543729868749e-1*f2-
				5.5437298687489e-2*f3;
		*b2=2.6967233145832e-2*f2-1.0300566479175e-2*f3;
		*b3 = -5.5437298687489e-2*f2+2.0543729868749e-1*f3+
				8.3333333333333e-2*f4;
		*b4=1.0300566479165e-2*f2-2.6967233145830e-2*f3;
		b5=2.6666666666667e-1*(f2+f3);
		*a11=h2*(h2*m11+s11)+b11;
		*a12=h2*(h2*m12+s12)+b12;
		*a13=h2*(h2*m13+s13)+b13;
		*a14=h2*(h2*m14+s14)+b14;
		a15=h2*(h2*m15+s15)+b15;
		*a22=h2*(h2*m22+s22)+b22;
		*a23=h2*(h2*m23+s23)+b23;
		*a24=h2*(h2*m24+s24)+b24;
		a25=h2*(h2*m25+s25)+b25;
		*a33=h2*(h2*m33+s33)+b33;
		*a34=h2*(h2*m34+s34)+b34;
		a35=h2*(h2*m35+s35)+b35;
		*a44=h2*(h2*m44+s44)+b44;
		a45=h2*(h2*m45+s45)+b45;
		a55=h2*(h2*m55+s55)+b55;
		/* static condensation */
		c1=a15/a55;
		c2=a25/a55;
		c3=a35/a55;
		c4=a45/a55;
		*b1=((*b1)-c1*b5)*h;
		*b2=((*b2)-c2*b5)*h2;
		*b3=((*b3)-c3*b5)*h;
		*b4=((*b4)-c4*b5)*h2;
		*a11=((*a11)-c1*a15)/h3;
		*a12=((*a12)-c1*a25)/h2;
		*a13=((*a13)-c1*a35)/h3;
		*a14=((*a14)-c1*a45)/h2;
		*a22=((*a22)-c2*a25)/h;
		*a23=((*a23)-c2*a35)/h2;
		*a24=((*a24)-c2*a45)/h;
		*a33=((*a33)-c3*a35)/h3;
		*a34=((*a34)-c3*a45)/h2;
		*a44=((*a44)-c4*a45)/h;
	} else {
		float x2,x3,x4,h,h2,h3,p1,p2,p3,p4,q1,q2,q3,q4,r1,r2,r3,r4,
				f1,f2,f3,f4,b11,b12,b13,b14,b15,b16,b22,b23,b24,b25,b26,
				b33,b34,b35,b36,b44,b45,b46,b55,b56,b66,s11,s12,s13,s14,
				s15,s16,s22,s23,s24,s25,s26,s33,s34,s35,s36,s44,s45,s46,
				s55,s56,s66,m11,m12,m13,m14,m15,m16,m22,m23,m24,m25,m26,
				m33,m34,m35,m36,m44,m45,m46,m55,m56,m66,c15,c16,c25,c26,
				c35,c36,c45,c46,b5,b6,a15,a16,a25,a26,a35,a36,a45,a46,
				a55,a56,a66,det;
		if (l == 1) {
			p5=(*p)(xl1);
			q5=(*q)(xl1);
			r5=(*r)(xl1);
			f5=(*f)(xl1);
		}
		h=(*xl)-xl1;
		h2=h*h;
		h3=h*h2;
		x2=xl1+h*0.172673164646;
		x3=xl1+h/2.0;
		x4=xl1+(*xl)-x2;
		/* element bending matrix */
		p1=p5;
		p2=(*p)(x2);
		p3=(*p)(x3);
		p4=(*p)(x4);
		p5=(*p)(*xl);
		b11=105.8*p1+9.8*p5+7.3593121303513e-2*p2+
				2.2755555555556e1*p3+7.0565656088553e0*p4;
		b12=27.6*p1+1.4*p5-3.41554824811e-1*p2+
				2.8444444444444e0*p3+1.0113960946522e0*p4;
		b13 = -32.2*(p1+p5)-7.2063492063505e-1*(p2+p4)+
				2.2755555555556e1*p3;
		b14=4.6*p1+8.4*p5+1.0328641222944e-1*p2-
				2.8444444444444e0*p3-3.3445562534992e0*p4;
		b15 = -(b11+b13);
		b16 = -(b12+b13+b14+b15/2.0);
		b22=7.2*p1+0.2*p5+1.5851984028581e0*p2+
				3.5555555555556e-1*p3+1.4496032730059e-1*p4;
		b23 = -8.4*p1-4.6*p5+3.3445562534992e0*p2+
				2.8444444444444e0*p3-1.0328641222944e-1*p4;
		b24=1.2*(p1+p5)-4.7936507936508e-1*(p2+p4)-
				3.5555555555556e-1*p3;
		b25 = -(b12+b23);
		b26 = -(b22+b23+b24+b25/2.0);
		b33=7.0565656088553e0*p2+2.2755555555556e1*p3+
				7.3593121303513e-2*p4+105.8*p5+9.8*p1;
		b34 = -1.4*p1-27.6*p5-1.0113960946522e0*p2-
				2.8444444444444e0*p3+3.4155482481100e-1*p4;
		b35 = -(b13+b33);
		b36 = -(b23+b33+b34+b35/2.0);
		b44=7.2*p5+p1/5.0+1.4496032730059e-1*p2+
				3.5555555555556e-1*p3+1.5851984028581e0*p4;
		b45 = -(b14+b34);
		b46 = -(b24+b34+b44+b45/2.0);
		b55 = -(b15+b35);
		b56 = -(b16+b36);
		b66 = -(b26+b36+b46+b56/2.0);
		/* element stiffness matrix */
		q1=q5;
		q2=(*q)(x2);
		q3=(*q)(x3);
		q4=(*q)(x4);
		q5=(*q)(*xl);
		s11=3.0242424037951e0*q2+3.1539909130065e-2*q4;
		s12=1.2575525581744e-1*q2+4.1767169716742e-3*q4;
		s13 = -3.0884353741496e-1*(q2+q4);
		s14=4.0899041243062e-2*q2+1.2842455355577e-2*q4;
		s15 = -(s13+s11);
		s16=5.9254861177068e-1*q2+6.0512612719116e-2*q4;
		s22=5.2292052865422e-3*q2+5.5310763862796e-4*q4+q1/20.0;
		s23 = -1.2842455355577e-2*q2-4.0899041243062e-2*q4;
		s24=1.7006802721088e-3*(q2+q4);
		s25 = -(s12+s23);
		s26=2.4639593097426e-2*q2+8.0134681270641e-3*q4;
		s33=3.1539909130065e-2*q2+3.0242424037951e0*q4;
		s34 = -4.1767169716742e-3*q2-1.2575525581744e-1*q4;
		s35 = -(s13+s33);
		s36 = -6.0512612719116e-2*q2-5.9254861177068e-1*q4;
		s44=5.5310763862796e-4*q2+5.2292052865422e-3*q4+q5/20.0;
		s45 = -(s14+s34);
		s46=8.0134681270641e-3*q2+2.4639593097426e-2*q4;
		s55 = -(s15+s35);
		s56 = -(s16+s36);
		s66=1.1609977324263e-1*(q2+q4)+3.5555555555556e-1*q3;
		/* element mass matrix */
		r1=r5;
		r2=(*r)(x2);
		r3=(*r)(x3);
		r4=(*r)(x4);
		r5=(*r)(*xl);
		m11=9.7107020727310e-2*r2+1.5810259199180e-3*r4+r1/20.0;
		m12=8.2354889460254e-3*r2+2.1932154960071e-4*r4;
		m13=1.2390670553936e-2*(r2+r4);
		m14 = -1.7188466249968e-3*r2-1.0508326752939e-3*r4;
		m15=5.3089789712119e-2*r2+6.7741558661060e-3*r4;
		m16 = -1.7377712856076e-2*r2+2.2173630018466e-3*r4;
		m22=6.9843846173145e-4*r2+3.0424512029349e-5*r4;
		m23=1.0508326752947e-3*r2+1.7188466249936e-3*r4;
		m24 = -1.4577259475206e-4*(r2+r4);
		m25=4.5024589679127e-3*r2+9.3971790283374e-4*r4;
		m26 = -1.4737756452780e-3*r2+3.0759488725998e-4*r4;
		m33=1.5810259199209e-3*r2+9.7107020727290e-2*r4+r5/20.0;
		m34 = -2.1932154960131e-4*r2-8.2354889460354e-3*r4;
		m35=6.7741558661123e-3*r2+5.3089789712112e-2*r4;
		m36 = -2.2173630018492e-3*r2+1.7377712856071e-2*r4;
		m44=3.0424512029457e-5*r2+6.9843846173158e-4*r4;
		m45 = -9.3971790283542e-4*r2-4.5024589679131e-3*r4;
		m46=3.0759488726060e-4*r2-1.4737756452778e-3*r4;
		m55=2.9024943310657e-2*(r2+r4)+3.5555555555556e-1*r3;
		m56=9.5006428402050e-3*(r4-r2);
		m66=3.1098153547125e-3*(r2+r4);
		/* element load vector */
		f1=f5;
		f2=(*f)(x2);
		f3=(*f)(x3);
		f4=(*f)(x4);
		f5=(*f)(*xl);
		*b1=1.6258748099336e-1*f2+2.0745852339969e-2*f4+f1/20.0;
		*b2=1.3788780589233e-2*f2+2.8778860774335e-3*f4;
		*b3=2.0745852339969e-2*f2+1.6258748099336e-1*f4+f5/20.0;
		*b4 = -2.8778860774335e-3*f2-1.3788780589233e-2*f4;
		b5=(f2+f4)/11.25+3.5555555555556e-1*f3;
		b6=2.9095718698132e-2*(f4-f2);
		*a11=h2*(h2*m11+s11)+b11;
		*a12=h2*(h2*m12+s12)+b12;
		*a13=h2*(h2*m13+s13)+b13;
		*a14=h2*(h2*m14+s14)+b14;
		a15=h2*(h2*m15+s15)+b15;
		a16=h2*(h2*m16+s16)+b16;
		*a22=h2*(h2*m22+s22)+b22;
		*a23=h2*(h2*m23+s23)+b23;
		*a24=h2*(h2*m24+s24)+b24;
		a25=h2*(h2*m25+s25)+b25;
		a26=h2*(h2*m26+s26)+b26;
		*a33=h2*(h2*m33+s33)+b33;
		*a34=h2*(h2*m34+s34)+b34;
		a35=h2*(h2*m35+s35)+b35;
		a36=h2*(h2*m36+s36)+b36;
		*a44=h2*(h2*m44+s44)+b44;
		a45=h2*(h2*m45+s45)+b45;
		a46=h2*(h2*m46+s46)+b46;
		a55=h2*(h2*m55+s55)+b55;
		a56=h2*(h2*m56+s56)+b56;
		a66=h2*(h2*m66+s66)+b66;
		/* static condensation */
		det = -a55*a66+a56*a56;
		c15=(a15*a66-a16*a56)/det;
		c16=(a16*a55-a15*a56)/det;
		c25=(a25*a66-a26*a56)/det;
		c26=(a26*a55-a25*a56)/det;
		c35=(a35*a66-a36*a56)/det;
		c36=(a36*a55-a35*a56)/det;
		c45=(a45*a66-a46*a56)/det;
		c46=(a46*a55-a45*a56)/det;
		*a11=((*a11)+c15*a15+c16*a16)/h3;
		*a12=((*a12)+c15*a25+c16*a26)/h2;
		*a13=((*a13)+c15*a35+c16*a36)/h3;
		*a14=((*a14)+c15*a45+c16*a46)/h2;
		*a22=((*a22)+c25*a25+c26*a26)/h;
		*a23=((*a23)+c25*a35+c26*a36)/h2;
		*a24=((*a24)+c25*a45+c26*a46)/h;
		*a33=((*a33)+c35*a35+c36*a36)/h3;
		*a34=((*a34)+c35*a45+c36*a46)/h2;
		*a44=((*a44)+c45*a45+c46*a46)/h;
		*b1=((*b1)+c15*b5+c16*b6)*h;
		*b2=((*b2)+c25*b5+c26*b6)*h2;
		*b3=((*b3)+c35*b5+c36*b6)*h;
		*b4=((*b4)+c45*b5+c46*b6)*h2;
	}
}
