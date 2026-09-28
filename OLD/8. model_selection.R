library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

model.names <- c(#"RW",
#"RW regsex",
#"RW regtime",
#"RW sextime",
#"RW regsex regtime",
#"RW regsex sextime",
#"RW regtime sextime",

#"RW regregage",
#"RW regregage regsex",
#"RW regregage regtime",
#"Rw regregage regtime alt",
#"RW regregage sextime",
#"RW regregage regsex regtime",
#"RW regregage regsex sextime",
#"RW regregage regtime sextime",
  #"RW regregage regregtime",
"RW regregage regtime regregagesex regregagetime"
)

#c("RW regtime", "RW regregtime",
#                 "RW regregage", "RW regregage regtime",
#                 "RW regregage regregsex",
#                 "RW regregage regregsex regtime")

for (curmod in model.names) {
  mod <- readRDS(paste0("out/mod ",curmod,".rds"))
  
  set.seed(12345)
  
  results <- augment(mod)
  rate_mat <- as.matrix(results$.fitted)
  lambda_mat <- results$popn_orig * rate_mat
  
  lnprob_mat <- matrix(NA, nrow = nrow(lambda_mat),
                       ncol = ncol(lambda_mat))
  
  for (icol in 1:ncol(lnprob_mat)) {
    print(icol)
    
    lnprob_mat[, icol] <- dpois(results$mig,
                                lambda = lambda_mat[,icol], log = TRUE)
  }
  
  lnprob.max <- apply(lnprob_mat, 1, max)
  lppd <- sum((log(apply(exp(lnprob_mat - lnprob.max), 1, mean))+ lnprob.max), na.rm = TRUE)
  pWAIC <- sum(apply(lnprob_mat, 1, var), na.rm = TRUE)
  WAIC <- -2*(lppd - pWAIC)
  
  write.table(WAIC, paste0("out/WAIC ", curmod,".txt"), row.names = FALSE, 
              col.names = FALSE)
  
  rm(list = ls()) # remove the objects, store them in garbage can
  gc() # return memory from the garbage can to the operating system.
}

