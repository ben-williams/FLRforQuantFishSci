% Training Course **USING FLR FOR QUANTITATIVE FISHERIES ADVICE**
% FISHREG - European Commission Joint Research Centre
% March 2013

# The FLStock class



An FLStock is mean to represent the population dynamics of a given stock. The quantitative data that need to be measured and  popultate the FlStock are the following 
All quantities in a stock are stored in FLQuant objects. This allows for storage of by e.g. age or length, in years, units, seasons and areas.

catch        # FLQuant holding the total catch (landings plus discards) in weight for all quants

catch.n      # FLQuant holding the catch in numbers by quant

catch.wt     # FLQuant holding the weight at quant in the catch, usually obtained from those for landings and discards

discards     # FLQuant holding the total discards in weight for all quants

discards.n   # FLQuant holding the discards by quant in numbers

discards.wt  # FLQuant holding the weight at quant of the discards

landings     # FLQuant holding the total landings for all quants

landings.n   # FLQuant holding the landings in numbers by quant

landings.wt  # FLQuant holding the weight at quant of landings

stock        # FLQuant holding the stock weight for all quants. Usually obtained from an assessment method

stock.n      # FLQuant holding the stock numbers by quant, output from a quant-structured assessment method

stock.wt     # FLQuant holding the weights at quant in the stock

m            # FLQuant holding the natural mortality by quant

mat          # FLQuant holding the maturity by quant, usually as a proportion

harvest      # FLQuant holding the harvest mode rate by quant

harvest.spwn # FLQuant holding the fraction of the harvest mode ocurring before spawning

m.spwn       # FLQuant holding the fraction of the natural mortality ocurring before spawning


# Methods

Calculations

Summary

Subset

Operations

Plot

Accessors

Conversions

# All at once
\centering \includegraphics[keepaspectratio, width=\textwidth]{graphics/FLStock.png}
