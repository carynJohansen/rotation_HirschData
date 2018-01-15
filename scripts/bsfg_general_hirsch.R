#This is how you would re-install BSFG:
#library(git2r)
#library(devtools)
#my_local_library = '/usr/local/lib/R/3.3/site-library/'
#BSFG_path = 'https://github.com/deruncie/SparseFactorMixedModel'
#withr::with_libpaths(my_local_library,install_git(BSFG_path,branch = 'develop',subdir = 'BSFG'))

library(MCMCpack)
library(BSFG)

setwd("/home/caryn89/rotations/maize_genomics/BSFG")

#save that run
rep <- "04152017_1"
folder <- sprintf("Rep_%s",rep)
try(dir.create(folder))
setwd(folder)

K <- read.table("/home/caryn89/rotations/maize_genomics/data/BSFG_input/ZeaGBSv27_sF.sXX.txt")
Y <- read.table("/home/caryn89/rotations/maize_genomics/data/BSFG_input/maize_414_expressedFPKM.bb", sep=",")
k_lines <- ("/home/caryn89/rotations/maize_genomics/data/BSFG_input/ZeaGBSv27_414Exp_lines.txt")

colnames(k_lines) <- "Line"
rownames(K) <- k_lines[,1]
rownames(Y) <- k_lines[,1]

library(Matrix)
K <- Matrix(as.matrix(K), sparse = TRUE)
K_mod = K
K_mod[K_mod < 1e-10] = 0
K_mod = forceSymmetric(drop0(K_mod,tol = 1e-10))
rownames(K_mod) = rownames(K)

# initialize priors
run_parameters = BSFG_control(
  sampler = 'fast_BSFG',
  #sampler = 'general_BSFG',
  simulation   = FALSE,
  scale_Y = TRUE,
  h2_divisions = 20,
  h2_step_size = NULL,
  burn = 100
)

priors = list(
  fixed_var = list(V = 5e5,   nu = 2.001),
  # fixed_var = list(V = 1,     nu = 3),
  tot_Y_var = list(V = 0.5,   nu = 3),
  tot_F_var = list(V = 18/20, nu = 20),
  delta_1   = list(shape = 2.1,  rate = 1/20),
  delta_2   = list(shape = 3, rate = 1),
  Lambda_df = 3,
  B_df      = 3,
  B_F_df    = 3
)

print('Initializing')

BSFG_state = BSFG_init(Y[,1:1000], model=~1 + (1|Line),data = k_lines,factor_model_fixed = NULL,priors=priors,run_parameters=run_parameters,K_mats = list(Line = K_mod))

h2_divisions = run_parameters$h2_divisions
BSFG_state$priors$h2_priors_resids = with(BSFG_state$data_matrices, sapply(1:ncol(h2s_matrix),function(x) {
  h2s = h2s_matrix[,x]
  pmax(pmin(ddirichlet(c(h2s,1-sum(h2s)),rep(2,length(h2s)+1)),10),1e-10)
}))
BSFG_state$priors$h2_priors_resids = BSFG_state$priors$h2_priors_resids/sum(BSFG_state$priors$h2_priors_resids)
BSFG_state$priors$h2_priors_factors = c(h2_divisions-1,rep(1,h2_divisions-1))/(2*(h2_divisions-1))


save(BSFG_state,file="BSFG_state.RData")
#load("BSFG_state.RData")

BSFG_state = clear_Posterior(BSFG_state)

# # optional: To load from end of previous run, run above code, then run these lines:
# load('Posterior.RData')
# load('BSFG_state.RData')
# load('Priors.RData')
#  BSFG_state$current_state = current_state
#  BSFG_state$Posterior = Posterior
#  BSFG_state$priors = priors
# start_i = run_parameters$nrun;

# Run Gibbs sampler. Run in smallish chunks. Output can be used to re-start chain where it left off.
# burn in
BSFG_state$run_parameters$simulation = FALSE
n_samples = 10;
for(i  in 1:70) {
  print(sprintf('Run %d',i))
  BSFG_state = sample_BSFG(BSFG_state,n_samples,ncores=1)
  if(BSFG_state$current_state$nrun < BSFG_state$run_parameters$burn) {
    BSFG_state = reorder_factors(BSFG_state)
  }
  BSFG_state = save_posterior_chunk(BSFG_state)
  print(BSFG_state)
  plot(BSFG_state)
}

posterior <- BSFG_state$Posterior
posterior_lambda <- posterior$Lambda

#save the RData file...

save.image()


