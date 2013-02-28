# intro_flr - «Short one line description»
# intro_flr

# Copyright 2009 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# To install the main FLR package, 'FLCore' from the repository
install.packages(repos="http://flr-project.org/Rdevel")

# Load the package
library(FLCore)


# Create an empty FLQuant, the 6D array used for storing (almost) all data in FLR
FLQuant()

# Now with 40 normal random numbers, 4 ages and 10 years
FLQuant(rnorm(40), dim=c(4,10), dimnames=list(age=1:4, year=1990:1999))

# units of measurement can also be recorded
flq <- FLQuant(abs(rnorm(40))*10, dim=c(4,10), dimnames=list(age=1:4, year=1990:1999), units="kg")

# FLQuant objects can be inspected in various ways,
summary(flq)
units(flq)
quant(flq)

# ploted,
plot(flq)

# used in various operations,
flq + flq
flq ^ 2

# subset by index ...
flq[1:2,]
flq[1:2,,,,,]
flq[,1:5]
flq[1,drop=TRUE]

# ... or name.
flq[, '1995']

# Values can be modified
flq[1, 1] <- 9

# as can dimnames,
dimnames(flq) <- list(year=2000:2009)
flq

# the name of the first dimension,
quant(flq) <- 'length'
quant(flq) <- 'age'

# and the 'units'
units(flq) <- 't'

# Objects can also be extended along 'year',
window(flq, start=2000, end=2010)

# or any other dimension,
expand(flq, age=1:6)

# and can be trimmed too
trim(flq, age=1:3)

# Funtions can be applied to it
apply(flq, 2:6, sum)

# flQuant can also work on multiple iterations : 
fqp1 <- propagate(flq,iter=10,fill.iter=FALSE)
# or using fill.iter=TRUE
fqp2 <- propagate(flq,iter=10,fill.iter=TRUE)
#see the difference : 
iter(fqp1,2)
iter(fqp2,2)


# and it can used to generate random numbers
rnorm(10, flq, flq/2)   
ff <- rlnorm(20, flq, 0.03)

#check the dimensions
dim(flq)

# The objects thus created have 'iters', i.e. length > 1 on dim[6]
flq <- rnorm(10, flq, flq/2)
dim(flq)

#useful functions for the 6th iteration :
cv(flq)
quantile(flq)
quantile(flq,0.5)

# All lattice plot functions are overloaded for FLQuant
xyplot(data ~ year| as.factor(age), flq)
bwplot(data ~ year| as.factor(age), flq)

# The FlQuant 'building block' is used to create complex classes
# that represent various elements of the fishery system.
# For example, class 'FLStock' represents our view of what goes on
# with a fish population.

# We can inspect an example FLStock object available in FLCore
data(ple4)

summary(ple4)

plot(ple4)

# Each element in the summary is a 'slot' of a certain class. Those with
# numerical data are of class 'FLQuant'. They can be extracted through an
# accessor method of the same name as the slot
catch(ple4)
stock.n(ple4)

# methods exist to carry out common calculations
ssb(ple4)

# Methods exist that operate on the whole FLStock object, like subsetting
summary(ple4[,1])

# Other classes exist for other elements, like:
# - Stock-recruitment relationship
data(nsher)

summary(nsher)

model(nsher) <- 'ricker'

nsher <- fmle(nsher)

plot(nsher)

summary(nsher)

params(nsher)

AIC(nsher)


# etc. Use the help pages of FLCore
?FLCore

# or visit http://flr-project.org for a list of tutorials covering
# FLR classes,methods and other packages
