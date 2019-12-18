#---------------------------------------------
# Name : main.jl
# Description : main file used to test the solver
# Authors : moi et al
#---------------------------------------------
include("struct.jl")
include("variable.jl")
include("model.jl")
include("constraint.jl")

const U = [1,2,3,4,5,6,7,8,9]
const l = 9

"""
    Attention ce solver n'est absolument pas exent de bug ou de code à la con,
    il n'est pas optimisé et j'ai pas pris le temps de tout commenter.
    Je ferais ça tout à l'heure
"""
function test()
    # Initilise an empty model
    m = Model()

    # Initialise Set_Variables
    add_variables(m, "x", 1:l*l, Set{Int}(), Set(U), 1, 1, U)

    # Initilise constraints
    for colonne in 0:l-1
        add_constraint(m, all_diff([string("x[",(colonne*l)+i,"]") for i in 1:l]))
    end
    for ligne in 1:l
        add_constraint(m, all_diff([string("x[",(i-1)*l+ligne,"]") for i in 1:l]))
    end

    constraint_matrix = [
        1 2 3 10 11 12 19 20 21
        4 5 6 13 14 15 22 23 24
        7 8 9 16 17 18 25 26 27
        28 29 30 37 38 39 46 47 48
        31 32 33 40 41 42 49 50 51
        34 35 36 43 44 45 52 53 54
        55 56 57 64 65 66 73 74 75
        58 59 60 67 68 69 76 77 78
        61 62 63 70 71 72 79 80 81
    ]
    for i in 1:l
        add_constraint(m, all_diff([string("x[",constraint_matrix[i,j],"]") for j in 1:l]))
    end
    #Pour tester le all_diff
    #add_constraint(m, all_diff([string("x[",(i),"]") for i in 1:l*l]))

    initial_sudoku =
    [
    0 2 0 0 0 0 0 0 0
    0 0 0 6 0 0 0 0 3
    0 7 4 0 8 0 0 0 0
    0 0 0 0 0 3 0 0 2
    0 8 0 0 4 0 0 1 0
    6 0 0 5 0 0 0 0 0
    0 0 0 0 1 0 7 8 0
    5 0 0 0 0 9 0 0 0
    0 0 0 0 0 0 0 4 0
    ]

    for i in 1:l
        for j in 1:l
            if initial_sudoku[i,j] != 0
                fix!(m.variables[string("x[",(i-1)*9+j,"]")],Set([initial_sudoku[i,j]]))
            end
        end
    end
    # Supose to solve the model if possible
    print_initial_matrix(initial_sudoku)
    println()
    print_sudoku(solve!(m))
    println()

end

function print_sudoku(solution::Array{Tuple{String,Set{Int}},1})
    vars = zeros(Int,length(solution))
    indexes = []
    value = []
    for i in 1:length(solution)
        var = solution[i][1]
        if length(var) == 5
            index_string = var[3:4]
        else
            index_string = var[3]
        end
        index = parse(Int,index_string)
        vars[index] = pop!(solution[i][2])
    end

    for i in 1:l
        println()
        for j in 1:l
            print(vars[(i-1)*l+j]," ")
        end
    end
end

function print_initial_matrix(initial)
    for i in 1:l
        println()
        for j in 1:l
            print(initial[i,j]," ")
        end
    end
end
