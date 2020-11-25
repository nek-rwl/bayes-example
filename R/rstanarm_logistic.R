d <- mutate(
  d,
  y_binary = rbinom(
    N, 1,
    invlogit(as.matrix(cbind(Intercept = 1, covariates)) %*% coefs - 4)
  ),
  .after = 1
)

mod_stan_glm_logistic <- stan_glm(
  y_binary ~ X1 + X2 + X3, family = binomial(), data = d
)

summary(mod_stan_glm_logistic, digits = 3, prob = c(0.025, 0.5, 0.975))
