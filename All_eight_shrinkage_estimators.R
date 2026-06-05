################################################################################
################### Section 2 -- Four Shrinkage Estimators (ours) ##############
################################################################################
# Main function for St-MSh estimator
St_MSh_estimator <- function(x) {
  Tn <- nrow(x)
  N_T <- ncol(x)

  x_bar <- colMeans(x)
  a1T_hat <- sum(x_bar^2) / N_T
  trace_Sn <- sum(diag(cov(x)))
  a2T_hat <- a1T_hat + trace_Sn/(Tn * N_T)
  c_star_hat <- a1T_hat / a2T_hat

  theta_St_MSh <- c_star_hat * x_bar

  return(as.vector(theta_St_MSh))
}

# Main function for D-MSh estimator
D_MSh_estimator <- function(x) {
  Tn <- nrow(x)
  N_T <- ncol(x)

  x_bar <- colMeans(x)
  Sn <- cov(x)
  c_star_hat <- (x_bar^2) / (x_bar^2 + (1/Tn) * diag(Sn))

  theta_D_MSh <- c_star_hat * x_bar

  return(as.vector(theta_D_MSh))
}

# Main function for O-LSh estimator
O_LSh_estimator <- function(x) {
  Tn <- nrow(x)
  N_T <- ncol(x)

  x_bar <- colMeans(x)
  a1T_hat <- sum(x_bar^2) / N_T
  trace_Sn <- sum(diag(cov(x)))
  a2T_hat <- a1T_hat + trace_Sn/(Tn * N_T)

  s_i <- rowSums(x)
  term1 <- sum(s_i^2)
  term2 <- ((sum(s_i))^2 - term1) / (Tn - 1)
  d2_hat <- (term1 - term2) / (Tn^2 * N_T^2)
  grand_mean <- mean(x_bar)
  d3_hat <- sum((x_bar - grand_mean)^2) / N_T

  tilde_a1_hat <- a2T_hat - a1T_hat - d2_hat
  tilde_a2_hat <- tilde_a1_hat + d3_hat
  delta_star_hat <- tilde_a1_hat / tilde_a2_hat

  theta_O_LSh <- (1 - delta_star_hat) * x_bar +
    delta_star_hat * rep(grand_mean, N_T)

  return(as.vector(theta_O_LSh))
}

# Main function for T-LSh estimator
T_LSh_estimator <- function(x) {
  Tn <- nrow(x)
  N_T <- ncol(x)

  x_bar <- colMeans(x)
  a1T_hat <- sum(x_bar^2) / N_T
  trace_Sn <- sum(diag(cov(x)))
  a2T_hat <- a1T_hat + trace_Sn/(Tn * N_T)

  s_i <- rowSums(x)
  term1 <- sum(s_i^2)
  term2 <- ((sum(s_i))^2 - term1) / (Tn - 1)
  d2_hat <- (term1 - term2) / (Tn^2 * N_T^2)
  grand_mean <- mean(x_bar)
  d3_hat <- sum((x_bar - grand_mean)^2) / N_T
  d4_hat <- grand_mean^2

  tilde_a1_hat <- a2T_hat - a1T_hat - d2_hat
  tilde_a2_hat <- tilde_a1_hat + d3_hat
  delta_star_hat <- tilde_a1_hat / tilde_a2_hat
  xi_star_hat <- 1 - (d2_hat/(d2_hat + d4_hat))/delta_star_hat

  theta_T_LSh <- (1 - delta_star_hat)*x_bar +
    delta_star_hat * xi_star_hat * rep(grand_mean, N_T)

  return(as.vector(theta_T_LSh))
}


