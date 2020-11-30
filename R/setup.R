library(tidyverse)
library(rstan)
library(rstanarm)
library(brms)

rstan_options(auto_write = TRUE)

set.seed(8675309)

N <- 250
K <- 3

coefs <- c(5, 0.2, -1.5, 0.9)

covariates <- map_dfc(set_names(seq_len(K), paste0("X", seq_len(K))),
                      ~rnorm(N))

d <- mutate(
  covariates,
  y = rnorm(N, as.matrix(cbind(Intercept = 1, covariates)) %*% coefs, 2),
  .before = 1
)
