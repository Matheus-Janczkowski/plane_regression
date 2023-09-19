# Routine to store the models and the function, get_model, that receives
# the string with the model type and automatically sets the dimensiona-
# lity of the model's set of parameters and the function to receive them

########################################################################
#                                Models                                #
########################################################################

# Defines a function that gives the number of parameters for each model
# and that returns the function to this model

function get_model(model_type)

    # If it is linear

    if model_type=="linear"

        return linear_model, 2

    # If it is quadratic

    elseif model_type=="quadratic"

        return quadratic_model, 3

    # Otherwise, if no registered model was found

    else

        throw("Model "*model_type*" was not found.")

    end

end

# Defines a function for the linear model

function linear_model(x_individual, parameters)

    return ((parameters[1]*x_individual)+parameters[2])

end

# Defines a function for the quadratic model

function quadratic_model(x_individual, parameters)

    return ((parameters[1]*(x_individual^2))+(parameters[2]*x_individual
     )+parameters[3])

end