################################################################################
############ Section 3 -- Four Shrinkage Estimators (competitors) ##############
################################################################################
# Competitor 1: (Wang et al., 2014)
Wang_estimator <- function(x) {
  n <- nrow(x)
  p <- ncol(x)
  
  x_bar <- colMeans(x)
  col_sum <- colSums(x)
  total_sq_col <- sum(col_sum^2)
  sum_sq_x <- sum(x^2)
  Y1n <- (total_sq_col - sum_sq_x) / (p * (n - 1))
  Y2n <- (sum_sq_x - p * Y1n) / (n * p)
  row_sum <- rowSums(x)
  total_row <- sum(row_sum)
  Y3n <- (total_row^2 - sum(row_sum^2)) / (p^2 * (n - 1))
  Y4n <- total_row / (n * p)

  denom <- Y1n + Y2n - Y3n
  alpha_star <- as.numeric((Y1n - Y3n) / denom)
  beta_star  <- as.numeric((Y2n * Y4n) / denom)

  theta_hat_Wang <- alpha_star * x_bar + beta_star * rep(1, p)

  return(as.vector(theta_hat_Wang))
}

# Competitor 2: (Bodnar et al., 2019): BOP
BOP_estimator <- function(x) {
  n <- nrow(x)
  p <- ncol(x)
  y_bar <- colMeans(x)
  S_n <- cov(x)
  if (p > n) {
    S_n_inv <- MASS::ginv(S_n)
  } else {
    S_n_inv <- solve(S_n)
  }
  mu_0 <- rep(1, p)
  
  yS_inv_y <- as.numeric(t(y_bar) %*% S_n_inv %*% y_bar)
  mu0_S_inv_mu0 <- as.numeric(t(mu_0) %*% S_n_inv %*% mu_0)
  yS_inv_mu0  <- as.numeric(t(y_bar) %*% S_n_inv %*% mu_0)
  if (p > n) {
    term1 <- yS_inv_y - n / (p - n)
  } else {
    term1 <- yS_inv_y - p / (n - p)
  }
  term2 <- yS_inv_y * mu0_S_inv_mu0
  
  alpha_mean <- (term1 * mu0_S_inv_mu0 - yS_inv_mu0^2) / (term2 - yS_inv_mu0^2)
  beta_mean  <- (1 - alpha_mean) * yS_inv_mu0 / mu0_S_inv_mu0
  
  theta_hat_BOP <- alpha_mean * y_bar + beta_mean * mu_0
  
  return(as.vector(theta_hat_BOP))
}

# Competitor 3: (Bodnar et al., 2022): CW
CW_estimator <- function(x) {
  n <- nrow(x)
  p <- ncol(x)
  y_bar <- colMeans(x)
  S_n <- cov(x)
  S_n_plus <- MASS::ginv(S_n)
  
  a <- (n - 3) / (p - n + 4)
  scalar <- as.numeric(t(y_bar) %*% S_n_plus %*% y_bar)
  term2 <- max(1 - (a / scalar), 0)
  
  theta_hat_CW <- (diag(p) - S_n %*% S_n_plus) %*% y_bar +
    term2 * (S_n %*% S_n_plus %*% y_bar)
  
  return(as.vector(theta_hat_CW))
}

# Competitor 4: (Jorion, 1986): Jorion
Jorion_estimator <- function(x) {
  Tn <- nrow(x)     
  N_T <- ncol(x)    
  
  mu_MLE <- colMeans(x)
  Sn <- (Tn-1)/(Tn - N_T-2) * cov(x)
  Sn_inv <- solve(Sn)
  ones <- rep(1, N_T)
  num   <- as.numeric(t(ones) %*% Sn_inv %*% mu_MLE)
  denom <- as.numeric(t(ones) %*% Sn_inv %*% ones)
  mu0    <- num / denom
  
  diff <- mu_MLE - mu0 * ones
  d <- as.numeric(Tn * t(diff) %*% Sn_inv %*% diff)
  w <- (N_T + 2)/(N_T + 2 + d)
  
  theta_hat_Jorion <- (1 - w) * mu_MLE + w * rep(mu0, N_T)
  
  return(as.vector(theta_hat_Jorion))
}

