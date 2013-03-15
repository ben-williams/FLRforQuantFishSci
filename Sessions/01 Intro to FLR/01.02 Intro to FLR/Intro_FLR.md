% The FLR platform for quantitative fisheries science
% Iago MOSQUEIRA
% March 2013

# FLR

## What does FLR mean?

Maybe __F__isheries __L__ibrary in __R__

## What is FLR?

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
\includegraphics[keepaspectratio, height=0.7\textheight]{flr14.jpg}

# A brief history of FLR

- 2007-2009: The Silk Road to version 2
    - New FLQuant with 6 dimensions: uncertainty in structure
    - Rewrite of most methods
    - Extension of methods available
    - New classes: FLModel
    - Stronger use of class inheritance
    - Overhaul of man pages
    - Simplification of package map
- FLCore version 2.0 - January 2009
- FLCore version 2.2 - ??

# FLR 2.2 - *Swordfish Polka*

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{flr20.jpg}

# A brief history of FLR

- 2009-2011: Settling ideas with 2.4
    - Clean code
    - Stabilize FLModel/FLSR
    - Improve documentation and include vignettes
    - Lots of minor corrections and additions
    - Redesign website and review ’Teach Yourself FLR’

# FLR 2.4 - *The Duke of Prawns*

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{flr24.jpg}

# FLR development

FLR is a **collaborative development project**, where distinct scientists that constitute *the FLR Core Team* work simultaneously on code, documentation, etc.

- Development is managed through R-Forge
- Packages on repository
- Documentation on wiki
- Funding comes from a number of EU projects (FEMS, COMMIT, EFIMAS, Fisboat, UNCOVER, JRC)

# GNU project (http://gnu.org)

\centering

*Free software is a matter of liberty, not price*

\medskip

\Huge{free = free speech}

\medskip

\Huge{free != free beer}

# Collaboration and Open Source

"I think the real issue about adoption of open source is that \textbf{nobody can really ever 'design' a complex system}.  That's simply not how things work: people aren't that smart - nobody is.  And what open source allows is to not actually 'design' things, but let them \textbf{evolve}, through lots of different pressures in the market, and having the end result just \textbf{continually improve}"\newline

Linus Torvalds

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

# FLR goal

In detail, FLR aims to facilitate and promote research about:

- Stock assessment and provision of management advice
- Data and model validation through simulation
- Risk analysis
- Capacity development & education
- Promote collaboration and openness in quantitative fisheries science
- Support the development of new models and methods
- Promote the distribution of new models and methods to a wide public.

# Cut the crap, what is FLR?

- Extendable toolbox for implementing bio-economic simulation models of fishery systems
- Tools used by managers (hopefully) as well as scientists
- With many applications including:
    - Fit stock-recruitment relationships,
    - Model fleet dynamics (including economics),
    - Simulate and evaluate management procedures and HCRs,
    - More than just stock assessment (VPA, XSA, ICES uptake)
    - etc....

# R and FLR

Why do we use R?

- Existing platform for statistical modelling
- Good graphics capabilities
- Multi-platform
- Open source
- Links with compiled languages like fortran, C / C++ code for speed
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
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/scheme.png}

# MSE - The Lego block approach

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{MSE.png}

# Enough mambo jambo ! Who’s using it ?

In 2009 a simple survey showed that FLR was used in:

- ICES - 22+ stocks
- STECF - several including HCR studies
- AFMA - Northern Prawn Fishery
- CECAF - Istam project
- CCAMLR - Patagonian toothfish, Mackerel icefish
- GFCM - Deepwater pink shrimp, Hake in GSA 05
- ICCAT - Software catalogue, Bluefin CITES evaluations
- IOTC - Bigeye Tuna, Yellowfin Tuna
- NEAFC - Blue Whiting, NOSS Herring
- NAFO - Greenland Halibut, American Plaice, Cod in Placentia Bay
- a4a Initiative

# Open All !!

- Open Science
- Open Data
- Open Source
- Reproducible research
- Open Mind !!

# What’s next ?

\centering
\includegraphics[keepaspectratio, height=0.9\textheight]{flr30.jpg}

# More information

- Development is managed through R-Forge (http://r-forge.r-project.org/projects/flr/)
- Packages on repository (install.packages(repos="http://flr-project.org/R"))
- Documentation on wiki (http://www.flr-project.org)
- "Teach Yourself FLR" wiki (http://tyflr.flr-project.org)
- Funding comes from a number of EU projects (FEMS, COMMIT, EFIMAS, Fisboat, UNCOVER, JRC)
- FLR Core Team, aka "*Les miserables*", code, maintenance, tests, documentation, etc.

