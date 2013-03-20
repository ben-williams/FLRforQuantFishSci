

What we will cover
------------

- The FLSR object
- Creating an SR object from a Stock object
- Selecting a stock recruitment model
- Fitting a stock recruitment model
- Plotting a stock recruitment model
- Comparing between stock recruitment models
- Predicting new recruitments
- Fixing a parameter in a fit


------------

To start, open an R session and load the `FLCore` library by issuing the
command:

~~~~ {.code .R}
library(FLCore)
data(ple4)
~~~~


------------

\includegraphics[width = \textwidth]{reproduction}


Ricker stock recruit function
------------


\begin{align*}
\text{Recruitment} = a \times \text{SSB} \times e^{-b \times{SSB} }
\end{align*}

------------

\includegraphics[width = \textwidth]{ricker}



Some reading on stock recruit models
------------

\includegraphics[height = \textheight]{quinn}
