# Routine to implement data regression for points in the plane (x,y). 
# The curve fitting and its parameters adjusting are treated as an opti-
# mization problem.

using LinearAlgebra

using Zygote

using Plots

using LaTeXStrings

using Statistics

########################################################################
#                            Data regression                           #
########################################################################

# Defines a function to do the regression. The data points are exclusi-
# vely in the x-y plane. Thus, a vector of x coordinates and a vector of
# y coordinates must be passed, as well as the name of the model used

function regress_model(x::Vector{Float64}, y::Vector{Float64},
 model_name::String; n_iterations=100000, tolerance_convergence=1E-6,
 flag_plot=false, n_digits=4, length_xPlot=1000, loss_type=loss_RMSE,
 optimizer_type=adam_optimizer)

    # Tests if x and y has the same size

    n_points = length(x)

    if n_points!=length(y)

        throw("The data points have different number of values for x "*
        "and for y dimensions\n")

    end

    # Gets the model's function and the length of the vector of its pa-
    # rameters

    model_type, length_parameters = get_model(model_name)

    # Initializes the coefficients for the model. They are stored in a
    # vector, the a coefficient in the first position and the coeffi-
    # cient b in the second one

    parameters = randn(length_parameters)

    # Creates a driver for the loss function

    loss(parameters) = loss_type(parameters, x, y, n_points, model_type)

    # Creates a driver for the gradient of the loss function

    grad_loss(parameters) = gradient(loss, parameters)[1]

    # Calculates the optimum point using ADAM method

    parameters = optimizer_type(parameters, grad_loss, size(parameters,1
     ), n_iterations=n_iterations, stop_tol=tolerance_convergence)

    # Creates a driver for the model with the adjusted parameters

    model_fit(x) = model_type(x, parameters)

    # Calculates the r-squared parameter

    r_squared = calculate_rSquared(x, y, model_fit, n_points)

    # If the points and the model are to be plotted

    if flag_plot

        # Plots the data points

        plot_regression = scatter(x, y, label=L"Data\;points",
         legend=:outertopright, title=latexstring("R^{2}="*string(
         round(r_squared, digits=n_digits))))

        # Creates a vector of points for the model that spans the whole
        # x range

        x_span = collect(range(start=minimum(x), stop=maximum(x),
         length=length_xPlot))

        # Evaluates the points using the model

        y_span = Float64[]

        for i=1:length_xPlot

            push!(y_span, model_fit(x_span[i]))

        end

        # Plots these 2 points

        plot!(plot_regression, x_span, y_span, label=L"\hat{y}")

        # Saves the plot

        savefig(plot_regression, ("plot_"*string(model_name)*"_regress"*
        "ion.pdf"))

    end

    # Returns the driver of the model and its parameters

    return model_fit, parameters

end

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

########################################################################
#                            Loss functions                            #
########################################################################

# Defines a function for the loss function using RMSE

function loss_RMSE(parameters, x, y, n_points, model_type)

    # Initializes the error

    error = 0.0

    # Iterates through the points of data

    for i=1:n_points

        # Adds the parcel of error

        error += ((y[i]-model_type(x[i], parameters))^2)

    end

    # Scales the error by the number of points and takes the square root

    error = sqrt(error/n_points)

    # Returns it

    return error

end

########################################################################
#                              Optimizers                              #
########################################################################

# Defines a function for the ADAM optimizer

function adam_optimizer(x, grad_function, dimensionality; stop_tol=1E-7,
 n_iterations=100000, alpha=1E-3, beta1=0.9, beta2=0.999, epsilon=1E-8)

    # Initializes m, v and t

    t = 0

    m_t = zeros(dimensionality)

    v_t = zeros(dimensionality)

    # Iterates through the given number of iterations

    for i=1:n_iterations

        # Updates t

        t += 1

        # Calculates the gradient

        g_t = grad_function(x)

        # Tests the norm of the gradient as stopping condition

        norm_grad = norm(g_t)

        if norm_grad<stop_tol

            println("The optimization procedure was stopped at iterati",
             "on ", i, ", with the norm of the gradient being ",
             norm_grad, "\n")

            break

        end

        # Calculates the moments, but allocates them in a vector that is
        # equal to the division between scaled m and the square root of
        # scaled v

        m_divV = Float64[]

        m_t = ((beta1*m_t)+((1-beta1)*g_t))

        for j=1:dimensionality

            v_t[j] = ((beta2*v_t[j])+((1-beta2)*(g_t[j]^2)))

            # Calculates the quotient

            push!(m_divV, (((1/(1-(beta1^t)))*m_t[j])/(sqrt((1/(1-(beta2
             ^t)))*v_t[j])+epsilon)))

        end

        # Updates the vector of design variables

        x = (x-(alpha*m_divV))

    end

    # Returns the last point

    return x

end

########################################################################
#                        Statistical parameters                        #
########################################################################

# Defines a function to calculate the r-squared coefficient for statis-
# tical evaluation

function calculate_rSquared(x_data, y_data, model_fit, n_points)

    # Calculates the mean of the known values of y

    y_mean = mean(y_data)

    # Initializes the summations (https://en.wikipedia.org/wiki/Coeffici
    # ent_of_determination)

    S_res = 0.0

    S_tot = 0.0

    # Iterates through the data points

    for i=1:n_points

        # Updates the sum of the residuals

        S_res += ((y_data[i]-model_fit(x_data[i]))^2)

        # Updates the sum of total, i.e., the sum of the difference bet-
        # ween each known value y and its mean

        S_tot += ((y_data[i]-y_mean)^2)

    end

    # Calculates and return r_squared

    return (1-(S_res/S_tot))

end