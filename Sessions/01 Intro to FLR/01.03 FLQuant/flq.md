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

and then load the included dataset, `ple4`.

~~~~ {.code .R}
data(ple4)
~~~~

Don't worry about what `ple4` is for the moment (it is actually a
composite object of type `FLStock` and will be covered later). We can
now extract a single `FLQuant` from this object to use in our
exploration. Let's call it `fq`:

~~~~ {.code .R}
fq <- catch.n(ple4)
~~~~

To have a look at `fq` simply type:

~~~~ {.code .R}
fq
~~~~

You may find that `fq` does not all fit on the screen at once. Use the
scroll bars to look at it if necessary. You should see that `fq` looks
like a two-dimensional array, with dimension names `age` (from 1 to 15)
and `year` (from 1957 to 2001). Although the data in `fq` only appears
to have two dimensions, the data array of an `FLQuant` actually always
has six dimensions. However, often one or more of them will be
collapsed. For example, the data stored in the `fq` object is only
disaggregated by two dimensions `age` and `year`. The remaining four
dimensions are collapsed and have length 1. You can see this by printing
the dimensions of `fq`:

~~~~ {.code .R}
dim(fq)
~~~~

The name of the first dimension of the data is not set and can be
altered by the user. For example, the name could be `age`, `length`,
`vesselclass` etc. In `fq` the first dimension is named `age`. Any
character string is accepted, but it should contain no spaces. When not
set it is usually refered to as the `quant` of the FLQuant. The
remaining five dimensions have fixed names. The six dimensions of an
FLQuant are, in this order:

-   user defined (or `quant`)
-   `year`
-   `unit`
-   `season`
-   `area`
-   `iter`

`year` needs no explanation. `unit` is open to any sort of division that
might be of use, like male/female disaggregation, substocks etc.
`season` and `area` allow for time and space subdivisions. `iter` is for
storing iterations, for example, as the result of a Monte Carlo
simulation.

The data in an `FLQuant` is stored as an array in an unamed slot.
Although it can be directly accessed, as `objectname@.Data`, it is
better to use the available methods for selecting, subsetting and
modifying FLQuants. Otherwise some of the operations might not return a
proper `FLQuant`, but simply an object of class 'array'.

As well as the data `FLQuant` also has an attribute, called `units`.
This is a character string that stores information about the units of
measurement of the data. The units of `fq` are currently set as
“thousands”. Do not confuse units with the `unit` dimension. Users are
allowed to use any name they wish, but standard names are encouraged as
they allow for clear interpretation. For example:

-   Mass: `“kg”`, `“t”`
-   Length: `“cm”`, `“m”`
-   Numbers: `“1”`, `“1000”`, `“10e6”`
-   Proportions: `“prop”`
-   Currency: `“euro”`, `“dollar”`
-   Not Applicable: `“NA”`

Although FLQuant objects can be created without units, some methods make
use of the information stored in this slot if it is available.

Creating FLQuants: FLQuant()
----------------------------

Now that we have looked at the structure we will have a look at how to
create `FLQuant` objects. Objects of any class can be created in `R` by
a call to the `new()` function, as in:

~~~~ {.code .R}
fq <- new("FLQuant")
~~~~

However, this is of only limited use as it does not allow us to specify
the dimensions of the data array (have a look at the new `fq` in R to
see this). Instead a creator function is provided which allows for more
flexibility when creating new objects. It's use is especially encouraged
when writing new functions and methods. The function 'FLQuant()' creates
new `FLQuant` objects and can take a number of input parameters. For
example, the dimensions of the new object can be specified through the
`dim` argument:

~~~~ {.code .R}
fq <- FLQuant(dim=c(8,15,1,1,1,1))
~~~~

This creates an `FLQuant` with an empty data array of size 8 x 15 with
the last four dimensions (`unit`, `season` and `area`) collapsed. Again,
simply type `fq` in R to see this. The `units` of an FLQuant can also be
set in the call to the creator function, for example:

~~~~ {.code .R}
fq <- FLQuant(dim=c(8,15,1,1,1,1), units='kg')
~~~~

Another way of creating an `FLQuant` object of the required size is to
specify its dimension names directly:

~~~~ {.code .R}
fq <- FLQuant(dimnames=list(age = 1:8, year = 1998:2005, unit = 'unique', season = 'all', area = 'unique'))
~~~~

This also sets the name of the first dimension to `age`. Alternatively,
when the name of the first dimension has not been set through the use of
the `dimnames` argument, it is possible to use the `quant` argument:

