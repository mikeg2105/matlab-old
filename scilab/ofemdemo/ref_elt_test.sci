function [Eig_ref,Load_ref,Mat_ref] = ref_elt_test()
// Elts tests with SDT5.1

 st=makecell([1 20],'q4p','q8p','t3p','t6p',...
     'hexa8','hexa20','penta6','penta15',...
     'tetra4','tetra10','tria3','tria6',...
     'quad4','quadb','quad9','bar1','flui4',...
     'flui6','flui8','beam1');
 // missing: mitc4, , beam3, , celas , q5p, q9a ,'dktp',

Eig_ref = cell(28,2);
Load_ref = cell(28,2);
Mat_ref = cell(28,2);

Eig_ref(:,1)=makecell([28 1],...
    '[model,def]=q4p(''testeig_0'');',...
    '[model,def]=q4p(''testeig_1'');',...
    '[model,def]=q4p(''testeig_2'');',...
    '[model,def]=q8p(''testeig_0'');',...
    '[model,def]=q8p(''testeig_1'');',...
    '[model,def]=q8p(''testeig_2'');',...
    '[model,def]=t3p(''testeig_0'');',...
    '[model,def]=t3p(''testeig_1'');',...
    '[model,def]=t3p(''testeig_2'');',...
    '[model,def]=t6p(''testeig_0'');',...
    '[model,def]=t6p(''testeig_1'');',...
    '[model,def]=t6p(''testeig_2'');',...
    '[model,def]=hexa8(''testeig'');',...
    '[model,def]=hexa20(''testeig'');',...
    '[model,def]=penta6(''testeig'');',...
    '[model,def]=penta15(''testeig'');',...
    '[model,def]=tetra4(''testeig'');',...
    '[model,def]=tetra10(''testeig'');',...
    '[model,def]=tria3(''testeig'');',...
    '[model,def]=tria6(''testeig'');',...
    '[model,def]=quad4(''testeig'');',...
    '[model,def]=quadb(''testeig'');',...
    '[model,def]=quad9(''testeig'');',...
    '[model,def]=bar1(''testeig'');',...
    '[model,def]=flui4(''testeig'');',...
    '[model,def]=flui6(''testeig'');',...
    '[model,def]=flui8(''testeig'');',...
    '[model,def]=beam1(''testeig'');');

