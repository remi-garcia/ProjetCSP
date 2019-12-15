mutable struct Variable
    global next_var_id = 0
    id_var::Int
    min::Set{Int}
    max::Set{Int}
    min_card::Int
    max_card::Int
    is_fixed::Bool
    fixed_value::Set{Int}

    function Variable(min::Set{Int}, max::Set{Int})
        next_var_id += 1
        new(
            next_var_id,
            min,
            max,
            length(min),
            length(max),
            false
        )
    end
end

function set_min(variable::Variable, new_min::Set)
    if length(new_min) > variable.min_card
        variable.min_card = length(new_min)
    elseif length(new_min) < variable.min_card
        error("Impossible min value setting for variable ", variable.id_var)
    end
    variable.min = new_min
end

function set_max(variable::Variable, new_max::Set)
    if length(new_max) < variable.max_card
        variable.max_card = length(new_max)
    elseif length(new_max) > variable.max_card
        error("Impossible max value setting for variable ", variable.id_var)
    end
    variable.max = new_max
end

function fix(variable::Variable, new_fixed_value::Set{Int})
    if variable.is_fixed
        error("Trying to fix fixed variable", variable.id_var)
    else
        if length(new_fixed_value) > variable.max_card
            error("Failed to fix variable ", variable.id_var, " the card of the new value is too big")
        elseif length(new_fixed_value) < min_card
            error("Failed to fix variable ", variable.id_var, " the card of the new value is too small")
        else
            variable.is_fixed = true
            variable.fixed_value = new_fixed_value
        end
    end
end
