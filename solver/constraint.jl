#---------------------------------------------
# Name : constraint.jl
# Description : This file contains all the functions
# and types used to define constraints
# Authors : moi et al
#---------------------------------------------
"""
    all_diff_filtering(m,variable)

Filtering function for all_diff constraint on variables
of Model m
"""
function all_diff_filtering(m::Model, variables::Vector{String})
    for i in 1:length(variables)
        var1 = m.variables[variables[i]]
        for j in i+1:length(variables)
            var2 = m.variables[variables[j]]
            
            setdiff!(var1.max, var2.min)
            var1.max_card = min(var1.max_card, length(setdiff( var1.universe, var2.min )) )

            setdiff!(var2.max, var1.min)
            var2.max_card = min(var2.max_card, length(setdiff( var2.universe, var1.min )) )
        end
    end
end


"""
    all_diff

Constraint's subtype all_diff
"""
mutable struct all_diff <: Constraint
    var_index::Vector{String}
    filtering_function::Function

    all_diff(variables::Vector{String}) = new(
        variables,
        all_diff_filtering
    )
end

"""
    filter!(m, constraint)

Generic fitering function used for all constraints
"""
function filter!(m::Model, constraint::Constraint)
    constraint.filtering_function(m::Model, constraint.var_index)
end

"""
    empty_intersection_filtering(m, Variables)

Filtering function for the empty_intersection constraint
"""
function empty_intersection_filtering(m::Model, variables::Vector{String})
    if length(variables) == 2
        var1 = m.variables[variables[1]]
        var2 = m.variables[variables[2]]
        setdiff!(var1.max, var2.min)
        var1.max_card = min(var1.max_card, length(setdiff( var1.universe, var2.min )) )

        setdiff!(var2.max, var1.min)
        var2.max_card = min(var2.max_card, length(setdiff( var2.universe, var1.min )) )
    else
        error("Constraint defined beetween two Variables only, use Alldiff instead")
    end
end

"""
    empty_intersection

Constraint's subtype empty_intersection
"""
struct empty_intersection <: Constraint
    var_index::Vector{String}
    filtering_function::Function

    empty_intersection(variables::Vector{String}) = new(
        variables,
        empty_intersection_filtering
    )
end

"""
    include_in_filtering(m, variables)

Filtering function for the include_in constraint
"""
function include_in_filtering(m::Model, vars::Vector{String})
    if length(vars) == 2
        var1 = m.variables[vars[1]]
        var2 = m.variables[vars[2]]

        var1.max = Base.intersect(var1.max, var2.max)
        var2.min = Base.union(var1.min, var2.min)
        var2.min_card = max(var2.min_card, length(var2.min))
        var1.max_card = min(var1.max_card, length(var1.max))
    else
        error("Constraint defined beetween two Variables only, use Alldiff")
    end
end

"""
    include_in

COnstraint's subtye include_in
"""
struct include_in <: Constraint
    var_index::Vector{String}
    filtering_function::Function

    include_in(variables::Vector{String}) = new(
        variables,
        include_in_filtering
    )
end

"""
    Redefining the basic print and println function for include_in constraint
"""
function Base.show(io::IO, constraint::include_in)
    show(io, constraint.var_index[1])
    print(io, " include in ")
    show(io, constraint.var_index[2])
end
