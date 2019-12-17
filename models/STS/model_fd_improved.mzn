include "globals.mzn";

int: n_teams;
int: n_weeks = n_teams - 1;
int: n_periods = n_teams div 2;

constraint 2*n_periods = n_teams;

% --- Variables --- %
% periods[i,j] : correspond à la periode durant laquelle se jouera le match de l'équipe j, la semaine i.
array[1..n_weeks, 1..n_teams] of var 1..n_periods: periods;

% --- Contraintes --- %
% Chaque équipe joue une fois par semaine (Contrainte induite par les variables.)

% Chaque période ne regroupe que deux équipes
constraint forall(i in 1..n_weeks, k in 1..n_periods)(count_eq(periods[i,1..n_teams],k,2));

% Chaque équipe joue au plus 2 fois dans la même période
constraint forall(j in 1..n_teams, k in 1..n_periods)(count(periods[1..n_weeks,j],k)<= 2);

% Chaque équipe affronte toute les autres
constraint forall(i in 1..n_teams-1, j in i..n_teams)(sum(k in 1..n_weeks)(bool2int(periods[k,i] == periods[k,j])) >= 1);


% --- Cassage de Symétries --- %
% Tentative 1 : On fixe la prmière journée : t1 vs t2 puis t3 vs t4 ... puis t(n-1) vs tn
constraint forall(j in 1..n_teams)(periods[1,j] = ((j+1) div 2));


solve satisfy;
% Affichage des périodes pour chacune des équipes.
output["Equipe \(i) : " ++ show(periods[1..n_weeks,i]) ++ " \n" | i in 1..n_teams];
