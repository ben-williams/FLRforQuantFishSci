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

# several stock recruitment functional forms exist e.g.
ricker()

# set the SRR model as Ricker
model(nsher) <- ricker()

# ricker() contains everything needed to fit a non-linear model
# a formula for the model
ricker()$model

# the loglikehood function
ricker()$logl
getMethod('loglAR1', c('FLQuant', 'FLQuant'))

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

# conversion between different parameterisations such as steepness & virgin biomass
# and alpha & beta can be done on a fitted object,
# by providing a value of spr0
nsherSV <- sv(nsher, spr0=0.04)

summary(nsherSV)





#### Bootstrapping ##################################################################
niter <- 999
res.boot <- sample(c(residuals(nsher)), niter * dims(nsher)$year, replace=T)

sr.bt       <- propagate(nsher, niter)
rec(sr.bt) <- rec(sr.bt)[] + res.boot
model(sr.bt) <- ricker()


## fits across all iters independently
#model(sr.bt) <- ricker()
#system.time(sr.bt  <-fmle(sr.bt))

sr.bt2 <- sr.bt
model(sr.bt2) <- myricker()
#system.time(sr.bt2  <- fmle(sr.bt2))


library(FLCore)

logl <- function(a, b, rec, ssb) -1 * ricker() $ logl(exp(a), exp(b), rec, ssb)
llik <- function(par, data) {
            pars <- as.list(par)
            names(pars) <- c("a","b")
            -1 * do.call(logl, args = c(pars, data))
        }

data(nsher)
nsher10 <- propagate(nsher, 10)
model(nsher10) <- ricker()



out <-
list(
  rawlogfoo = system.time(replicate(10, optim(c(0,0), llik, data = list(rec = c(rec(nsher)), ssb = c(ssb(nsher)))))),
  logfoo = system.time(replicate(10, optim(c(0,0), llik, data = list(rec = rec(nsher), ssb = ssb(nsher))))) ,
  rawfmle = system.time(tmp  <- fmle(nsher10, preconvert = TRUE)),
  fmle = system.time(tmp  <- fmle(nsher10))
)

do.call(rbind, out)



plot( t(params(sr.bt2)[drop=TRUE]))

################################################################################





















#### Chunk 1 ###################################################################
## what does an FLSR object look like
data(nsher)

summary(nsher)
################################################################################

#### Chunk 2 ###################################################################
## what methods are available
showMethods(class="FLSR")
################################################################################

#### Chunk 3 ###################################################################
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

#### Chunk 4 ###################################################################
#### Creation from an FLStock
data(ple4)
stock.wt(ple4) <- stock.wt(ple4) * 100000
stock.n(ple4) <- stock.n(ple4)

system.time(fit <- fmle(as.FLSR(ple4, model = "ricker")))
system.time(fit <- fmle(as.FLSR(ple4, model = "myricker")))
system.time(fit <- fmle(as.FLSR(ple4, model = "myricker"), method = "BFGS"))


ple4SR<-as.FLSR(ple4)

### Note the shift in years, reflecting that recruitment is at age 1 in the ple4
ssb(ple4SR)
rec(ple4SR)

summary(ple4SR)
################################################################################

#### Chunk 5 ###################################################################
#### Specifying the stock recruitment relationship and error model
## after creating the new object
model(ple4SR)<-bevholt()

## when creating the new object
ple4SR<-as.FLSR(ple4,model="bevholt")
################################################################################

#### Chunk 6 ###################################################################
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

#### Chunk 7 ###################################################################
# parameter values can also be fixed
nsherRKFixed  <-fmle(nsherRK, fixed=list(a=63580373))

# Comparison of fits using AIC
AIC(nsherRK)
AIC(nsherRKFixed)
################################################################################

#### Chunk 8 ###################################################################
plot(nsherRK)
################################################################################

#### Chunk 9 ###################################################################
#### Profile both parameters
profile(nsherRK,which=c("a","b"))

#### Profile alpha
profile(nsherRK,which=c("a"))

#### Profile beta
profile(nsherRK,which=c("b"))
################################################################################

#### Chunk 10 ###################################################################
#### Covariance matrix
vcov(nsherRK)

#### Correlation matrix
cov2cor(vcov(nsherRK)[,,1])
################################################################################

