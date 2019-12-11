#-------------------------------------------------------------------------------
# File: sat_encoding.jl
# Description: This file contains all the fuctions needed read sat results
# provided by minisat
# Date: December 10, 2019
# Author: Killian Fretaud, Rémi Garcia,
#         Boualem Lamraoui, Benoît Le Badezet, Benoit Loger
#-------------------------------------------------------------------------------

const p, g, w = 4,4,4

function read_sat_results()
    q = p*g
    nb_var = q*p*g*w
    ss = Vector{Int}(undef,nb_var+1)
	open("/home/benoit/Bureau/test.out") do f
		s = readlines(f)
		println(s[1])
		if s[1] == "SAT" || s[1] == "sat"
			s = split(s[2]," ")
			for i in 1:size(s,1)
				ss[i]=parse(Int,s[i])
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
                    if ss[var] > 0
                        print(Int(int_to_var(ss[var])[4]) ," ")
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

read_sat_results()
