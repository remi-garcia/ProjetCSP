int: n_groups;
int: n_per_group;
int: n_rounds;

int: n_golfers = n_groups * n_per_group;

include "count_eq.mzn";

% --- Variables --- %
% groups : groupe associé à chaque golfeur pour chaque round / variables stockées dans un tableau, i les rounds, j les golfeurs
array[1..n_rounds, 1..n_golfers] of var 1..n_groups: groups;

% --- Contraintes --- %
% Chaque golfeur ne peut être que dans un groupe chaque round --> induit par les variables

% Chaque groupe a exactement `n_per_group` golfeurs
constraint forall(i in 1..n_rounds, j in 1..n_groups)(count_eq(groups[i,1..n_golfers],j,n_per_group));

% Chaque golfeur ne peut être avec un autre golfeur dans le même groupe qu'une unique fois (au plus)
constraint forall(i in 1..n_golfers, j in 1..n_golfers where i != j)(sum(k in 1..n_rounds)(bool2int(groups[k,i] == groups[k,j])) <= 1);

% Cassage de symétrie par assignement de variable
% Le premier golfeur joue toujours dans le 1er groupe
constraint forall(r in 1..n_rounds)(groups[r, 1] = 1);
% Au premier round, les n_per_group premier golfeurs jouent dans le groupe 1,
% les n_per_group suivant dans le 2eme etc etc.
constraint forall(g in 1..n_golfers)(groups[1, g]=((g-1) div n_per_group) + 1);
% Au second round le golfeur 2 joue dans le groupe 2, le golfeur 3 dans le groupe
% 3, et ainsi de suite jusqu'au golfeur n_per_group
constraint forall(g in 2..n_golfers where g <= n_per_group)(groups[2, g] = g);

solve satisfy;

 output [
    "Round \(i) : " ++ show(groups[i,1..n_golfers]) ++ " \n" | i in 1..n_rounds
]; 
