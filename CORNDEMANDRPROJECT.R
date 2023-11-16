# To reset r environment
rm(list=ls())

# Reading excel file and placing data into r studio environment
# DATA IS ON 91 OBSERVATIONS OF PRODUCTION 
# P = dollars per bushel, CPI = Customer price index from 1926-2016, Q = billions of bushels
corn  <- read.csv("demandofcorn.csv")

# Package for observational questions
library(tidyverse)

# Need packages for correlated errors
library(sandwich)
library(lmtest)

# Plotting everything 
plot_ci <- corn %>%
  mutate(CPI = CPI / 100) %>%
  pivot_longer(cols = c("P", "CPI", "Q")) %>%
  ggplot(aes(y = value, x = year, color = name)) +
  geom_line() +
  theme_bw() +
  ggtitle("Corn Price and Quantity") +
  labs(x = "Year", color = "Variable")

plot_ci

# Take logs of price and quantity
corn <- corn %>%
  mutate(
    log_p = log(P),
    log_q = log(Q),
    log_rp = log(P / CPI)
  )
  
# Take first regression to learn change in log_p for one unit in change of log_q
reg1 <- lm(log_p ~ log_q, data = corn)
summary(reg1)

# Add lag and residuals to data frame, (examine relationships between variable and its past)
corn <- corn %>%
  mutate(
    e = reg1$residuals,
    lag_e = lag(e)
  )

# Create a plot of residuals with the year(date)
plot_e <- corn %>%
  ggplot(aes(x = year, y = e)) +
  geom_line() +
  theme_bw() +
  ggtitle("Residuals")

# Display the plot
plot_e

# Fit a linear regression model with residuals (e) regressed on lagged residuals (lag_e) and log_q
reg_bg <- lm(e ~ lag_e + log_q, data = corn)

# Display a summary of the regression model
summary(reg_bg)

# Extract the R-squared value from the summary of the reg_bg model
bg_r2 <- summary(reg_bg)$r.squared

# Calculate the Breusch-Godfrey statistic (bg) by multiplying R-squared by the number of observations
bg <- bg_r2 * nobs(reg_bg)
bg

# Calculate the 95th percentile of the chi-squared distribution with 1 degree of freedom
critical_value <- qchisq(0.95, df = 1)

# Compare the Breusch-Godfrey statistic (bg) to the critical value for chi-squared distribution with 1 degree of freedom at 0.95 confidence level
# Do you reject the null hypothesis
bg > qchisq(0.95, df = 1)

# Display the summary of the regression model (reg1)
summary(reg1)

# Perform a coefficient test with Newey-West standard errors
coeftest(reg1, vcov = NeweyWest(reg1, lag = 12, prewhite = FALSE, adjust = TRUE))
