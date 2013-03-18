################################################################################
# FLSR examples ################################################################
################################################################################

## FLSR is found in FLCore
library(FLCore)

# Example dataset; North Sea Herring
data(nsher)

# Let's look at the FLSR class
summary(nsher)

# What slots are in an FLSR object?
getSlots('FLSR')

# What are the avialable FLSR methods?
showMethods(class="FLSR")


## what changes for the different SRRs?
#### Model and likelihood are functions of the FLSR class
model(nsher)
logl(nsher)

#### initial values for the optimiser
initial(nsher)

#### lower and upper limits for the parameters
lower(nsher)
upper(nsher)

### where did these come from
ricker()

################################################################################

# set the SRR model as Ricker
model(nsher) <- ricker()

# ricker() contains everything needed to fit a non-linear model
# a formula for the model
ricker()$model

# the loglikehood function
ricker()$logl

# a function for initial values
ricker()$initial

# other stock recruitment functional forms exist
bevholt()
shepherd()
cushing()
geomean()
segreg()
rickerSV()
bevholtSV()
shepherdSV()
bevholtAR1()


# the fmle method then fits the SRR using logl and R's optim
nsher <- fmle(nsher)



# plot, summaries model fit and diagnostics
plot(nsher)

# Profile the likelihood to check the fit
# for a 2-parameter model like Riker, profiles over a range of 2 values
# around MLE estimate
profile(nsher)

# fmle also allows individual parameters to be fixed
nsherFixed <- fmle(nsher, fixed=list(a=130))

# methods exist for Akaike Information Criterion
AIC(nsher)
AIC(nsherFixed)

# and Schwarz's Bayesian Information Criterion
BIC(nsher)
BIC(nsherFixed)

# predict uses the formula and parameter values to get a predicted recruitment
predict(nsher)

# which also be called with a new input ssb
predict(nsher, ssb=ssb(nsher)*1.5)









#### Creation from an FLStock
data(ple4)

ple4SR<-as.FLSR(ple4)

### Note the shift in years, reflecting that recruitment is at age 1 in the ple4
ssb(ple4SR)
rec(ple4SR)

summary(ple4SR)
################################################################################


#### Specifying the stock recruitment relationship and error model
## after creating the new object
model(ple4SR)<-bevholt()

## when creating the new object
ple4SR<-as.FLSR(ple4,model="bevholt")
################################################################################

#### fitting

## copy object
nsherRK       <-nsher

## choose SRR
model(nsherRK)<-ricker()

system.time(badFit        <-fmle(nsherRK, start=c(a=1,b=2)))

system.time(nsherRK       <-fmle(nsherRK))



#### plot fit and diagnostics
plot(nsherRK)
################################################################################

# parameter values can also be fixed
nsherRKFixed  <-fmle(nsherRK, fixed=list(a=63580373))

# Comparison of fits using AIC
AIC(nsherRK)
AIC(nsherRKFixed)
################################################################################

plot(nsherRK)
################################################################################

#### Profile both parameters
profile(nsherRK,which=c("a","b"))

#### Profile alpha
profile(nsherRK,which=c("a"))

#### Profile beta
profile(nsherRK,which=c("b"))

#### Covariance matrix
vcov(nsherRK)

#### Correlation matrix
cov2cor(vcov(nsherRK)[,,1])

## fit Beverton and Holt
nsherBH       <-nsher
model(nsherBH)<-bevholt()
nsherBH       <-fmle(nsherBH)

#### Problems with fitting
pleSegR<-as.FLSR(ple4)

## fit segmented regression
model(pleSegR)<-segreg()

## inspect default starting values
initial(pleSegR)(rec(pleSegR), ssb(pleSegR))

## fit
pleSegR       <-fmle(pleSegR)

## Inspect results
plot(pleSegR)

## Check fit
profile(pleSegR)



#### Hessian
hessian(her4SR)
computeHessian(her4SR)

#### compute covariance matrix from inverse of Hessian,
#### remember it is the negative log likelihood
-solve(computeHessian(her4SR))

#### correlation matrix
cov2cor(-solve(computeHessian(her4SR)))
################################################################################





#### Bootstrapping ##################################################################
niter <- 999
res.boot <- sample(c(residuals(nsher)), niter * dims(nsher)$year, replace=T)

sr.bt       <- propagate(nsher, niter)
rec(sr.bt) <- rec(sr.bt)[] + res.boot
model(sr.bt) <- ricker()


## fits across all iters independently
model(sr.bt) <- ricker()
sr.bt  <-fmle(sr.bt)

plot( t(params(sr.bt2)[drop=TRUE]))

################################################################################

















myricker <- function () 
{
  logl <- function(a, b, rec, ssb) {
    if (a < 1e-10 || b < 1e-10) return(-1e100)
    z <- log(rec) - log(a) - log(ssb) + b * ssb
    n <- length(rec)
    #sigma2 <- var(z)
    sigma2 <- mean(z^2)
    0.5 * (log(1/(2 * pi)) - length(rec) * log(sigma2) - sum(z^2)/(2 * sigma2) ) 
  }
  initial <- structure(function(rec, ssb) {
        S <- c(ssb)
        logS <- log(S)
        logR <- log(c(rec))
        res <- coefficients(lm(logR ~ S, offset = logS))
        return(FLPar(a = exp(res[1]), b = -min(res[2],0)))
    }, lower = rep(-Inf, 2), upper = rep(Inf, 2))
    model <- rec ~ a * ssb * exp(-b * ssb)
    return(list(logl = logl, model = model, initial = initial))
}

