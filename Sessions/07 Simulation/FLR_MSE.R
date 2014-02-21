# FLR_MSE.R - DESC
# FLR_MSE.R

# Copyright 2003-2013 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, JRC
# $Id: $
# Created:
# Modified:

library(FLXSA)
library(FLBRP)

data(ple4)

iter <- 100
pyears <- 25

# MSE

# OM = ple4 from XSA
pom <- stf(ple4, pyears)
pos <- fmle(as.FLSR(ple4, model=bevholt))

# MP

for (y in 2009:(2009+2)) {

	# Data
	pst <- window(pom, end=y-1)
	
	# SA
	pix <- FLIndex(index=window(stock.n(pom)[2:6], end=y-1))
	range(pix)[c('startf', 'endf')] <- c(0.6, 0.75)
	pst <- pst + FLXSA(pst, FLIndices(ind=pix))
	
	# SR
	psr <- fmle(as.FLSR(pst, model=bevholt))

	# Reference point
	pbr <- brp(FLBRP(pst, sr=psr))

	# HCR
	pst <- stf(pst, 2)
	ctrl <- fwdControl(
		data.frame(year=y, quantity=c("f"),
			val=0.4)
		)
	pst <- fwd(pst, ctrl, psr)

	# IMP
	ctrl <- fwdControl(
		data.frame(year=y, quantity=c("catch"),
			val=c(catch(pst)[, ac(y)]))
		)
	pom <- fwd(pom, ctrl, pos)
}

# 
plot(pom)
