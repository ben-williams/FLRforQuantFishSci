% The FLR platform and the a4a initiative
% Iago MOSQUEIRA
% August 2014


# Why, oh why?

Schnute *et al.* (2007 and 1998) compared the number of software tools
and languages currently available for stock assessments with the Babel
tower myth and concluded that: "The cosmic plan for **confounding
software languages** seems to be working remarkably well among the
community of quantitative fishery scientists!"

# A brief history of FLR

- Started by FEMS EU project
- COMMIT & EFIMAS EU projects provided much of time and sweat
- Presented to ICES WG Methods 2004
- FLCore version 1.0 - December 2005
    - FLQuant with 5 dimensions, no "iter"
    - Release often, release early. Bugs galore
- FLCore version 1.4 - 2007
    - Stable, full of treats an joy

# FLR 1.4 - *The Golden Jackal*

\centering
\includegraphics[keepaspectratio, height=0.7\textheight]{graphics/WolfGoldenJackal.jpg}

# A brief history of FLR (cont.)

- 2007-2009: The Silk Road to version 2
    - New FLQuant with 6 dimensions: uncertainty in structure
    - Rewrite of most methods
    - Extension of methods available
    - New classes: FLModel
    - Stronger use of class inheritance
    - Overhaul of man pages
    - Simplification of package map
- FLCore version 2.0 - January 2009
- FLCore version 2.2 - 2010

# FLR 2.2 - *Swordfish Polka*

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/flr20.png}

# A brief history of FLR (cont. even more)

- 2009-2011: Settling ideas with 2.4
    - Clean code
    - Stabilize FLModel/FLSR
    - Improve documentation and include vignettes
    - Lots of minor corrections and additions
    - Redesign website and review ’Teach Yourself FLR’

# FLR 2.4 - *The Duke of Prawns*

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/flr24.png}

# Current

- FLR 2.5.*, in continuous development
- Changing package map, but
    - Classes are stable
    - New methods
    - Code does not brake
- Keep track of versions you used: local copies, github or packrat

# FLR 2.6 - *Black Swan*

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/theeraser.jpg}

# FLR development

FLR is a **collaborative development project**, where distinct scientists that constitute *the FLR Core Team* work simultaneously on code, documentation, etc.

- Development is managed through R-Forge
- Packages on repository
- Documentation on open website
- Funding has come from a number of EU projects (FEMS, COMMIT, EFIMAS, Fisboat, UNCOVER, JRC)

# GNU project (http://gnu.org)

\centering

*Free software is a matter of liberty, not price*

\medskip

\Huge{free = free speech}

\medskip

\Huge{free != free beer}

# Collaboration and Open Source

> I think the real issue about adoption of open source is that **nobody can really ever 'design' a complex system**.  That's simply not how things work: people aren't that smart - nobody is.  And what open source allows is to not actually 'design' things, but let them **evolve**, through lots of different pressures in the market, and having the end result just **continually improve**

Linus Torvalds

\flushright
\includegraphics[keepaspectratio, height=0.3\textheight]{graphics/askmeOA.png}

# Mission statement

The FLR project provides a **platform for quantitative fisheries
science** based on the R statistical language. The guiding principles of
FLR are:

- **openness** - through community involvement and the open source ethos
- **flexibility** - through a design that does not constrain the user to a given paradigm
- **extendibility** - through the provision of tools that are ready to be personalized and adapted.

# FLR goal

To **promote and generalize** the use of **good quality, open source,
flexible software** in all areas of quantitative fisheries research and
management advice, with a key focus on Management Strategies Evaluation.

# FLR aims

In detail, FLR aims to facilitate and promote research about:

- Stock assessment and provision of management advice
- Data and model validation through simulation
- Risk analysis
- Capacity development & education
- Promote collaboration and openness in quantitative fisheries science
- Support the development of new models and methods
- Promote the distribution of new models and methods to a wide public.

# Really, what is FLR?

- Extendable toolbox for implementing bio-economic simulation models of fishery systems
- Tools used by managers (hopefully) as well as scientists
- With many applications including:
    - Fit stock-recruitment relationships,
    - Model fleet dynamics (including economics),
    - Simulate and evaluate management procedures and HCRs,
    - More than just stock assessment (VPA, XSA, ICES uptake)
