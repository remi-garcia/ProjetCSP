#---------------------------------------------
# Name : main.jl
# Description : main file used to test the solver
# Authors : moi et al
#---------------------------------------------
include("struct.jl")
include("variable.jl")
include("model.jl")
include("constraint.jl")

const n_group = 4
const n_per_group = 4
const n_week = 4

"""
    Attention ce solver n'est absolument pas exent de bug ou de code à la con,
    il n'est pas optimisé et j'ai pas pris le temps de tout commenter.
    Je ferais ça tout à l'heure
"""
function test()
    # Initilise an empty model
    m = Model()
    U = [i for i in 1:n_group*n_per_group]
    add_variables(m, "x",1:n_group*n_week,Set{Int}(),Set(U),n_per_group,n_per_group,U)
    #add_variables(m,"y",1:(n_group*n_week)^2,Set{Int}(),Set(U),0,1,U)

    for i in 1:n_week
        for j in 1:n_group
            for k in j+1:n_group
                add_constraint(m, empty_intersection([string("x[",(i-1)*n_week+j,"]"),string("x[",(i-1)*n_week+k,"]")]))
            end
        end
    end

    println(m)
    print_sgp(solve!(m))


end

function print_sgp(solution::Array{Tuple{String,Set{Int}},1})
    vars = Array{Set{Int},1}(undef,length(solution))
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
        vars[index] = solution[i][2]
    end
    for i in 1:n_week
        println("week : ",i)
        for j in 1:n_group
            println("   group ",j," : ",vars[(i-1)*n_week+j])
        end
    end
end
