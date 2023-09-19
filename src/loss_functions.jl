# Routine to store the loss functions

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