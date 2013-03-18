% Loading data into FLR
% Finlay Scott
% March 2013

# Loading your data into FLR

# Different paths

\includegraphics[keepaspectratio, width=\textwidth]{graphics/data_input.png}

# Dedicated FLR import functions

Data needs to be in specific format

* `readVPAFile()`
* `readFLStock()` : Lowestoft VPA, ICA, Adapt, CSA
* `readFLIndex()`
* `readFLIndices()`
* `readMFCL()`
* `readADMB()`

# Standard R import functions

http://cran.r-project.org/doc/manuals/R-data.html 

* CSV files : 'read.table()`
* Text files : `scan()`
* Database : `RODBC` package
* Direct link to spreadsheets : `excel.link`, `RExcelInstaller` packages