~~~~ {.code .R}
fq <- FLQuant(dim=c(6,8,1,1,1,1), quant='length')
~~~~

Of course all the previous arguments can be combined, although some
overlaps exist. For example, if `dimnames` is used, the value of `quant`
is ignored.

All the `FLQuant`s we have created until now have no data in them, only
the not-available expression `NA`. Although we will see later how to
introduce values into an `FLQuant` object already in our workspace, we
can also create them with data already in them. The `FLQuant()` function
accepts objects of class `vector`, `matrix` and `array`. In the simplest
case, an object can be created with a single value:

~~~~ {.code .R}
fq <- FLQuant(0.2, dim=c(6,8,1,1,1,1), quant='age')
~~~~

If a vector is input, it is taken to go along the first dimension:

~~~~ {.code .R}
fq <- FLQuant(seq(3, 98, length=8), dim=c(6,8,1,1,1,1), quant='age')
~~~~

and the vector is reused as many times as needed.

Matrices can also be input in this way:

~~~~ {.code .R}
fq <- FLQuant(matrix(1:48, ncol=8), dim=c(6,8,1,1,1), quant='age')
~~~~

as can arrays, where `dim` and `dimnames` are now part of the `array()`
command:

~~~~ {.code .R}
fq  <-  FLQuant(array(1:96, dim=c(6,8,1,1,2), dimnames=list(age = 0:5, year = 1998:2005,
    unit = 'unique', season = 'all', area = c('north', 'south'))), units='kells')
~~~~

If no length is given for a dimension when creating an FLQuant, the
default length of 1 is used. For example, to create an `FLQuant` which
has only 10 ages:

~~~~ {.code .R}
fq <- FLQuant(10,dim=10, quant='age')
~~~~

Modifying FLQuants
------------------

Now we know how to create an `FLQuant` object we need to know how to
manipulate it.

### Accessing and assigning .Data and subsetting

Of particular interest to us is being able to access and assign data in
the array. To demonstrate this first of all create an `FLQuant` using
one of the slots of `ple4` again:

~~~~ {.code .R}
fq <- catch.n(ple4)
~~~~

