#-------------------------------------------------------------------------------
# File: sat_encoding.jl
# Description: This file contains all the fuctions needed read sat results
# provided by minisat
# Date: December 10, 2019
# Author: Killian Fretaud, Rémi Garcia,
#         Boualem Lamraoui, Benoît Le Badezet, Benoit Loger
#-------------------------------------------------------------------------------

const g, p, w = 2,2,3

"""
    read_sat_results(file_name)

Read minisat results from "file_name" and print the corresponding SGP
solution in the REPL
"""
function read_sat_results(file_name::String)
    q = p*g
    nb_var = q*p*g*w
    results = Vector{Int}(undef,nb_var+1)
	open(file_name) do f
		lines = readlines(f)
		if lines[1] == "SAT" || lines[1] == "sat"
			lines = split(lines[2]," ")
			for i in 1:size(lines,1)
				results[i]=parse(Int,lines[i])
			end
        end
    end

    for week in 1:w
        println(" Week ", week)
        for group in 1:g
            print("Group ", group, " : ")
            for position in 1:p
                for player in 1:q
                    var = (week-1)*(q*p*g) + (group-1)*(q*p) + (position-1)*(q) + player
                    if results[var] > 0
                        print(Int(int_to_var(results[var])[4]) ," ")
                    end
                end
            end
            println()
        end
    end
end


function int_to_var(value::Int)
    q = p * g
    w_var = ceil(value/(q*p*g))
    g_var = ceil( (value-(w_var-1)*(q*p*g)) / (q*p) )
    p_var = ceil( ((value-(w_var-1)*(q*p*g))-(g_var-1)*(q*p)) / (q) )
    q_var = ((value-(w_var-1)*(q*p*g))-(g_var-1)*(q*p)) - (p_var-1)*q
    return w_var, g_var, p_var, q_var
end

read_sat_results("res.res")
