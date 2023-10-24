# This repository contains an R script for analyzing historical data on corn prices, customer price index (CPI), and corn quantity. The script performs the following tasks:

# Resets the R environment.
# Reads data from an Excel file into R.
# Utilizes the tidyverse package for data manipulation.
# Uses the sandwich and lmtest packages for addressing correlated errors.
# Creates visualizations to explore the data, specifically plotting corn price, CPI, and quantity over time.
# Calculates and examines the relationship between the logarithms of corn price and quantity.
# Studies the residuals of the initial regression and their relationship with lagged residuals and quantity.
# Fits a linear regression model for residuals regressed on lagged residuals and quantity.
# Calculates the Breusch-Godfrey statistic to test for serial correlation in the residuals.
# Performs a hypothesis test to determine whether to reject the null hypothesis.
# Conducts a coefficient test with Newey-West standard errors for the initial regression.

# This script is a comprehensive analysis of historical corn data and can serve as a reference for similar time series data analysis projects.
