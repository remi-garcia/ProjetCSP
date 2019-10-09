int: n_teams;
int: n_weeks = n_teams - 1;
int: n_periods = n_teams div 2;

constraint 2*n_periods = n_teams;

% --- Variables --- %
% slots : un slot correspond à un match, les slots sont stockés dans un tableau, i pour les semaines, j pour les périodes
array[1..n_weeks, 1..n_periods] of var set of 1..n_teams: slots;

% --- Contraintes --- %
constraint forall(i in 1..n_weeks, j in 1..n_periods)(card(slots[i, j]) = 2);
% Chaque équipe joue une fois par semaine (contrainte au plus qui fonctionne grâce à la contrainte précédente)
constraint forall(i in 1..n_weeks)(forall(j, k in 1..n_periods where j < k)(slots[i, j] intersect slots[i, k] subset {}));
% Chaque équipe joue au plus 2 fois dans la même période
constraint forall(i in 1..n_periods)(forall(j, k, l in 1..n_weeks where j < k /\ k < l)(slots[j, i] intersect slots[k, i] intersect slots[l, i] subset {}));
% Chaque équipe joue contre toutes les équipes - Chaque slot n'est présent qu'une unique fois
constraint forall(i, j in 1..n_weeks where i < j)(forall(k, l in 1..n_periods)(card(slots[i, k] union slots[j, l]) >= 3));

solve satisfy;