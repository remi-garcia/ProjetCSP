int: n_groups;
int: n_per_group;
int: n_rounds;

int: n_golfers = n_groups * n_per_group;

% --- Variables --- %
% groups : groupes de golfeurs / variables stockées dans un tableau, i les rounds, j les groupes
array[1..n_rounds, 1..n_groups] of var set of 1..n_golfers: groups;

% --- Contraintes --- %
% Chaque golfeur ne peut être que dans un groupe chaque round
constraint forall(i in 1..n_rounds)(forall(j, k in 1..n_groups where j < k)(groups[i, j] intersect groups[i, k] subset {}));
% Chaque groupe a exactement `n_per_group` golfeurs
constraint forall(i in 1..n_rounds, j in 1..n_groups)(card(groups[i,j]) = n_per_group);
% Chaque golfeur ne peut être avec un autre golfeur dans le même groupe qu'une unique fois (au plus)
constraint forall(i, j in 1..n_rounds where i != j)(forall(k, l in 1..n_groups)(card(groups[i, k] intersect groups[j, l]) <= 1));

solve satisfy;


output [
   if (j mod n_groups) = 0 then "\nRound \(i) : "
   else " , " endif ++
   show(groups[i,(j mod n_groups) +1])
   |i in 1..n_rounds, j in 0..(n_groups-1)
];
