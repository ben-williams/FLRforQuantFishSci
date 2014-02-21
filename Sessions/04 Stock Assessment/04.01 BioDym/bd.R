ple4.bd <- FLBioDym(catch=catch(ple4), index=stock(ple4))

bounds <- bounds(FLBioDym())
bounds["r",    "start"]=0.35
bounds["k",    "start"]=10000
bounds["sigma","start"]=0.5
bounds["q",    "start"]=1.0
bounds["p",    "start"]=1
bounds["b0",   "start"]=0.5
bounds[,"lower"]=bounds[,"start"]*0.1
bounds[,"upper"]=bounds[,"start"]*10.0

ple4.bd@bounds <- bounds

 
