#---------------------------------------------
# Name : model.jl
# Description : This file contains all the functions
# we use to create and modify models
# Authors : moi et al
#---------------------------------------------
function add_variable(m::Model, new_variable::Variable)
    m.variables = merge(Dict(new_variable.id_var => new_variable),m.variables)
end

function add_variable(m::Model, name::String, index::Int, min::Set{Int}, max::Set{Int},card_min::Int, card_max::Int, univers::Array{Int,1})
    add_variable(m, Variable(name, index, min, max, card_min, card_max, univers))
end

function add_variables(m::Model, name::String, id_range::UnitRange{Int}, min::Set{Int}, max::Set{Int},card_min::Int, card_max::Int, univers::Array{Int,1})
    for index in id_range
        add_variable(m, Variable(name, index, Base.copy(min), Base.copy(max), card_min, card_max, univers))
    end
end

function add_constraint(m::Model, new_constraint::Constraint)
    push!(m.constraints, new_constraint)
end

function Base.show(io::IO, m::Model)
    println(io, "Variables :")
    for key in keys(m.variables)
        println(io, "   ",m.variables[key])
    end
    println(io,"")
    println(io, "Contraintes : ")
    for constraint in m.constraints
        println(io,"   ",constraint)
    end
end

function propagation!(m::Model)
    feasible = true
    for constraint in m.constraints
        filter!(m, constraint)
        for variable in constraint.var_index
            if !is_valid(m.variables[variable])
                feasible = false
                break
            end
        end
    end
    return feasible
end

function copy(m::Model)
    new_model = Model()
    new_model.variables = deepcopy(m.variables)
    new_model.constraints = deepcopy(m.constraints)
    return new_model
end

function solve!(m::Model)
    enumeration_list = Vector{Node}()
    push!(enumeration_list,Node(m))
    feasible = true
    found = false
    i = 1
    current_node = Node(m)
    while !found && length(enumeration_list) != 0
        found, current_node = enumeration(enumeration_list, found)
    end
    if found
        println(current_node.solution)
    else
        println("No solution found")
    end
end

function enumeration(enumeration_list::Vector{Node}, found::Bool)
    node = enumeration_list[length(enumeration_list)]
    deleteat!(enumeration_list,length(enumeration_list))
    feasible = propagation!(node.model)
    if feasible
        variable_filtering(node.model)
        if !(all_variable_fixed(node.model))
            selected , min_diff = find_min_diff(node.model)
            if selected != nothing
                difference = setdiff(node.model.variables[selected].max,node.model.variables[selected].min)
                for i in 1:min_diff
                    element = pop!(difference)
                    child_model = copy(node.model)
                    add_to_min(child_model.variables[selected], element)
                    push!(enumeration_list,Node(child_model))
                end
            end
        else
            println("Solution found")
            found = true
            println(node.model)
            enumeration_list = []
            set_solution(node)
        end
    end
    return found, node
end

function find_min_diff(m::Model)
    selected = nothing
    min_diff = Inf
    for var in keys(m.variables)
        if length(m.variables[var].min) < m.variables[var].max_card
            var_diff = length(m.variables[var].max) - length(m.variables[var].min)
            if var_diff < min_diff
                selected = var
                min_diff = var_diff
            end
        end
    end
    return selected, min_diff
end

function Base.:(==)(m1::Model, m2::Model)
    test = true
    for var in keys(m1.variables)
        test = test && m1.variables[var] == m2.variables[var]
    end
    return test
end

function is_correct(m::Model)
    test = true
    for var in keys(m.variables)
        test = test && is_correct(m.variables[var])
    end
    return test
end

function variable_filtering(m::Model)
    for var in keys(m.variables)
        self_filtering(m.variables[var])
    end
end

function all_variable_fixed(m::Model)
    test = true
    for var in keys(m.variables)
        test = test && m.variables[var].is_fixed
    end
    return test
end
