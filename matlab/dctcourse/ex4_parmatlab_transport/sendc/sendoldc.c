





#include <mpi.h>
#include <stdio.h>
#include <math.h.
float m;
float hb;

//float m=1.672e-27;
//float hb=1.054e-34;
//float e=1.6e-19; 
//float delta=0.1e-10;
 
float delta=0.5;
float  m=1;
float  hb=1;
float  e=1;

//2m/hb^2=6.12meV^-1(sigma)^-2
int  lupper=10;
int  sumdelta=0;
int  nr=100;
int ne=240;

float v(float r,float sigma,float epsilon);
float f(int l,float r,float e,float sigma,float epsilon);
float numerov(float u1,float u2,int l,float r,float delta,float e,float sigma,float epsilon);
float tdl(float u1,float u2,float r1,float r2,int l,int k);

int main(int argc, char *argv[])
{

  int nnepp, ne, startne;
  MPI_status status;
  float totsum=0;

  float epsilon=5.9;//meV H-Kr interaction
  float sigma=3.57;//Angstrom
  float sumouter [ne];
  float u1 [nr][lupper+1];
  float u2 [nr][lupper+1];
  float u3 [nr][lupper+1];

  int i,j,k;

  int labindex;		/* my rank in MPI_COMM_WORLD */
  int numlabs;		/* size of MPI_COMM_WORLD */

  
/* Always initialise mpi by this call before using any mpi functions. */
    MPI_Init(&argc, &argv);
    
/* Find out how many processors are taking part in the computations.  */  
    MPI_Comm_size(MPI_COMM_WORLD, &numlabs); 

/* Get the rank of the current process */      
    MPI_Comm_rank(MPI_COMM_WORLD, &labindex);

    nnepp=ne/numlabs;
    startne=1+(labindex-1)*nnepp;
  
  if(labindex==numlab)
    finishne=ne;  
  else
    finishne=startne+nnepp;

  for(i=0;i<ne;i++)
  	sumouter[i]=0;
  totsum=0;
  //sigma=0;

  //outer loop integration over r
  double wall_time = MPI_Wtime();
 
 for( nec=startne;nec<=finishne;nec++)
{
    e=nec*0.0005;
    k=sqrt(2*m*e)/hb;
    totsum=0;
  //sigma=0;
  
  for(i=0;i<nr;i++)
	for(j=0;j<lupper+1;j++)
	{
		u1[i][j]=0;
		u2[i][j]=0;
		u3[i][j]=0;
	} 

  for j=1:nr,
    
    u1=0;
    //inner loop summation over l
    sumdelta=0;
    for(i=0;i<=lupper;i++)
    {   
      if( j == 1) //then
      {
        u1[j][i+1]=.1;
        u2[j][i+1]=pow(delta,(i+1));
      }
      else
      {
        u2[j][i+1]=u3[j-1][i+1];
        u1[j][i+1]=u2[j-1][i+1];
      }
      
      u3[j][i+1]=numerov(u1[j][i+1],u2[j][i+1],i,3.1+j*delta,delta,e,sigma,epsilon);
      //res=tdl(u1(j,i+1),u2(j,i+1),j*delta,(j+1)*delta,i,k);
      //cosecdelta2=((1/(res^2))+1);
      //sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
    }//end //end i=0 lupper
    //sumouter(j)=((4*pi)/(k^2))*sumdelta;
    //totsum=totsum+sumouter(j);
  }//end of j=1:nr loop
  
 
     for i=0:lupper,   
     {     
       res=tdl(u2[nr-2][i+1],u2[nr-1][i+1],(nr-1)*delta,(nr)*delta,i,k);
       cosecdelta2=((1/(pow(res,2)))+1);
       sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
     }//end

    sumouter[nec]=((4*pi)/(pow(k,2)))*sumdelta;
    totsum=totsum+sumouter[nec];
    
  } //endof parallel for loop over energy values
  
  if(labindex ==0)
   {
       for(i=1;i<numlabs;i++)
       {
        startne=1+(i-1)*nnepp;
        if(i==numlabs)
            finishne=ne;  
        else
            finishne=startne+nnepp;
        //end
  	//MPI_Recv(  &dparams , 2 , MPI_FLOAT , 0 , 0 ,MPI_COMM_WORLD,&status);
	MPI_Recv(  &(sumouter[startne]) , finishne-startne , MPI_FLOAT , i , 0 ,MPI_COMM_WORLD,&status);
       //sumouter(startne:finishne,1)=labReceive(i)
       }//end
   }
  else
   {
     //MPI_Ssend( &dparams , 2 , MPI_FLOAT , i , 0 , MPI_COMM_WORLD);
	MPI_Ssend( &(sumouter[startne]) , finishne-startne, MPI_FLOAT , 0 , 0 , MPI_COMM_WORLD);
      //labSend(sumouter(startne:finishne,1),1);
   }//end
  //sumouter=gather(dsumouter);
      wall_time = MPI_Wtime() - wall_time;
     if (labindex == 0)
	  printf("\n Wall clock time = %f secs\n", wall_time);
     MPI_Finalize(); 
  return 0;
 }

float v(float r,float sigma,float epsilon)
{
	float fv;
        //%epsilon=5.9;%meV H-Kr interaction
        //%sigma=3.57;%Angstrom
        fv=10*epsilon*( pow((sigma/r),12)-2*pow((sigma/r),6));
	return fv;
}

float f(int l,float r,float e,float sigma,float epsilon)
{
	float ff;
	//global m
	//global hb

	//ra=r*(10^(-10));
  	ff=v(r,sigma,epsilon)+((hb*hb)/(2*m*r*r))-e;	
	return ff;
}



//solve radial wave equation using numerov 
//predictor method to fourth order 
//for 2nd order de's

float numerov(float u1,float u2,int l,float r,float delta,float e,float sigma,float epsilon)
{
	float fnumerov;


  	float num1=1/(1-(pow(delta,2)/12)*f(l,r+delta,e,sigma,epsilon));
  	float bracket1=2*u2-u1+(pow(delta,2)/12)*(10*f(l,r,e,sigma,epsilon)*u2+f(l,r,e,sigma,epsilon)*u1);
  	fnumerov=num1*bracket1;

	return fnumerov;
}

//calculate phase shift of partial waves tand deltl
float tdl(float u1,float u2,float r1,float r2,int l,int k)
{
	float ftdl=0;
   
   	float kk=(r1*u1)/(r2*u2);
 	//float tdl=(kk*besselj(l,k*r1)-besselj(l,k*r2))/(kk*bessely(l,k*r1)-bessely(l,k*r2));
	return ftdl;
}
