library(edstan)

data(spelling); slice_sample(spelling, n = 20)

spelling_data <- irt_data(response_matrix = spelling[-1],
                          covariates = cbind(1, spelling[1]),
                          formula = ~ male)

mod_edstan_rasch <- irt_stan(spelling_data, model = "rasch_latent_reg.stan")

print_irt_stan(mod_edstan_rasch, spelling_data)

mod_edstan_2pl <- irt_stan(spelling_data, model = "2pl_latent_reg.stan")

print_irt_stan(mod_edstan_2pl, spelling_data)

# These are also simple to code directly in Stan
# (ignoring the 'male' covariate for now):

modelcode_rasch <- "
data {
  int<lower=1> I;               // # questions
  int<lower=1> J;               // # persons
  int<lower=1> N;               // # observations
  int<lower=1, upper=I> ii[N];  // question for n
  int<lower=1, upper=J> jj[N];  // person for n
  int<lower=0, upper=1> y[N];   // correctness for n
}
parameters {
  vector[I] beta;
  vector[J] theta;
  real<lower=0> sigma;
}
model {
  beta ~ normal(0, 3);
  theta ~ normal(0, sigma);
  sigma ~ exponential(.1);
  y ~ bernoulli_logit(theta[jj] - beta[ii]);
}
"

mod_stan_rasch <- stan(model_code = modelcode_rasch, data = spelling_data)

print(mod_stan_rasch, pars = c("beta", "sigma"))

modelcode_2pl <- "
data {
  int<lower=1> I;               // # questions
  int<lower=1> J;               // # persons
  int<lower=1> N;               // # observations
  int<lower=1, upper=I> ii[N];  // question for n
  int<lower=1, upper=J> jj[N];  // person for n
  int<lower=0, upper=1> y[N];   // correctness for n
}
parameters {
  vector<lower=0>[I] alpha;
  vector[I] beta;
  vector[J] theta;
}
model {
  vector[N] eta;
  alpha ~ lognormal(1, 1);
  beta ~ normal(0, 3);
  theta ~ normal(0, 1);
  for (n in 1:N)
    eta[n] = alpha[ii[n]] * (theta[jj[n]] - beta[ii[n]]);
  y ~ bernoulli_logit(eta);
}
"

mod_stan_2pl <- stan(model_code = modelcode_2pl, data = spelling_data)

print(mod_stan_2pl, pars = c("alpha", "beta"))
