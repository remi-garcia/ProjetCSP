#-------------------------------------------------------------------------------
# File: sat_encoding.jl
# Description: This file contains all the fuctions needed to encode
# an SGP instance into an SAT model.
# Date: December 10, 2019
# Author: Killian Fretaud, Rémi Garcia,
#         Boualem Lamraoui, Benoît Le Badezet, Benoit Loger
# TBH :  This was mostly inspired by "DOI 10.1007/s10479-015-1914-5"
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Genenarl Idea of the model :
# One boolean variable denoted g[q', p', g', w'] states if :
# player q' is the p'-th player of the group number g' of week w' or not

#-------------------------------------------------------------------------------
const p, g, w = 4,4,4


"""
    sat_modeling(p::Int, g::Int, w::Int)

Generate a SAT model (in CNF) of the SGP using the given parameter :
    _ p : number of players per group
    _ g : number of groups per week
    _ w : number of weeks considered

Output :
    A file containing the model in order to use a sat solver :
        _ Each line is a clause and is ended by a "0"
        _ Each boolean variable is denoted by a Integer in [ 1 , (q*p*g*w) ] (with q the total number of players)
        _ positives values "i" states for "i"
        _ negatives values "-i" states for "NOT(i)"

Example : (x1 v NOT(x5) v x4 v x1) AND (NOT(x1) v x5 v x3 v x4)
    1 -5 4 0
    -1 5 3 4 0
"""
function sat_modeling()
    q = g * p # q denote the total number of players
    println(" Encoding Model ", w ," weeks ", g, " groups ", p, " players per groups " )
    println(" Total number of player : ", q)
    println(" Total number of variable : ", q*p*g*w)
    nb_clause = 0
    # Writting in the file
    open("/home/benoit/Bureau/test.in","w") do f

        # Each golfer plays once a week
        for q_var in 1:q, w_var in 1:w
            clause = ""
            for p_var in 1:p, g_var in 1:g
                clause = clause*string( var_to_int(q_var, p_var, g_var, w_var)," " )
            end
            clause = clause*"0\n"
            write(f,clause)
            nb_clause += 1
        end

        for q_var in 1:q, w_var in 1:w, p_var in 1:p, g_var in 1:g
            for p_second in p_var+1:p
                clause = string( not(var_to_int(q_var, p_var, g_var, w_var))," ",not(var_to_int(q_var, p_second, g_var, w_var))," 0\n")
                write(f,clause)
                nb_clause += 1
            end
        end

        for q_var in 1:q, w_var in 1:w, p_var in 1:p, g_var in 1:g
            for g_second in g_var+1:g, p_second in p_var+1:p
                clause = string( not(var_to_int(q_var, p_var, g_var, w_var))," ",not(var_to_int(q_var, p_second, g_second, w_var))," 0\n")
                write(f,clause)
                nb_clause += 1
            end
        end

        # Groups are correct
        for w_var in 1:w, p_var in 1:p, g_var in 1:g
            clause = ""
            for player in 1:q
                clause = clause*string(var_to_int(player, p_var, g_var, w_var)," " )
            end
            clause = clause*"0\n"
            write(f,clause)
            nb_clause += 1
        end

        for w_var in 1:w, p_var in 1:p, g_var in 1:g, player in 1:q
            for player_second in player+1:q
                clause = string( not(var_to_int(player, p_var, g_var, w_var))," ",not(var_to_int(player_second, p_var, g_var, w_var))," 0\n")
                write(f,clause)
                nb_clause += 1
            end
        end

        # Socialization constraint
        for w_var in 1:w, g_var in 1:g
            for w_second in w_var+1:w, g_second in 1:g, player in 1:q, p1_var in 1:p, p1_second in 1:p
                for player_second in player+1:q, p2_var in 1:p, p2_second in 1:p
                        clause = string( not(var_to_int(player, p1_var, g_var, w_var)), " ",not(var_to_int(player_second, p2_var, g_var, w_var)), " ",not(var_to_int(player, p1_second, g_second, w_second)), " ",not(var_to_int(player_second, p2_second, g_second, w_second)), " 0\n" )
                        write(f,clause)
                        nb_clause += 1
                end
            end
        end
    end
end

function not(variable::Int)
    return -variable
end

function var_to_int(q_var::Int, p_var::Int, g_var::Int, w_var::Int)
    q = g * p
    return q_var + (p_var-1)*(q) +  (g_var-1)*(q)*(p) + (w_var-1)*(q)*(p)*(g)
end
 sat_modeling()
