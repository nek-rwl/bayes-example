mod_stan_glm <- stan_glm(y ~ X1 + X2 + X3, data = d)

summary(mod_stan_glm, digits = 3, prob = c(0.025, 0.5, 0.975))

mod_stan_glm2 <- stan_glm(
  y ~ X1 + X2 + X3, data = d,
  prior = normal(0, 10),
  prior_intercept = normal(0, 10),
  prior_aux = cauchy(0, 5),
  iter = 5000, warmup = 2500, thin = 10, chains = 4
)

summary(mod_stan_glm2, digits = 3, prob = c(0.025, 0.5, 0.975))
