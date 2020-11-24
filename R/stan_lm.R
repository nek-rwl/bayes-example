mod_stan <- stan_glm(y ~ ., data = d)

summary(mod_stan, digits = 3, prob = c(0.025, 0.5, 0.975))

mod_stan2 <- stan_glm(
  y ~ ., data = d,
  prior = normal(0, 10), prior_intercept = normal(0, 10), prior_aux = cauchy(0, 5),
  iter = 5000, warmup = 2500, thin = 10, chains = 4
)

summary(mod_stan2, digits = 3, prob = c(0.025, 0.5, 0.975))
