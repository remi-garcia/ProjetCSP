#---------------------------------------------
# Name : main.jl
# Description : main file used to test the solver
# Authors : moi et al
#---------------------------------------------
include("struct.jl")
include("variable.jl")
include("model.jl")
include("constraint.jl")

const U = [1,2]

"""
    Attention ce solver n'est absolument pas exent de bug ou de code à la con,
    il n'est pas optimisé et j'ai pas pris le temps de tout commenter.
    Je ferais ça tout à l'heure
"""
function test()
    # Initilise an empty model
    m = Model()

    # Initialise Set_Variables
    add_variables(m, "x", 1:9, Set{Int}(), Set(U), 1, 1, U)
    add_variable(m,"y",1, Set{Int}(), Set(U),0,0,U)

    # Initilise constraints
    #=add_constraint(m, empty_intersection(["x[1]","x[2]"]))
    add_constraint(m, empty_intersection(["x[1]","x[3]"]))
    add_constraint(m, empty_intersection(["x[2]","x[3]"]))=#
    add_constraint(m, all_diff(["x[1]","x[2]","x[3]"]))
    add_constraint(m, all_diff(["x[4]","x[5]","x[6]"]))
    add_constraint(m, all_diff(["x[7]","x[8]","x[9]"]))
    add_constraint(m, all_diff(["x[1]","x[4]","x[7]"]))
    add_constraint(m, all_diff(["x[2]","x[5]","x[8]"]))
    add_constraint(m, all_diff(["x[3]","x[6]","x[9]"]))




    # Supose to solve the model if possible
    solve!(m)

end