Eig_ref(:,2)=makecell([28 1],... // 5 first frequencies
    [4.290291308356445e+002    1.029468636991385e+003    1.231617703770857e+003 ...
    2.243426897960302e+003    2.623009060845864e+003],...
    [4.290291308356445e+002    1.029468636991385e+003    1.231617703770857e+003 ...
    2.243426897960302e+003    2.623009060845864e+003],...
    [4.290291308356445e+002    1.029468636991385e+003    1.231617703770857e+003 ...
    2.243426897960302e+003    2.623009060845864e+003],...
    [4.142427945181728e+002    1.026807469917128e+003    1.220302297159396e+003 ...
    2.184430056407337e+003    2.611028503198020e+003],...
    [4.142427945181728e+002    1.026807469917128e+003    1.220302297159396e+003 ...
    2.184430056407337e+003    2.611028503198020e+003],...
    [4.142427945181728e+002    1.026807469917128e+003    1.220302297159396e+003 ...
    2.184430056407337e+003    2.611028503198020e+003],...
    [4.320148932501105e+002    1.033057952114468e+003    1.277577946848218e+003 ...
    2.442645647088966e+003    2.726387923881986e+003],...
    [4.320148932501105e+002    1.033057952114468e+003    1.277577946848218e+003 ...
    2.442645647088966e+003    2.726387923881986e+003],...
    [4.320148932501105e+002    1.033057952114468e+003    1.277577946848218e+003 ...
    2.442645647088966e+003    2.726387923881986e+003],...
    [4.142816502365818e+002    1.026830998717464e+003    1.221167244359760e+003 ...
    2.187347803907836e+003    2.613847849438219e+003],...
    [4.142816502365818e+002    1.026830998717464e+003    1.221167244359760e+003 ...
    2.187347803907836e+003    2.613847849438219e+003],...
    [4.142816502365818e+002    1.026830998717464e+003    1.221167244359760e+003 ...
    2.187347803907836e+003    2.613847849438219e+003],...
    [2.369319824534588e+002    4.432948705364461e+002    4.441539199366413e+002 ...
    1.059701830480197e+003    1.333458699398739e+003],...
    [2.004436785427672e+002    4.123575690606958e+002    4.221692869112317e+002 ...
    1.034895970117207e+003    1.062616448050249e+003],...
    [2.260921850720664e+002    4.449924104312450e+002    4.825413497306591e+002 ...
    1.046548578081568e+003    1.263647980847690e+003],...
    [1.991636602919263e+002    4.105826286332820e+002    4.196672118522673e+002 ...
    1.032662583673201e+003    1.052152322938195e+003],...
    [2.330521328094594e+002    4.325465214140272e+002    4.878360332092557e+002 ...
    1.026220614384172e+003    1.152063012952191e+003],...
    [2.330521328094594e+002    4.325465214140272e+002    4.878360332092557e+002 ...
    1.026220614384172e+003    1.152063012952191e+003],...
    [6.280657063801294e+000    1.791959245732961e+001    4.994096519040203e+001 ...
    6.352001684174435e+001    7.733618138128993e+001],...
    'error tria6',...
    [6.346021934348538e+000    1.829010649608402e+001    5.729190849598430e+001 ...
    6.998476082340356e+001    8.617272848630813e+001],...
    [6.279510125347771e+000    1.777159655733382e+001    4.945133978014305e+001 ...
    6.374728975055643e+001    7.693504846998744e+001],...
    'error quad9',...
    [9.462764552681526e+001    3.305515251003152e+002    3.874255569492929e+002 ...
    6.663461886157351e+002    1.020312082890833e+003],...
    [1.128916716519793e+003    1.395677509724138e+003    1.395677509724340e+003 ...
    1.633056209189190e+003    2.108740158389825e+003],...
    [1.151386858774883e+003    1.385892352561525e+003    1.385892352561538e+003 ...
    1.592071311791083e+003    2.015182364725996e+003],...
    [1.137891192596138e+003    1.382144188142123e+003    1.382144188142126e+003 ...
    1.589291901269960e+003    2.091034987589612e+003],...
    [5.500532920947419e+000    1.692434891456080e+001    4.268331361883924e+001 ...
    6.374319296752912e+001    8.902604694376785e+001]);


Load_ref(:,1)=makecell([28 1],...
    '[model,def]=q4p(''testload_0'');',...  
    '[model,def]=q4p(''testload_1'');',...  
    '[model,def]=q4p(''testload_2'');',...  
    '[model,def]=q8p(''testload_0'');',...  
    '[model,def]=q8p(''testload_1'');',...  
    '[model,def]=q8p(''testload_2'');',...  
    '[model,def]=t3p(''testload_0'');',...  
    '[model,def]=t3p(''testload_1'');',...  
    '[model,def]=t3p(''testload_2'');',...  
    '[model,def]=t6p(''testload_0'');',...  
    '[model,def]=t6p(''testload_1'');',...  
    '[model,def]=t6p(''testload_2'');',...  
    '[model,def]=hexa8(''testload'');',...  
    '[model,def]=hexa20(''testload'');',... 
    '[model,def]=penta6(''testload'');',... 
    '[model,def]=penta15(''testload'');',...
    '[model,def]=tetra4(''testload'');',... 
    '[model,def]=tetra10(''testload'');',...
    '[model,def]=tria3(''testload'');',...  
    '[model,def]=tria6(''testload'');',...  
    '[model,def]=quad4(''testload'');',...  
    '[model,def]=quadb(''testload'');',...  
    '[model,def]=quad9(''testload'');',...  
    '[model,def]=bar1(''testload'');',...   
    '[model,def]=flui4(''testload'');',...  
    '[model,def]=flui6(''testload'');',...  
    '[model,def]=flui8(''testload'');',...  
    '[model,def]=beam1(''testload'');');

