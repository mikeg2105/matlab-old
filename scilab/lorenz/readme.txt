//Notes for lorenz
//exec lorenz

//set values in lorenz_drv
//e.g.
  //in(1)=10  //p
  //in(2)=25   //r
  //in(3)=2.66667    //b
  //in(4)=0  //x
  //in(5)=1    //y
  //in(6)=0    //z

//Another interesting set
//in(1)=10  //p
  //in(2)=160   //r
  //in(3)=2.66667    //b
  //in(4)=0  //x
  //in(5)=1    //y
  //in(6)=0    //z


//exec lorenz_drv
//sm=plotmodel();

//convert output matrix to vectors for x,y,z,t
//remebering to perform transpose operation using
//the ' operator

//x=sm(1, : )';
//y=sm(2, :)';
//z=sm(3, :)';
//t=sm(4, :)';
//2000 steps
//save the vrml  output
//savexyzvrml('filename.wrl', 2000, x, y, z, t);

