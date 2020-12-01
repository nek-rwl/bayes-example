schools_dat <- list(J = 8,
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

modelcode_schools <- "
data {
  int<lower=0> J;         // number of schools
  real y[J];              // estimated treatment effects
  real<lower=0> sigma[J]; // standard error of effect estimates
}
parameters {
  real mu;                // population treatment effect
  real<lower=0> tau;      // standard deviation in treatment effects
  vector[J] eta;          // unscaled deviation from mu by school
}
transformed parameters {
  vector[J] theta = mu + tau * eta; // school treatment effects
}
model {
  // priors
  mu ~ normal(0, 20);
  tau ~ cauchy(0, 20);
  eta ~ normal(0, 1);

  // model likelihood
  y ~ normal(theta, sigma);
}
"

mod_stan_schools <- stan(model_code = modelcode_schools, data = schools_dat)

print(mod_stan_schools, pars = c("theta", "mu", "tau"))
