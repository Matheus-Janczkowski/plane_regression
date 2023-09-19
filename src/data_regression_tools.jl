# Routine to implement data regression for points in the plane (x,y). 
# The curve fitting and its parameters adjusting are treated as an opti-
# mization problem.

using LinearAlgebra

using Zygote

using Plots

using LaTeXStrings

using Statistics

include("models.jl")

include("loss_functions.jl")

include("optimizers.jl")

include("statistics_tools.jl")

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