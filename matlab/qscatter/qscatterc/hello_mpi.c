/**********************************************************************
 *
 *   This is the first mpi example program that
 *  outputs 'Hello World'  from all the processors.
 * Note: A copy of this program will be running on 
 *        all the processors.
 *    
 *
 *********************************************************************/

#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    int rank;		/* my rank in MPI_COMM_WORLD */
    int size;		/* size of MPI_COMM_WORLD */
    
/* Always initialise mpi by this call before using any mpi functions. */
    MPI_Init(&argc, &argv);
    
/* Find out how many processors are taking part in the computations.  */  
    MPI_Comm_size(MPI_COMM_WORLD, &size); 

/* Get the rank of the current process */      
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0) {
       printf("Hello MPI world from C!\n");
    }

    printf("There are %d processes in my world, and I have rank %d\n",
           size, rank);

    MPI_Finalize();
}                                     
