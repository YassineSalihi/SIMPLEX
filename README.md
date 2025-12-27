# SIMPLEX
very simple starting point.

I am using the image below from my teacher course :
![image](https://github.com/user-attachments/assets/09e0578d-8614-43fe-8660-872b46c2c238)

Also I am checking https://medium.com/@muditbits/simplex-method-for-linear-programming-1f88fc981f50  
the "Simplex Algorithm"


# Implementation : would be tested in diff langs
   - Zig
   - Scala (maybe)
   - Go
   - ... 

To optimize : \
\$(c_1x_1 + c_2x_2 + c_3x_3 + ... + c_nx_n)\$

Subjects to constraints : \
\$a_{11}x_1 + a_{12}x_2 + a_{13}x_3 + ... + a_{1n}x_n <= b_1\$  \
\$a_{21}x_1 + a_{22}x_2 + a_{23}x_3 + ... + a_{2n}x_n <= b_1\$  \
                      .											\
					  .											\
					  .											\
\$a_{m1}x_1 + a_{m2}x_2 + a_{m3}x_3 + ... + a_{mn}x_n <= b_1\$  

# A Brief Description of the Simplex Method
We will use the notation of Bazaraa et al. (2011)1 with slight changes, of which this section provides a summary. We consider an LP problem of the following form:

min        \$cx\$ \
s.t.       \$Ax = b\$
           \$x >= 0\$

where \$A\$ is an \$m * n\$ matrix with rank and all other vectors have appropriate dimensions.

