#include <math.h>
void fooc(c,a,b,m,n)
double a[],*b,c[];
int *m,*n;
{
   int i;
   for ( i =0 ; i < (*m)*(*n) ; i++) 
     c[i] = sin(a[i]) + *b; 
}
