





#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int ns=1;
int isn[3]={48,480,4800};


int main(int argc, char *argv[])
{

  int nnepp, ne, finishne, startne;
  
  //int nsamples[3]={ns/isn[0],ns/isn[1], ns/isn[2]};
  int nsamples[3]={1,1, 1};
  double ***u;
  MPI_Status status;

  //initial matrix proc 0 only distributed and gathered
  double ***iu;

  int i,j,k,l;

  int labindex;		/* my rank in MPI_COMM_WORLD */
  int numlabs;		/* size of MPI_COMM_WORLD */
  double wall_time;
  
   u=(double ***)calloc(1,sizeof(double **));
   iu=(double ***)calloc(1,sizeof(double **));
/* Always initialise mpi by this call before using any mpi functions. */
    MPI_Init(&argc, &argv);
    
/* Find out how many processors are taking part in the computations.  */  
    MPI_Comm_size(MPI_COMM_WORLD, &numlabs); 

/* Get the rank of the current process */      
    MPI_Comm_rank(MPI_COMM_WORLD, &labindex);
    int *scounts=(int *)calloc(numlabs,sizeof(int));
    int *rcounts=(int *)calloc(numlabs,sizeof(int));
    int *disps=(int *)calloc(numlabs,sizeof(int));
    
    		//if(labindex==0)
    //for(j=0;j<1;j++)
		//{
		j=0;
                        iu[j]=(double **)calloc(isn[j],sizeof(double *));
			for(k=0;k<isn[j];k++)
				iu[j][k]=(double *)calloc(isn[j],sizeof(double));
			for(k=0;k<isn[j];k++)
				for(l=0;l<isn[j];l++)
                                   		iu[j][k][l]=-1;
                     ne=isn[j];   
                   nnepp=ne/numlabs;     
                             u[j]=(double **)calloc(isn[j],sizeof(double *));
		for(k=0;k<nnepp;k++)
			u[j][k]=(double *)calloc(isn[j],sizeof(double));
 		
           
                        
		//} 
    j=0;
    printf("matrixcreated on %d\n", labindex);
   
    
    
   // for(j=0;j<3;j++)
	//{
j=0;
        wall_time = MPI_Wtime();
    		ne=isn[j];
		//prepare the matrices
		nnepp=ne/numlabs;
    		//startne=1+(labindex-1)*nnepp;
		startne=(labindex)*nnepp;
//for(k=0;k<nsamples[j];k++)
	//{
  	MPI_Bcast(iu,1*isn[j]*isn[j],MPI_DOUBLE,0,MPI_COMM_WORLD);
        for(i=0;i<numlabs;i++)
        {
            scounts[i]=nnepp*isn[j];
            rcounts[i]=nnepp*isn[j];
            disps[i]=nnepp*isn[j];
        }
        
        MPI_Barrier(MPI_COMM_WORLD);
        printf("matrixcreated and bcasted on %d\n", labindex);
        
        
        
        
       printf("matrix broadcasted on %d\n", labindex);
        MPI_Barrier(MPI_COMM_WORLD);
        //MPI_Scatterv(iu[j],scounts,disps,MPI_DOUBLE,(void *)u[j],nnepp*isn[j],MPI_DOUBLE,0,MPI_COMM_WORLD);
       MPI_Scatter(iu[j],nnepp*isn[j],MPI_DOUBLE,(void *)u[j],nnepp*isn[j],MPI_DOUBLE,0,MPI_COMM_WORLD);
        MPI_Barrier(MPI_COMM_WORLD);
                printf("matrix scattered on %d\n", labindex);

        //do some calculations
        //MPI_Gatherv((void *)u[j],nnepp*isn[j],MPI_DOUBLE,iu[j],rcounts,disps,MPI_DOUBLE,0,MPI_COMM_WORLD);
        MPI_Gather((void *)u[j],nnepp*isn[j],MPI_DOUBLE,iu[j],nnepp*isn[j],MPI_DOUBLE,0,MPI_COMM_WORLD);
        printf("matrix gathered on %d\n", labindex);

//MPI_Barrier(MPI_COMM_WORLD);
//printf("matrix distributed on %d\n", labindex);
 

	
		//}//end of samples loop repeat 

                //compute average
//MPI_Barrier(MPI_COMM_WORLD);
      		wall_time = MPI_Wtime() - wall_time;
     		if (labindex == 0)
	  		printf("\n Wall clock time = %f %f secs\n", wall_time, wall_time/nsamples[j]);


	//} //end of matrix size loop 
     	MPI_Finalize(); 

  free(u);
  free(iu);
  free(scounts);
  free(rcounts);
  free(disps);
  return 0;
 }

