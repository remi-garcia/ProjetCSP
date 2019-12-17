int: n_groups;
int: n_per_group;
int: n_rounds;

int: n_golfers = n_groups * n_per_group;

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

 constraint
  % Cassage de symétrie par assignement de variable
  % Le premier golfer joue toujours dans le 1er groupe
  % Au premier round, les n_per_group premier golfers jouent dans le groupe 1,
  % les n_per_group suivant dans le 2eme etc etc.
  % Au second round le golfer 2 joue dans le groupe 2, le golfer 3 dans le groupe
  % 3, et ainsi de suite jusqu'au golfer n_per_group
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
