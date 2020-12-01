X <- as.matrix(cbind(Intercept = 1, covariates))
y <- d$y

dat <- list(N = N, K = ncol(X), y = y, X = X)

stanmodelcode_r2 <- "
data {                      // Data block
  int<lower=1> N;           // Sample size
  int<lower=1> K;           // Dimension of model matrix
  matrix[N, K] X;           // Model Matrix
  vector[N] y;              // Target variable
}

transformed data {
  real totalss = dot_self(y - mean(y));
}

parameters {                // Parameters block
  vector[K] beta;           // Coefficient vector
  real<lower=0> sigma;      // Error scale
}

model {                     // Model block
  vector[N] mu;
  mu = X * beta;            // Creation of linear predictor

  // priors
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);     // With sigma bounded at 0, this is half-cauchy

  // likelihood
  y ~ normal(mu, sigma);
}

generated quantities {
  real rss;
  real R2;
  vector[N] mu;

  mu = X * beta;
  rss = dot_self(y - mu);
  R2 = 1 - (rss / totalss);
}
"

mod_stan_r2 <- stan(model_code = stanmodelcode_r2, data = dat)

mod_stan_r2

extract(mod_stan_r2)$R2
