#---------------------------------------------
# Name : struct.jl
# Description : This file contains all the type definition used in the project
# Authors : moi et al
#---------------------------------------------
mutable struct Variable
    name_var::String
    id_var::String
    min::Set{Int}
    max::Set{Int}
    min_card::Int
    max_card::Int
    universe::Array{Int,1}
    is_fixed::Bool
    fixed_value::Array{Int,1}

    function Variable(name::String, id::Int, min::Set{Int}, max::Set{Int}, card_min::Int, card_max::Int, univers::Array{Int,1})
        real_id = string(name,"[",id,"]")
        new(
            name,
            real_id,
            min,
            max,
            card_min,
            card_max,
            univers,
            false
        )
    end
end

abstract type Constraint

end

mutable struct Model
    variables::Dict{String,Variable}
    constraints::Array{Constraint,1}

    function Model()
        new(
            Dict{Int,Variable}(),
            Array{Constraint,1}(undef, 0)
        )
    end
end

mutable struct Node
    model::Model
    pruned::Bool
    solution::Array{Tuple{String,Set{Int}},1}

    Node(model::Model) = new(
        model,
        false
    )
end

function set_solution(n::Node)
    n.solution = [(var,n.model.variables[var].min) for var in keys(n.model.variables)]
end
