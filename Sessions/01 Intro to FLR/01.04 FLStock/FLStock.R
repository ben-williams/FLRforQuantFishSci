# FLStock.R - DESC
# FLStock.R

# Copyright 2013 FISHREG. Distributed under the GPL 2 or later
# Maintainer: FISHREG, JRC
# $Id: $

# XX {{{
# }}}


# Class structure
# load data from Plaice stocks in N Atlantic ICES area IV

data(ple4)

help("FLStock-class")

class(ple4)

slotNames(ple4)


ggplot(data=catch.n(ple4))+geom_line(aes(year, data, color=factor(age)))
ggplot(data=catch.wt(ple4))+geom_line(aes(year, data, color=factor(age)))
ggplot(data=catch(ple4))+geom_line(aes(year, data, color=factor(age)))


name(ple4)
desc(ple4)
range(ple4)

# catch =~ landings + discards
ple4@landings+ple4@discards
ple4@catch

# data & results

# *, *.n & *.wt
ple4@catch.n
sum(ple4@catch.n[,"2001",,,,] * ple4@catch.wt[,"2001",,,,])

ple4@catch[,"2001",,,,]

# m, m.spwn
ple4@m # natural mortality

ple4@m.spawn # fraction of the natural mortality ocurring before spawning

# harvest, harvest.spwn
# stock


# Methods
# ple4

#Methods: computing discards, landings and catch
discards(ple4) <- computeDiscards(ple4)

# summary & plot
# transform

#  window, [, qapply
# Check year range # window()

range(ple4)
smallple4 <- window(ple4, start = 1979, end = 2001)

# Check new year range
range(smallple4)
plot(smallple4)

# SUBSET
temp<-ple4[,c("1998", "1999", "2000", "2001")]
# or
temp<-ple4[,as.character(1998:2001)]

# many FLQuant methods also available at this level
summary(propagate(ple4, 10))

summary(ple4[,'1990'])

summary(trim(ple4, year=1990:1999))

summary(expand(ple4, year=1957:2057))


# replace using logical values
ple4@catch[[20]]<-99
plot(ple4@catch)
ple4@catch[ple4@catch==99] <- 100000
plot(ple4@catch)

# summary of a FLStock
summary(ple4)

# plot and FLStock
# the default
plot(ple4)

# or individual parts
plot(stock(ple4))
plot(ple4@stock)
plot(ple4@landings)

# Methods for usual computations

# rec = stock.n[rec.age=first.age,]
rec(ple4)

# Calculate Spawning Stock Biomass (SSB)
# SSB = stock.n * exp(-F * F.spwn - M * M.spwn) * stock.wt * mat
ssb(ple4)

object<-ple4
colSums(object@stock.n * exp(-object@harvest * 
  object@harvest.spwn - object@m * object@m.spwn) * 
	object@stock.wt * object@mat, na.rm = FALSE)

getMethod("ssb", "FLStock")

# Fbar = mean(F between fbar ages)
fbar(ple4)
getMethod("fbar", "FLStock")

# fapex = max F per year
fapex(ple4)

# ssbpurec = SSB per unit recruit
ssbpurec(ple4)

# r = stock reproductive potential
r(ple4)

# survprob = survival probabilities by year or cohort
survprob(ple4)
survprob(ple4, by ='cohort')
plot(survprob(ple4))

# coercion
# as.FLSR
ple4SR<-as.FLSR(ple4)
summary(ple4SR)

# METHODS convert to data frame
# entire FlStock
temp<-as.data.frame(ple4)
summary(temp)

# or only some slots
as.data.frame(ple4@catch)
as.data.frame(ple4@catch.n)


# calculations: ssb, fbar
# summary & plot
# transform
#  window, [, qapply
# coercion
# as.FLSR


# Constructor

