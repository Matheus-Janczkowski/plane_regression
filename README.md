# plane_regression

1.1 Download

]add https://github.com/Matheus-Janczkowski/plane_regression/

1.2 Usage

It is a simple repository to model data within the x-y plane. Different types of models are available, such as linear and quadratic.
The curve fitting and its parameters adjusting are treated as an optimization problem. For now, the available loss function and optimizer
algorithm are RMSE and ADAM, respectively. 

The main method is regress_model, which initializes, trains and sets the model. It returns a function with the parameters on it already,
i.e., the function depends upon x only. And regress_model also returns the vector of parameters.

Despite the three obligatory inputs (x, vector of x coordinates of the data points; y, vector of y coordinates; model_name, string with
the name of the chosen regression model), the user can set with optional arguments: n_iterations, the number of iterations for the opti-
mization algorithm; tolerance_convergence, a tolerance for the norm of the gradient of the loss function to early stop the optimization
procedure; flag_plot, boolean flag to plot or not the data points with the regressed model in between; n_digits, the number of decimal
digits for the r-squared parameter for the plot; length_xPlot, length of the vector of points in the x axis for the points of the model
plotted against the data points; loss_type, type of loss function, e.g., RMSE, MAE...; optimizer_type, type of optimization algorithm,
e.g., ADAM, steepest descent.

A working example for a set of 5 points: 

x = [0.7758499193794507; 2.1149072994783578; 3.069946372409401; 3.9032534558011114; 4.978341489723784]

y = [0.939073176190983; 4.087120131564667; 6.158325192308579; 7.9723922499945035; 10.106772753332615]

For linear regression

model_function, parameters = regress_model(x, y, "linear")

model_function is already a function of x only and contains the trained parameters.


[plot_linear_regression.pdf](https://github.com/Matheus-Janczkowski/plane_regression/files/12655851/plot_linear_regression.pdf)
