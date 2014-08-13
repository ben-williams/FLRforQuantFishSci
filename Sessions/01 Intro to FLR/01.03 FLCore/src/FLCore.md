% The FLCore package of FLR
%
% August 2014

# FLCore in FLR
\centering
\includegraphics[keepaspectratio, width=0.95\textwidth]{graphics/flrpkgs.png}

# OOP basics

* Class: `data.frame`, `vector`, `matrix`
* Method: `plot`
* Signature: `plot(data.frame)` vs. `plot(vector)`

\flushright
\includegraphics[keepaspectratio, height=0.5\textheight]{graphics/oop.png}

# S4 classes

* Fuller OOP mechanism in R
* Extension of S3
* Used extensively by FLR

# Basic classes

* FLArray, **FLQuant** & FLCohort
* **FLPar**
* FLQuantPoint

# Composite classes

* **FLStock**
* **FLSR**
* **FLIndex**
* FLBiol
* FLFleet

# Plural classes

Lists with all elements being of the same class

* **FLQuants**
* **FLStocks**
* **FLIndices**
* FLBiols

# Current status

* Version 2.5.* in development
* Currently has
  * 12,351 lines of code
	* Exports 28 classes
	* 289 methods
	* 7 datasets