The main method for accessing part of the data contained in an `FLQuant`
is through the subsetting operator ”[”, for example:

~~~~ {.code .R}
fq[1:4,1:8,1,1,1,1]
~~~~

This returns the part of `fq` with the specified dimensions. The
returned object is also an `FLQuant`. Numbers can be ommited for any
dimension that is not to be subset. For example, `fq[1:4,,,,]` is
equivalent to `fq[1:4,1:45,1,1,1,1]`. Another short cut allows you to
also omit the commas for the dimensions that are not to be subset. For
example, `fq[1:4]`.

An important consideration is the use of numbers or characters when
subsetting. The previous example used numbers to refer to the positions
along the dimensions in the object. It is also possible to use
characters. For example, if we were to select the last five years from
the `fq` object, we could do any of these:

~~~~ {.code .R}
fq[,41:45,,,,]
fq[,c('1997', '1998', '1999', '2000', '2001'),,,,]
fq[,as.character(1997:2001),,,,]
~~~~

To assign values to the data array the subsetting operator is also used.
For example, a selected part of an `FLQuant` can be modified at will:

~~~~ {.code .R}
fq[,41:45,,,,] <- 99
~~~~

Logical subsetting can also be used to reference particular elements in
the array. However, it is limited to assigning new values, otherwise the
returned object might not be a valid `FLQuant`. For example, to assign a
zero to every element in the array that is currently equal to 99 use:

~~~~ {.code .R}
fq[fq==99] <- 0
~~~~

### Checking and changing quant and units

Both the name of the first dimension (the quant) and the content of the
units attribute slot can be checked and altered using the `quant()` and
`units()` methods:

~~~~ {.code .R}
quant(fq)
quant(fq) <- 'age'
units(fq)
units(fq) <- 't'
~~~~

### window

Selection and extension of an `FLQuant` object along the `year`
dimension can be carried out with the `window()` method. This methods
accepts four arguments, that set the first (`start`) and last years
(`end`), the size of the steps along the `year` dimension (`frequency`,
set by default to 1), and a logical that determines whether an object
can be extended past it's current size or not (`extend`), set by default
to `TRUE`. When an object is extended, new columns are filled with `NA`.
The following example starts with creating a new, small `FLQuant` filled
with random numbers:

~~~~ {.code .R}
fq <- FLQuant(rnorm(20), dim=c(4,5,1,1,1,1), units='kg', quant='age')
window(fq, start=1, end=3)
window(fq, start=1, end=6)
window(fq, start=2, end=8, frequency=2)
~~~~

### propagate

Increases the number of iterations of an `FLQuant`. The new iterations
can either be left empty (`fill.iter=FALSE`) or filled with the contents
of the first iteration (`fill.iter=TRUE`).

~~~~ {.code .R}
fqp1 <- propagate(fq,iter=10,fill.iter=FALSE)
# or using fill.iter=TRUE
fqp2 <- propagate(fq,iter=10,fill.iter=TRUE)
~~~~

### iter

Returns a single iteration of an `FLQuant`. This allows us to check the
difference between the fill.iter of the propagate method shown earlier

~~~~ {.code .R}
iter(fqp1,2)
iter(fqp2,2)
 
# iter selects an individual iteration or a number of them
iter(fqp1, 1)
iter(fqp1, 1:10)
~~~~

### dimnames

Dimension names of an `FLQuant` can be extracted by a call to
`dimnames()`. Return argument is of type `list`, with named slots for
each dimension. Dimnames can also be changed by calling the equivalent
assigment function, `dimnames()←`, whose input must also be of type
`list`.

~~~~ {.code .R}
dimnames(fq)
dimnames(fq) <- list(length=0:3)
~~~~

### as.data.frame

`FLQuant`s can be transformed into a plain table representation by using
the `as.data.frame()` method. This allows the data contained in an
`FLQuant` to be transferred to a spreadsheet or used as an input in
other programs. The output format of the method is a table with rows
representing all datapoints and columns for the various subsetting
dimensions (quant, year,…) plus a final column for the data itself. For
example, `fq` used in the previous example can be output using:

~~~~ {.code .R}
ft <- as.data.frame(fq)
~~~~

would look like this (although of course the random data will be
different in your example):

  -    quant   year   unit     season   area     iter   data
  ---- ------- ------ -------- -------- -------- ------ -------------
  1    1       1      unique   all      unique   1      0.63234553
  2    2       1      unique   all      unique   1      -0.89618142
  3    3       1      unique   all      unique   1      -1.22502327
  4    4       1      unique   all      unique   1      -0.75254444
  5    1       2      unique   all      unique   1      2.77417549
  6    2       2      unique   all      unique   1      0.18360495
  7    3       2      unique   all      unique   1      0.92097701
  8    4       2      unique   all      unique   1      -0.16115386
  9    1       3      unique   all      unique   1      1.53798393
  10   2       3      unique   all      unique   1      -0.86653307
  11   3       3      unique   all      unique   1      -0.40330099
  12   4       3      unique   all      unique   1      -2.61916590
  13   1       4      unique   all      unique   1      -0.03588982
  14   2       4      unique   all      unique   1      -0.62864777
  15   3       4      unique   all      unique   1      -0.62982104
  16   4       4      unique   all      unique   1      0.52091113
  17   1       5      unique   all      unique   1      -0.14076415
  18   2       5      unique   all      unique   1      -0.73912457
  19   3       5      unique   all      unique   1      -1.53881385
  20   4       5      unique   all      unique   1      0.54735022

Calculations with FLQuants
--------------------------

As well as directly assigning values to `FLQuant` objects it is also
possible to perform basic calculations with them.

### Basic algebra

The basic mathematical operations work on an `FLQuant` as they would on
an array in R. Summation and substraction work as expected for two
arrays of the same dimensions, element by element, for example:

~~~~ {.code .R}
fq <- FLQuant(90, dim=c(5,9,1,2,1,1)) - FLQuant(30, dim=c(5,9,1,2,1,1))
flq <- FLQuant(90, dim=c(5,9,1,2,1,1)) * FLQuant(30, dim=c(5,9,1,2,1,1))
 
fq <- FLQuant(90, dim=c(5,9,1,2,1,1)) * FLQuant(30, dim=c(5,9,1,2,1,1))
 
#or calculate squares of all values in an FLQuant
flq ^ 2
~~~~

### apply

To use a certain function over a numbers of dimensions of an array or
`FLQuant` object, the `apply` method can be used. The function to apply
should calculate a summary of the input data, such as `mean` or `sum`.

~~~~ {.code .R}
# the second argument is the dimension over which apply works, this can be any numeric vector 
apply(fq, 2:6, sum)
apply(fq, c(1,3), mean)
~~~~

Using `apply` with `FLQuant` objects is intended to behave as using
`apply` with standard R arrays. Many of the common `apply` methods have
been defined for `FLQuant` objects including `quantSums`, and
`quantMeans`. For an upto date list use `help(quantSums)`. It should be
noted that these `quantSums` methods are generally faster than apply.
However, apply is more flexible in defining the dimensions over which
functions will be applied.

~~~~ {.code .R}
quantSums(fq)
quantMeans(flq)
~~~~

Inspecting FLQuants
-------------------

Several methods exist for inspecting `FLQuant` objects.

### summary

This method outputs to screen a brief summary of an object's dimensions
as a named list:

~~~~ {.code .R}
fq <- FLQuant(rnorm(3),dimnames=list(length=1:10, year=1990:1992, unit='unique', season='all', area='unique'),units='kg')
summary(fq)
~~~~

### show

The show method controls the output obtained when an object name is
invoked directly at the prompt. It is the simplest method for visually
inspecting an object contents.

~~~~ {.code .R}
fq <- FLQuant(rnorm(90), dim=c(5,9,1,2,1))
show(fq)
~~~~

If FLQuants have more than one iteration, `show` will display the
median, followed by the median absolute deviation (see also `?mad`). For
example,

~~~~ {.code .R}
fq <- FLQuant(rnorm(90), dim=c(5,3,1,2,1,3))
show(fq)
~~~~

### dims

The dimensions of an `FLQuant` can be obtained by a call to `dim()`. The
return value is a vector of length 6 with the lengths of each of the six
dimensions.

~~~~ {.code .R}
fq <- FLQuant(rnorm(90), dim=c(5,9,1,2,1,1))
dim(fq)
 
# alternatively, one can get information on the dimensions in a list, using the dims() method.
# this returns a list with lengths, minima and maxima
dims(fq)
~~~~

### plot

A basic plot is provided for `FLQuant` objects. It gives a simple visual
overview of the data.

~~~~ {.code .R}
plot(fq)
~~~~

Which you can tweak to look better or add more information.

~~~~ {.code .R}
plot(fq, main="My first flquant plot")
~~~~

Useful functions for the 6th dimension
--------------------------------------

There are several methods for showing or creating variance in FLQuants

### cv

the coefficient of variation method can be used on FLQuant to get the cv
of the values along the 6th dimension

~~~~ {.code .R}
# an object could be created with iterations by either
fli <- FLQuant(rnorm(200), dim=c(6,20,1,1,1,100), quant='age', units='kg')
# or
fli <- FLQuant(rnorm(200), dim=c(6,20), quant='age', units='kg', iter=100)
 
# a number of summaries and statistics are available for iter,
# like CV,
cv(fli)
~~~~

### quantiles

Also, quantiles can be estimated in the statistical distribution of the
values in the 6th dimension

~~~~ {.code}

# quantile
quantile(fli, 0.05)
quantile(fli, 0.95)
~~~~

Also, the iterations can be filled using the standard random number
generators in R

~~~~ {.code}
flq <- FLQuant(array(rnorm(100), dim=c(5,10)), dimnames=list(year=1990:1999), quant='age')

# the existence of iter opens up a simpler use of RNGs
rnorm(100, flq, flq^2)
rnorm(100, flq, 2)
rlnorm(100, flq, flq^2)
~~~~

### Simplifying with FLQuantPoint

Using FLQuantPoint can simplify FLQuant objects with multiple iterations

~~~~ {.code .R}
flq <- FLQuant(rnorm(200), dim=c(6,20,1,1,1,100), quant='age', units='kg')
flp <- FLQuantPoint(flq)
 
flp
summary(flp)
plot(flp)
 
# the 5 elements (mean, median, var, lowq, uppq) along iter can be inspected using
iters(flp)
 
# and each of them can be extracted
mean(flp)
lowq(flp)
 
# and modified
mean(flp) <- mean(flp)*2
 
# FLQuant objects can be generated once we assume a probability distribution
rnorm(20, flp)
~~~~

Summary
-------

This ends the `FLQuant` tutorial. `FLQuant` are the basic unit of many
FLR classes. Essentially an FLQuant object only has two components: a
six dimensional data array (of which four dimensions are often
collapsed, thus rendering it an easy to visualise two dimensional array)
and a unit description. There are several different methods for
creating, modifying and inspecting `FLQuant` objects. Knowing how to
effectively use these methods will improve your use of the FLR system.
