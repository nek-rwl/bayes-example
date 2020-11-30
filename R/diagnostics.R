summary(mod_stan_glm2, digits = 3, prob = c(0.025, 0.5, 0.975))

launch_shinystan(mod_stan_glm2, ppd = FALSE)
