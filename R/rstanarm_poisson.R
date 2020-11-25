d <- mutate(
  d,
  y_count = rpois(
    N,
    exp(as.matrix(cbind(Intercept = 1, covariates)) %*% coefs - 4)
  ),
  .after = 2
)

mod_stan_glm_poisson <- stan_glm(
  y_count ~ X1 + X2 + X3, family = poisson(), data = d
)

summary(mod_stan_glm_poisson, digits = 3, prob = c(0.025, 0.5, 0.975))
