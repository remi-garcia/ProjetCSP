int: n_groups;
int: n_per_group;
int: n_rounds;

int: n_golfers = n_groups * n_per_group;

include "at_most.mzn";
include "count_eq.mzn";

% --- Variables --- %
% groups : groupe associé à chaque golfer pour chaque round / variables stockées dans un tableau, i les rounds, j les golfers
array[1..n_rounds, 1..n_golfers] of var 1..n_groups: groups;

% --- Contraintes --- %
% Chaque golfer ne peut être que dans un groupe chaque round --> induit par les variables

% Chaque groupe a exactement `n_per_group` golfers
constraint forall(i in 1..n_rounds, j in 1..n_groups)(count_eq(groups[i,1..n_golfers],j,n_per_group));

% Chaque golfer ne peut être avec un autre golfer dans le même groupe qu'une unique fois (au plus)
constraint forall(i in 1..n_golfers, j in 1..n_golfers)(sum(k in 1..n_rounds where i != j)(bool2int(groups[k,i] == groups[k,j])) <= 1);

% Fixer le premier golfer toujours au même groupe (1)
%constraint forall(i in 1..n_rounds)(groups[i,1] = 1);
%constraint forall(j in 2..n_golfers)(at_most(1,groups[1..n_rounds,j],1));

 constraint
  % Symetry breaking by group assignement
  % The first golfer always plays in group 1
  % On the first round, the first n_per_group golfers play in group 1, the 
  % second groupSize golfers play in group 2, etc. 
  % On the second round golfer 2 play in group 2, golfer 3 in group 3, etc etc
  % till golfer number n_per_group
  forall(r in 1..n_rounds)(
    groups[r,1] = 1
  )
  /\
  forall(g in 1..n_golfers) (
    groups[1,g]=((g-1) div n_per_group) + 1
  )
  /\
  forall(g in 2..n_golfers where g <= n_per_group)(
    groups[2,g]=g
  )
;

solve satisfy;

 output [
    "Round \(i) : " ++ show(groups[i,1..n_golfers]) ++ " \n" | i in 1..n_rounds
]; 