Tutorial: Creating and manipulating FLQuant objects
===================================================

* * * * *

**Revisions**: *Iago Mosqueira, 25 April 2005; Finlay Scott and Jan Jaap
Poos, March 2008; Ernesto Jardim, 19/07/2010.*\
 **Versions**: *R 2.11.1; FLR 2.3 dev*

* * * * *


Introduction
------------

The first practical covers the most basic class in the `FLCore` library:
`FLQuant`. `FLQuant`s are the building blocks of nearly all of the
objects used in FLR and consequently understanding them is important.
The `FLQuant` class is essentially a six-dimensional array used to store
data of one particular type (e.g. catch data). To help us understand the
structure of the `FLQuant` class we will look at an example object.

To start, open an R session and load the `FLCore` library by issuing the
command:

~~~~ {.code .R}
library(FLCore)
~~~~

