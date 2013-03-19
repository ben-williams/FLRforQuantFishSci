


To start, open an R session and load the `FLCore` library by issuing the
command:

~~~~ {.code .R}
library(FLCore)
data(nsher)
~~~~


Ricker stock recruit function
------------


\begin{align*}
\text{Recruitment} = a \times \text{SSB} \times e^{-b \times{SSB} }
\end{align*}

~~~~ {.code .R}
rec ~ a * ssb * exp( -b * ssb)
~~~~

Some reading on stock recruit models
------------

\includegraphics[height = \textheight]{quinn}
