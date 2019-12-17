#=
        Constants for the problem, just change nb_teams, the others depend on it
=#
const nb_teams = 10
const nb_weeks = nb_teams - 1
const nb_periods = div(nb_teams, 2)

# For better readability, we will use a tables constaining the variables
nb_var = (nb_teams * nb_weeks * nb_periods)
variables = reshape(1:nb_var, nb_teams, nb_weeks, nb_periods)

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
        println("WEEK n°", w)
        for t in 1:nb_teams
            for p in 1:nb_periods
                if tables[t,w,p] == variables[t,w,p]
                    println("Team n°", t, " play during period : ", p)
                end
            end
        end
        println()
        println()
    end
    close(file)
end

read_results("res.res")