Load_ref(:,2)=makecell([28 1],... // norm of rhs (sum)
    [3.726779962499650e-001],...
    [3.726779962499650e-001],...
    [3.726779962499650e-001],...
    [2.991758226185836e-001],...
    [2.991758226185836e-001],...
    [1.449654510422562e+000],...
    [3.726779962499650e-001],...
    [3.726779962499650e-001],...
    [3.726779962499650e-001],...
    [2.991758226185836e-001],...
    [2.991758226185836e-001],...
    [2.991758226185836e-001],...
    [4.599044706869436e-001],...
    [7.428519928701292e-001],...
    [3.612545291956079e-001],...
    [4.207492800372717e-001],...
    [2.905776397546601e-001],...
    [2.905776397546601e-001],...
    [2.069139172231414e+000],...
    'error tria6',...
    [2.067877117114162e+000],...
    'error quadb',...
    'error quad9',...
    [1.108655439013544e-004],...
    'error flui4',...
    'error flui6',...     
    'error flui8',...     
    [7.499033124746842e-005]);

Mat_ref(:,1)=makecell([28 1],...
    'k=q4p(''testmat_0'');',...
    'k=q4p(''testmat_1'');',...
    'k=q4p(''testmat_2'');',...
    'k=q8p(''testmat_0'');',...
    'k=q8p(''testmat_1'');',...
    'k=q8p(''testmat_2'');',...
    'k=t3p(''testmat_0'');',...
    'k=t3p(''testmat_1'');',...
    'k=t3p(''testmat_2'');',...
    'k=t6p(''testmat_0'');',...
    'k=t6p(''testmat_1'');',...
    'k=t6p(''testmat_2'');',...
    'k=hexa8(''testmat'');',...
    'k=hexa20(''testmat'');',...
    'k=penta6(''testmat'');',...
    'k=penta15(''testmat'');',...
    'k=tetra4(''testmat'');',...
    'k=tetra10(''testmat'');',...
    'k=tria3(''testmat'');',...
    'k=tria6(''testmat'');',...
    'k=quad4(''testmat'');',...
    'k=quadb(''testmat'');',...
    'k=quad9(''testmat'');',...
    'k=bar1(''testmat'');',...
    'k=flui4(''testmat'');',...
    'k=flui6(''testmat'');',...
    'k=flui8(''testmat'');',...
    'k=beam1(''testmat'');');

Mat_ref(:,2)=makecell([28 1],... // First value of svd for K and M
    [3.102772713667655e+011    1.950000000000000e+003],...
    [3.800561035200435e+011    1.950000000000000e+003],...
    [1.612161301022247e+012    4.084070449666731e+003],...
    [9.823923670078130e+011    4.216337962957679e+003],...
    [1.162316292536501e+012    4.216337962957679e+003],...
    [6.010527746475593e+012    1.373459194188233e+004],...
    [3.560133726144175e+011    1.300000000000000e+003],...
    [4.368459515211880e+011    1.300000000000000e+003],...
    [1.272147901026296e+012    2.722713633111154e+003],...
    [1.063787654405139e+012    1.392418991184935e+003],...
    [1.265663701554579e+012    1.392418991184935e+003],...
    [4.092164186367988e+012    3.199395317077768e+003],...
    [2.441860355956611e+011    9.749999527819462e+002],...
    [6.330222443973812e+011    3.965718244950989e+003],...
    [2.430028333362581e+011    6.500000042119781e+002],...
    [8.514963709996585e+011    1.671081632270233e+003],...
    [1.859383657182347e+011    3.250000096857548e+002],...
    [4.307001902768686e+011    3.403025592105917e+002],...
    [3.560133726154119e+009    1.381337170886616e+001],...
    'error',...
    [2.937062937062937e+009    1.950000000000000e+001],...
    [5.798967689221895e+009    1.508165308406692e+001],...
    'error',...
    [1.319468914507713e+012    1.225221134900020e+004],...
    [9.958122890254858e-004    3.281073683617672e-011],...
    [6.763038603641406e-004    3.390173746379251e-011],...
    [5.000000000000000e-004    5.555555555555552e-011],...
    [8.017844029046270e+003    4.200000000000000e+012]); // beam1 new prop


if 1==2
 for j1=1:length(Mat_ref)
  if iscell(Mat_ref(j1,2).entries)
  [max(svd(Mat_ref(j1,2).entries(1))) max(svd(Mat_ref(j1,2).entries(2)))]
  else
   'error'
  end
 end
end //1==2
