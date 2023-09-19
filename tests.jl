# Routine to execute some tests

include("src\\data_regression_tools.jl")

# Linear regression

function test_linearRegression()

    # Sets x and y vectors

    x = [1; 2; 3; 4; 5]

    x = x + (0.1*randn(5))

    y = [1; 4; 6; 8; 10]

    y = y + (0.1*randn(5))

    # Calls the method and sets the optional argument to plot the data 
    # and the model

    regress_model(x, y, "linear", flag_plot=true)

end

# Quadratic regression

function test_quadraticRegression()

    # Sets x and y vectors

    x = [1; 2; 3; 4; 5]

    x = x + (0.1*randn(5))

    y = [1; 4; 6; 8; 10]

    y = y + (0.1*randn(5))

    # Calls the method and sets the optional argument to plot the data 
    # and the model

    regress_model(x, y, "quadratic", flag_plot=true)

end