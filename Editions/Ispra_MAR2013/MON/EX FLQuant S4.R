# EX FLQuant S4.R - DESC
# EX FLQuant S4.R

# Copyright 2003-2013 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, JRC
# $Id: $


library(FLCore)

# CREATE

# (1) Create an FLQuant object with elements numbered sequentially (i.e. 1 to N)
# and with ages from 1 to 6, years from 2003 to 2012 and four seasons

# (2) Create an FLQuant with dimensions 6,10,1,1,1,100 and lognormally-distributed
# random nunmbers

# SUBSET

# (3) Extract from flq the values for the first three years


# (4) Select from flq leaving out the sixth age


# (5) What if do not know the precise age names?


# APPLY

# Calculate the proportion-at-age per year

# COMPUTE

# How many values in flq are greater than 0?


# TRANSFORM

# EXTRA::PROGRAMMING

# Let's try programmoing a very simple population model

# First, an FLQuant for pop(ulation), age=1:6, year=1:20


# Assign an initial abundance by age with exponential decay


# We know very well F and M


# Loop over years and then ages to calculate numbers-at-age


# Plot population trends by age


# Create a weight-at-age FLQuant


# Calculate biomass-at-age


# Total biomass
