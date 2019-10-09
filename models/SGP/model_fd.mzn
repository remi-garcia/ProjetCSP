int: n_groups;
int: n_per_group;
int: n_rounds;

int: n_golfers = n_groups * n_per_group;

% --- Variables --- %
% groups : groupe associé à chaque golfer pour chaque round / variables stockées dans un tableau, i les rounds, j les golfers
array[1..n_rounds, 1..n_golfers] of var 1..n_groups: groups;

% --- Contraintes --- %
% Chaque golfer ne peut être que dans un groupe chaque round --> induit par les variables

% Chaque groupe a exactement `n_per_group` golfers
constraint forall(i in 1..n_rounds, k in 1..n_groups)(sum(j in 1..n_golfers)(bool2int(groups[i,j]==k)) == n_per_group);
% Chaque golfer ne peut être avec un autre golfer dans le même groupe qu'une unique fois (au plus)
constraint forall(i in 1..n_golfers, j in 1..n_golfers)(sum(k in 1..n_rounds where i != j)(bool2int(groups[k,i] == groups[k,j])) <= 1);
solve satisfy;

 output [
    "Round \(i) : " ++ show(groups[i,1..n_golfers]) ++ " \n" | i in 1..n_rounds
]; 