#### Chunk 11 ##################################################################
## fit Beverton and Holt
nsherBH       <-nsher
model(nsherBH)<-bevholt()
nsherBH       <-fmle(nsherBH)

## Get Steepness and virgin biomass
svPar<-params(sv(nsherBH,spr0=0.045))

## convert back
ab(svPar,"bevholt",spr0=0.045)

## Steepness & Virgin biomass fitting
nsherBHSV     <-nsherBH
model(nsherBHSV)<-bevholtSV()
nsherBHSV       <-fmle(nsherBHSV,fixed=list(spr0=0.045))

## note fixing spr0
profile(nsherBHSV,fixed=list(spr0=0.045))

hessian(nsherBH)
hessian(nsherBHSV)

vcov(nsherBH)
vcov(nsherBHSV)

cov2cor(vcov(nsherBHSV)[,,1])
cov2cor(vcov(nsherBH)[,,1])
################################################################################

#### Chunk 12 ##################################################################
## fix steepness
nsherBHSV<-fmle(nsherBHSV,fixed=list(s=0.9, spr0=0.045))
################################################################################

#### Chunk 13 ##################################################################
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
################################################################################


#### Chunk 14 ##################################################################
#### Problems with fitting II

## scale data
pleSegR2<-transform(pleSegR,ssb=ssb/1000,rec=rec/1000)

## re-fit
pleSegR2<-fmle(pleSegR2)

## Inspect results
plot(pleSegR2)

## Check fit
profile(pleSegR2)
################################################################################

#### Chunk 15 ##################################################################
## Fitting problem III
#### Create FLSR object
her4SR<-as.FLSR(her4,model="ricker")

#### Fit
her4SR<-fmle(her4SR)

#### Inspect
params(her4SR)

vcov(her4SR)
################################################################################

#### Chunk 16 ##################################################################
#### Hessian
hessian(her4SR)
computeHessian(her4SR)

#### compute covariance matrix from inverse of Hessian,
#### remember it is the negative log likelihood
-solve(computeHessian(her4SR))

#### correlation matrix
cov2cor(-solve(computeHessian(her4SR)))
################################################################################

#### Chunk 17 ##################################################################
#### Transform the data
her4SR<-transform(her4SR,rec=rec/mean(rec),ssb=ssb/mean(ssb))
her4SR<-fmle(her4SR)

vcov(her4SR)
################################################################################

#### Chunk 18 ##################################################################
her4SR<-as.FLSR(her4,model="segreg")
mnRec<-mean(rec(her4SR))
mnSSB<-mean(ssb(her4SR))

her4SR<-transform(her4SR,rec=rec/mnRec,ssb=ssb/mnSSB)
her4SR<-fmle(her4SR)

her4SR<-transform(her4SR,rec=rec*mnRec,ssb=ssb*mnSSB)
params(her4SR)["a"]<-params(her4SR)["a"]*mnSSB/mnRec
params(her4SR)["b"]<-params(her4SR)["b"]*mnSSB
her4SR<-fmle(her4SR,start=params(her4SR))
################################################################################


#### Chunk 19 ##################################################################
library(numDeriv)

computeGrad=function(object,method="Richardson",
      method.args=list(eps=1e-4, d=0.0001, zero.tol=sqrt(.Machine$double.eps/7e-7), r=4, v=2, show.details=FALSE), ...){

     ## wrapper function from grad to call
     fn=function(x,sr){
       x.         =as.list(x)
       names(x.)  =dimnames(x)$params

        x.[["ssb"]]=sr@ssb
        x.[["rec"]]=sr@rec

       logl.      =sr@logl
       res        =do.call("logl.",x.)

       return(res)}

     grad(fn,x=c(object@initial(object@rec,object@ssb)),
               method=method,method.args=method.args,
               sr=object)}

her4SR<-fmle(her4SR,control=list(parscale=1/abs(computeGrad(her4SR))))
################################################################################

#### Chunk 20 ##################################################################
her4SV<-as.FLSR(her4,model="bevholtSV")
her4SV<-fmle(her4SV,fixed=list(spr0=0.045))
profile(her4SV,which=c("s","v"),fixed=list(spr0=0.045))

her4SV<-transform(her4SV,ssb=ssb/1000,rec=rec/1000)
her4SV<-fmle(her4SV,fixed=list(spr0=0.045))
profile(her4SV,which=c("s","v"),fixed=list(spr0=0.045))
################################################################################

