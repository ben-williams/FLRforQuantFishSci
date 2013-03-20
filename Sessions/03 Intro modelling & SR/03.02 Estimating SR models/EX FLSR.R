

# Let's look something with a better relationship
data(nsher)

plot(ssb(nsher), rec(nsher))

summary(nsher)

###  EX1
# part a)
# Fit a Ricker, a Beverton and Holt and a Segmented regression stock recruit model
# to north Sea herring data

# part b)
# which gives the best fit according to AIC?
# which gives the best fit according to BIC?
# HINT - the better the fit, the lower the value


data(ple4)

### EX2 
# Using the ple4 data, fit a beverton and holt model and predict recruitment in 2009


### EX3
# Using the ple4 data, fit a segmented regression model with the b parameter fixed at 200,000

##solutions

# 1a)

data (nsher)

# make copies of the nsher object to store the results of the different fits
nsherRK <- nsherBH <- nsher

# set one copy to use the ricker model
model(nsherRK) <- ricker()
# estimate the parameters of the ricker model
nsherRK <- fmle(nsherRK)

# set one copy to use the ricker model
model(nsherBH) <- bevholt()
# estimate the parameters of the ricker model
nsherBH <- fmle(nsherBH)


# 1b)

AIC(nsherRK)
# -27.7245
AIC(nsherBH)
# -20.40036
 
BIC(nsherRK)
# -24.11118
BIC(nsherBH)
# -16.78703

# in both cases the ricker model gives a better fit to the data.

## note on other criteria:  It is often recomended to use a corrected version of AIC called AICc - 
## however, if the models being tested have the same number of parameters your conclusions will not change
## also AICc is valid for linear models with normally distributed errors: stock recruit models are non-linear which complicates things
## for more info on model choice look for a book by Burnham and Anderson.

# 2)
# Using the ple4 data, fit a beverton and holt model and predict recruitment in 2009

# load plaice data
data(ple4)
# convert the FLStock object to an FLSR object
plesr <- as.FLSR(ple4)

# set the model to bevholt
model(plesr) <- bevholt()
# fit the model
plesr <- fmle(plesr)

# now - for recruitment at age 1 in 2009 - we need to predict using the SSB in 2008
newrec <- predict(plesr, ssb = ssb(ple4)[,"2008"])

# 3)
# Using the ple4 data, fit a segmented regression model with the b parameter fixed at 200,000

# make a copy of the plaice FLSR objecr
pleSegreg <- plesr
# set the model to segmented regression
model(pleSegreg) <- segreg()

# fit the model with the b param fixed at 200000
pleSegreg <- fmle(pleSegreg, fixed = list(b = 200000))


params(pleSegreg)