- A software platform for quantitative fisheries science
- A collection of R packages
- A team of devoted developers
- A community of active users

# R and FLR

Why do we use R?

- Existing platform for statistical modelling
- Good graphics capabilities
- Multi-platform
- Open source
- Links with compiled languages like Fortran, C / C++ code for speed
- Easily extendable in the form of ’packages’

<!--# Object oriented programming with S4-->

<!--- A programming language model organized around "objects" rather than "actions"-->
<!--- Uses R S4 classes-->
<!--- Everything is an object of a particular class-->
<!--- Objects have:-->
<!--    - members (data) and-->
<!--    - methods (functions associated with it that act on member data)-->
<!--- Inheritence used to extend and create new classes (FLSR inherits from FLModel)-->
<!--- Classes can be members of other classes (most FLR classes include FLQuants as members)-->

# Design principles

- Classes to represent different elements of fisheries systems
- ’physical’ objects (e.g. FLStock class represents a fish stock)
- ’methodological’ objects (e.g. FLBRP class containing methods to calculate BRP)
- Link objects to create simulations - Lego blocks (MSE example)
- Learning curve: trade off between flexibility and simplicity (no black boxes and no handle turning)

<!--# FLR & S4-->

<!--\centering-->
<!--\includegraphics[keepaspectratio, height=0.8\textheight]{intro2FLR-001}-->

# Packages

\centering
\includegraphics[keepaspectratio, width=0.95\textwidth]{graphics/flrpkgs.png}


# a4a - Assessment for All

## Long term vision

- Standard methods to apply rapidly to a large number of stocks
- No strong statistical technical background
- Using technical knowledge on the fisheries, stocks and ecosystem

## Why

- Demand for abundance and exploitation estimates
- Large investments in collecting information
- Scientific advice for fisheries management.


# a4a - Sampled species (PT)

\centering
\includegraphics[keepaspectratio, height=0.6\textheight]{graphics/pt.png}

> **What if we have to assess hundreds of stocks?**
>	Estimate what you know, simulate what you don't

# a4a Initiative EC JRC

1. Develop a4a SA method
2. Discussion on *massive* stock assessment
3. Capacity building (this course)

\centering
<https://fishreg.jrc.ec.europa.eu/web/a4a>

# a4a SA model

- *Moderate* data stock (Catch, Survey/CPUE, little bio)
- NL CaA model, R/FLR/ADMB
- *Simple* syntax

```r
> fmodel = separable()
> qmodel = trawl(techcreep=0.03)
> rmodel = beverton(a=s(NAO))
```

# a4a MSE

Building an STANDARD MSE

1. OM uncertainty in growth, S/R and selectivity
2. HCRs based on catch, surveys, assessments
3. Assessment models of increasing complexity
4. OE for catch and index
5. IE in F or catch

# MSE - The Lego block approach

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/MSE.png}

# Who’s using it ? (2009)
- ICES - 22+ stocks
- STECF - Several including MP & HCR studies
- AFMA - Northern Prawn Fishery
- CECAF - Istam project
- CCAMLR - Patagonian toothfish, Mackerel icefish
- GFCM - Deepwater pink shrimp, Hake in GSA 05
- ICCAT - Bluefin CITES evaluations, Swordfish, Albacore
- IOTC - Albacore
- NEAFC - Blue Whiting, NOSS Herring
- NAFO - Greenland Halibut, American Plaice, Placentia Cod
- EC -  Evaluation of new CFP
- JRC - a4a Initiative, STECF work

# Open All !!

- Open Science
- Open Data
- Open Source
- Reproducible research
- Open Mind !!

#

\centering
\includegraphics[keepaspectratio, height=0.85\textheight]{graphics/flr30.png}

# More information

- [FLR Project @ http://flr-project.org](http://flr-project.org)
- [Source code @ http://github.com/flr/](http://gtihub.com/flr/)
- `install.packages(repos="http://flr-project.org/R")`

#

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/keep-calm-and-code-flr.png}