#### Chunk 21 ##################################################################
#### Deriso Schnute
dersch<-function(){
  logl <- function(a,b,c,rec,ssb) {
          res<-loglAR1(log(rec), log(a*ssb*(1-b*c*ssb)^(1/c)))
          return(res)
          }

  ## initial parameter values
  initial <- structure(function(rec, ssb){
     slopeAt0 <- max(quantile(c(rec)/c(ssb), 0.9, na.rm = TRUE))
     maxRec   <- max(quantile(c(rec), 0.75, na.rm = TRUE))

     ## Bevholt by default c=-1
     return(FLPar(a=slopeAt0, b=1/maxRec, c=-1))},

  lower=rep(-Inf, 3),
	upper=rep( Inf, 3))

  model  <- rec~a*ssb*(1-b*c*ssb)^(1/c)

  return(list(logl = logl, model = model, initial = initial))}


model(nsher)<-dersch()
nsher<-fmle(nsher,fixed=list(c=-1))
################################################################################

#### Chunk 22 ##################################################################
#### Original Ricker
ricker <- function(){
  logl <- function(a, b, rec, ssb)
      loglAR1(log(rec), log(a*ssb*exp(-b*ssb)))

  initial <- structure(function(rec, ssb) {
		# The function to provide initial values
    res  <-coefficients(lm(c(log(rec/ssb))~c(ssb)))
    return(FLPar(a=max(exp(res[1])), b=-max(res[2])))},

  # lower and upper limits for optim()
	lower=rep(-Inf, 2),
	upper=rep( Inf, 2))

	model  <- rec~a*ssb*exp(-b*ssb)

	return(list(logl=logl, model=model, initial=initial))}

#### Modified so temperature affects larval survival
rickerCovA <- function(){
  logl <- function(a, b, c, rec, ssb, covar){
              loglAR1(log(rec), log(a*(1+c*covar[[1]])*ssb*exp(-b*ssb)))}

  initial <- structure(function(rec, ssb, covar) {
		# The function to provide initial values
    res  <-coefficients(lm(c(log(rec/ssb))~c(ssb)))
    return(FLPar(a=max(exp(res[1])), b=-max(res[2]), c=0.0))},

  # lower and upper limits for optim()
	lower=rep(-Inf, 3),
	upper=rep( Inf, 3))

	model  <- rec~a*(1+c*covar[[1]])*ssb*exp(-b*ssb)

	return(list(logl=logl, model=model, initial=initial))}
################################################################################

#### Chunk 23 ##################################################################
#### Modified so temperature affects larval K
rickerCovB <- function(){
  logl <- function(a, b, c, rec, ssb, covar){
              loglAR1(log(rec), log(a*ssb*exp(-b*(1+c*covar[[1]])*ssb)))}

  initial <- structure(function(rec, ssb, covar) {
		# The function to provide initial values
    res  <-coefficients(lm(c(log(rec/ssb))~c(ssb)))
    return(FLPar(a=max(exp(res[1])), b=-max(res[2]), c=0.0))},

  # lower and upper limits for optim()
	lower=rep(-Inf, 3),
	upper=rep( Inf, 3))

	model  <- rec~a*ssb*exp(-b*(1+c*covar[[1]])*ssb)

	return(list(logl=logl, model=model, initial=initial))}
################################################################################

#### Chunk 24 ##################################################################
nao     <-read.table("http://www.cdc.noaa.gov/data/correlation/nao.data", skip=1, nrow=62, na.strings="-99.90")
dnms    <-list(quant="nao", year=1948:2009, unit="unique", season=1:12, area="unique")
nao     <-FLQuant(unlist(nao[,-1]), dimnames=dnms, units="nao")

#### include NAO as covar (note that it must be a FLQuants with a single component
#### called ?covar? that matches the year span of the data) and adjust the model.

herSR         <-as.FLSR(her4)
model(herSR)  <-ricker()
herSR         <-fmle(herSR)

herCovA       <-as.FLSR(her4)
herCovA       <-transform(herCovA,ssb=ssb/1000,rec=rec/1000)
model(herCovA)<-rickerCovA()
covar(herCovA)<-FLQuants(covar=seasonMeans(trim(nao, year=dimnames(ssb(herCovA))$year)))
herCovA       <-fmle(herCovA,fixed=list(c=0))

