y <- read_table2('https://raw.github.com/wiki/stan-dev/rstan/rats.txt',
                 col_names = TRUE)

x <- c(8, 15, 22, 29, 36)
xbar <- mean(x)
N <- nrow(y)
T <- ncol(y)

rats <- y %>%
  mutate(ID = row_number()) %>%
  pivot_longer(-ID, "day", names_prefix = "day", values_to = "y") %>%
  mutate(x = as.numeric(day), x = x - mean(x))

mod_brms_rats <- brm(bf(y ~ 1 + x + (1 + x | ID)),
                     data = rats)

modelcode_rats <- "
data {
  int<lower=0> N;
  int<lower=0> T;
  real x[T];
  real y[N,T];
  real xbar;
}
parameters {
  real alpha[N];
  real beta[N];

  real mu_alpha;
  real mu_beta;          // beta.c in original bugs model

  real<lower=0> sigmasq_y;
  real<lower=0> sigmasq_alpha;
  real<lower=0> sigmasq_beta;
}
transformed parameters {
  real<lower=0> sigma_y;       // sigma in original bugs model
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_beta;

  sigma_y = sqrt(sigmasq_y);
  sigma_alpha = sqrt(sigmasq_alpha);
  sigma_beta = sqrt(sigmasq_beta);
}
model {
  mu_alpha ~ normal(0, 100);
  mu_beta ~ normal(0, 100);
  sigmasq_y ~ inv_gamma(0.001, 0.001);
  sigmasq_alpha ~ inv_gamma(0.001, 0.001);
  sigmasq_beta ~ inv_gamma(0.001, 0.001);
  alpha ~ normal(mu_alpha, sigma_alpha); // vectorized
  beta ~ normal(mu_beta, sigma_beta);  // vectorized
  for (n in 1:N)
    for (t in 1:T)
      y[n,t] ~ normal(alpha[n] + beta[n] * (x[t] - xbar), sigma_y);

}
generated quantities {
  real alpha0;
  alpha0 <- mu_alpha - xbar * mu_beta;
}
"

rats_fit <- stan(model_code = modelcode_rats)
