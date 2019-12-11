#=
        Constants for the problem, just change nb_teams, the others depend on it
=#
const nb_teams = 8
const nb_weeks = nb_teams - 1
const nb_periods = div(nb_teams, 2)

#= Numbers of variables and number of clauses =#
nb_var = (nb_teams * nb_weeks * nb_periods)
nb_combi = (nb_teams * nb_teams * nb_weeks * nb_periods)
nb_clauses = ((nb_teams * nb_weeks) + (nb_teams * nb_weeks * sum(1:nb_periods-1)))
nb_clauses = nb_clauses + (nb_periods*nb_weeks*nb_teams) + (nb_periods*nb_weeks* binomial(nb_teams, 3))
nb_clauses = nb_clauses + (nb_teams * nb_periods) + (nb_teams * nb_periods * binomial(nb_weeks, 3))
nb_clauses = nb_clauses + binomial(nb_teams, 2) + (binomial(nb_teams, 2) * nb_weeks * nb_periods * 3)

# For better readability, we will use a tables constaining the variables
variables = reshape(1:nb_var, nb_teams, nb_weeks, nb_periods)
matchs = reshape(nb_var+1:(nb_var+nb_combi), nb_teams, nb_teams, nb_weeks, nb_periods)

"""
    function creator_sat()

    Will create a file sts.cnf which contains all the clauses of the problem
"""
function create()
    file = open("sts.cnf", "w")         # Open file in writting mode
    write(file, "c SAT version for STS problem\n")  # Comments
    write(file, "c Authors : Killian Fretaud, Rémi Garcia, Benoit Loger, Boualem Lamraoui, Benoît Le Badezet\n")  #Comments
    write(file, "p cnf ", string(nb_var + nb_combi -1), " ", string(nb_clauses), "\n") # Spécifications du problème

    #Constraint 1 : Each teams plays only once per weeks
    for t in 1:nb_teams
        for w in 1:nb_weeks
            for p in 1:nb_periods
                write(file, string(variables[t,w,p]), " ")
            end
            write(file, " 0\n")
            for p in 1:nb_periods-1
                for p2 in p+1:nb_periods
                    write(file, "-", string(variables[t,w,p]), " -", string(variables[t,w,p2]), " 0\n")
                end
            end
        end
    end

    #Constraint 2 : Only two teams by periods
    for w in 1:nb_weeks
        for p in 1:nb_periods
            for t in 1:nb_teams
                for t2 in 1:nb_teams
                    if t != t2
                        write(file, string(variables[t2,w,p], " "))
                    end
                end
                write(file, "0\n")
            end
            for t in 1:nb_teams-2
                for t2 in t+1:nb_teams-1
                    for t3 in t2+1:nb_teams
                        write(file, "-", string(variables[t,w,p]), " -", string(variables[t2,w,p]), " -", string(variables[t3,w,p]), " 0\n")
                    end
                end
            end
        end
    end

    #constraint 3 : Each teams plays at most two times in the same period
    for t in 1:nb_teams
        for p in 1:nb_periods
            for w in 1:nb_weeks
                write(file, string(variables[t,w,p]), " ")
            end
            write(file, "0\n")
            for w in 1:nb_weeks-2
                for w2 in w+1:nb_weeks-1
                    for w3 in w2+1:nb_weeks
                        write(file, "-", string(variables[t,w,p]), " -", string(variables[t,w2,p]), " -", string(variables[t,w3,p]), " 0\n")
                    end
                end
            end
        end
    end

    #Constraint 4: Each team plays angainst all other teams
    for t in 1:nb_teams-1
        for t2 in t+1:nb_teams
            s = ""
            for w in 1:nb_weeks
                for p in 1:nb_periods
                    write(file, "-", string(variables[t,w,p]), " -", string(variables[t2,w,p]), " ", string(matchs[t,t2,w,p]), " 0\n")
                    write(file, string(variables[t,w,p]), " -", string(matchs[t,t2,w,p]), " 0\n")
                    write(file, string(variables[t2,w,p]), " -", string(matchs[t,t2,w,p]), " 0\n")
                    s = s*string(matchs[t,t2,w,p])*" "
                end
            end
            write(file, s, "0\n")
        end
    end


    close(file)
end

"""
    function read_results(file_name::String)

    Will displays the results contained in the file file_name, in a readable way
"""
function read_results(file_name::String)
    results = Vector{Int}(undef,nb_var)
	file = open(file_name, "r")

	lines = readlines(file)
	if lines[1] == "SAT" || lines[1] == "sat"
		lines = split(lines[2]," ")
		for i in 1:nb_var
			results[i]=parse(Int,lines[i])
		end
    end
    tables = reshape(results, nb_teams, nb_weeks, nb_periods)
    for w in 1:nb_weeks
        println("WEEK n°: ", w)
        for t in 1:nb_teams
            for p in 1:nb_periods
                if tables[t,w,p] == variables[t,w,p]
                    println("Team n°", t, " play during period :", p)
                end
            end
        end
        println()
        println()
    end
    close(file)
end