summary(herCovA)

herCovB       <-as.FLSR(her4)
herCovB       <-transform(herCovB,ssb=ssb/1000,rec=rec/1000)
model(herCovB)<-rickerCovB()
covar(herCovB)<-FLQuants(seasonMeans(trim(nao, year=dimnames(ssb(herCovB))$year)))
herCovB       <-fmle(herCovB,fixed=list(c=0))

summary(herCovB)

AIC(her4RK)
AIC(herCovA)
AIC(herCovB)
################################################################################

#### Chunk 25 ##################################################################
#### Modified so AR(1) residuals
rickerAR1 <- function()
  {
  ## log likelihood, assuming normal log.
  logl <- function(a, b, rho, rec, ssb)
      loglAR1(log(rec), log(a*ssb*exp(-b*ssb)), rho=rho)

  ## initial parameter values
  initial <- structure(function(rec, ssb) {
		# The function to provide initial values
    res  <-coefficients(lm(c(log(rec/ssb))~c(ssb)))
    return(FLPar(a=max(exp(res[1])), b=-max(res[2]), rho=0))
	},
  # lower and upper limits for optim()
	lower=rep(-Inf, 3),
	upper=rep( Inf, 3)
	)

  ## model to be fitted
	model  <- rec~a*ssb*exp(-b*ssb)

	return(list(logl=logl, model=model, initial=initial))}

#### Fit
model(her4SR)<-rickerAR1()
her4AR1      <-fmle(her4SR)
################################################################################

#### Chunk 26 ##################################################################
# get the covariance matrix for steepness and virgin biomass
herCovar<-as.matrix(vcov(nsher)[,,1])

# calculate the lower trinagular decompostion
cholesky<-t(chol(herCovar))

cholesky

# generate a pair of random variates
c(params(nsher)[1:2,1])+cholesky%*%as.vector(rnorm(2))

# set up 1000 random variates
params(nsher)<-propagate(params(nsher),1000)

for (i in 1:1000)
   params(nsher)[c("s","v"),i]<-params(nsher)[c("s","v"),i]+cholesky%*%as.vector(rnorm(2))

#check that these come from the original distribution
var(mc.params)
herCovar

#plot
plot(   params(nsher)[c("s","v"),])
plot(mc.params[,"a"]~mc.params[,"b"])
################################################################################

#### Chunk 26 ##################################################################
## jacknife
srJK      <-nsherBH
rec(srJK) <-jacknife(rec(srJK))

## removes a data point from each iter
iter(rec(srJK),1)
iter(rec(srJK),2)
iter(rec(srJK),3)

## set initial starting values to be equal to the first fit
params(nsherBH)

## fits across all iters independently
srJK       <-fmle(srJK,start=params(nsherBH))

plot(params(srJK)["a"]~params(srJK)["b"],col="red",pch=19)

mfJK<-model.frame(FLQuants(hat=fitted(srJK),ssb=ssb(srJK)))

library(ggplot2)
p<-ggplot(mfJK, aes(x=ssb,y=hat,colour=iter))
p<-p + geom_line()
p<-p + geom_point()

## Standard Errors
jkSE<-function(a,b){
   (sum((a-b)^2)*(length(a)-1)/length(a))^.5
   }

jkSE(c(params(srJK)["a",]),c(params(nsherBH)["a",1,drop=T]))
################################################################################

#### Chunk 27 ##################################################################
dmns      <-dimnames(ssb(nsher))
dmns$iter <-1:100
mc.yrs    <-as.integer(sample(dmns$year,length(dmns$iter)*length(dmns$year),replace=T))

sr.bt       <-nsher
rec(sr.bt)  <-FLQuant(c(rec(sr.bt)[,ac(mc.yrs)]),dimnames=dmns)
ssb(sr.bt)  <-FLQuant(c(ssb(sr.bt)[,ac(mc.yrs)]),dimnames=dmns)
model(sr.bt)<-bevholtSV()

## fits across all iters independently
sr.bt       <-fmle(sr.bt,fixed=(list(spr0=0.045)))

plot(params(sr.bt)["s",]~params(sr.bt)["v",],col="yellow",pch=19)
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

nsher2 <- nsher
model(nsher2) <- myricker()

system.time(fmle(nsher))
system.time(fmle(nsher2))


