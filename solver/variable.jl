#---------------------------------------------
# Name : variable.jl
# Description : This file contains all the function
# that concerns Variables
# Authors : moi et al
#---------------------------------------------
function fix!(variable::Variable, new_fixed_value::Set{Int})
    if variable.is_fixed
        error("Trying to fix fixed variable", variable.id_var)
    else
        if length(new_fixed_value) > variable.max_card
            error("Failed to fix variable ", variable.id_var, " the card of the new value is too big")
        elseif length(new_fixed_value) < variable.min_card
            error("Failed to fix variable ", variable.id_var, " the card of the new value is too small")
        else
            variable.is_fixed = true
            variable.min = new_fixed_value
            variable.max = new_fixed_value
        end
    end
end

function add_to_min(variable::Variable, value::Int)
    push!(variable.min, value)
end

function is_valid(variable::Variable)
    test = true
    test = test && Base.intersect(variable.min, variable.max) == variable.min
    test = test && variable.min_card <= variable.max_card
    test = test && length(variable.max) >= variable.min_card
    test = test && length(variable.min) <= variable.max_card
    return test
end

function is_correct(variable::Variable)
    test = true
    test = test && Base.intersect(variable.min, variable.max) == variable.min
    test = test && variable.min_card <= variable.max_card
    test = test && length(variable.max) >= variable.min_card
    test = test && length(variable.min) <= variable.max_card
    test = test && length(variable.min) >= variable.min_card
    return test
end

function is_empty_set(variable::Variable)
    return isempty(variable.max)
end

function Base.show(io::IO, variable::Variable)
    seperate = ", "
    print(io, "Variable(")
    show(io, variable.id_var)
    print(seperate)
    show(io, variable.min)
    print(io, seperate)
    show(io, variable.max)
    print(io, seperate)
    show(io, variable.min_card)
    print(io, " <= card <= ")
    show(io,  variable.max_card)
    print(io, ")")
end

function Base.:(==)(var1::Variable, var2::Variable)
    egalite_min = (var1.min == var2.min)
    egalite_max = (var1.max == var2.max)
    egalite_card_min = (var1.min_card == var2.min_card)
    egalite_card_max = (var1.max_card == var2.max_card)
    return egalite_min && egalite_max && egalite_card_min && egalite_card_max
end

function self_filtering(var::Variable)
    if length(var.min) == var.max_card
        var.max = var.min
        var.is_fixed = true
    end
end
