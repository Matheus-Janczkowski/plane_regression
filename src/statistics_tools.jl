# Routine to store functions for statistical analysis
   
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