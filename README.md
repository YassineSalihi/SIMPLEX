# SIMPLEX
very simple starting point.

I am checking https://medium.com/@muditbits/simplex-method-for-linear-programming-1f88fc981f50  
the "Simplex Algorithm"


# Implementation : would be tested in diff langs
   - Zig
   - Scala (maybe)
   - Go
   - ... 

To optimize : 
\[
\begin{aligned}
KL(\hat{y} || y) &= \sum_{c=1}^{M}\hat{y}_c \log{\frac{\hat{y}_c}{y_c}} \\
JS(\hat{y} || y) &= \frac{1}{2}(KL(y||\frac{y+\hat{y}}{2}) + KL(\hat{y}||\frac{y+\hat{y}}{2}))
\end{aligned}
\]
