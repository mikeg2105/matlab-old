% Boundedrecint.m       (bounded RECombination extended INTermediate)
%
% This function performs extended intermediate recombination between
% pairs of individuals and returns the new individuals after mating.
%
% Syntax:  NewChrom = boundedrecint(OldChrom, XOVR, bounds)
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one
%                individual
%    XOVR      - Probability of crossover occurring between pairs
%                of individuals. (not used, only for compatibility)
%    bounds    - The bounds on the variables (optional)
%
% Output parameter:
%    NewChrom - Matrix containing the chromosomes of the population
%               after mating, ready to be mutated and/or evaluated,
%               in the same format as OldChrom.

%  Author:    Hartmut Pohlheim
%  History:   25.11.93     file created
%             06.12.93     change of name of function
%             25.02.94     clean up
%             19.03.94     multipopulation support removed
%             14.12.03     ability to use bounded variables added by Alex
%                          Shenfield

function NewChrom = boundedrecint(OldChrom, XOVR, bounds);

    % Identify the population size (Nind) and the number of variables (Nvar)
    [Nind,Nvar] = size(OldChrom);

    % Identify the number of matings
    Xops = floor(Nind/2);
   
    % Performs recombination
    odd = 1:2:Nind-1;
    even= 2:2:Nind;

    % position of value of offspring compared to parents
    Alpha = -0.25 + 1.5 * rand(Xops,Nvar);

    % recombination
    NewChrom(odd,:)  = OldChrom(odd,:) + Alpha .* (OldChrom(even,:) - OldChrom(odd,:));

    % the same ones more for second half of offspring
    Alpha = -0.25 + 1.5 * rand(Xops,Nvar);
    NewChrom(even,:) = OldChrom(odd,:) + Alpha .* (OldChrom(even,:) - OldChrom(odd,:));
   
    % If the number of individuals is odd, the last individual cannot be mated
    % but must be included in the new population
    if rem(Nind,2),  NewChrom(Nind,:)=OldChrom(Nind,:); end

    %NewChrom
    
    % If bounds are provided on the variables, the check if the new
    % individuals are within those bounds.  If they're not, then reset the
    % individuals to the boundary value.
    if nargin == 3
        for i = 1:Nind
            for j = 1:Nvar
                if NewChrom(i,j) < bounds(1,j)
                    NewChrom(i,j) = bounds(1,j);
                elseif NewChrom(i,j) > bounds(2,j)
                    NewChrom(i,j) = bounds(2,j);
                end
            end
        end
    end
    
        
% End of function
