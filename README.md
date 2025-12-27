# SIMPLEX
very simple starting point.

I am checking https://medium.com/@muditbits/simplex-method-for-linear-programming-1f88fc981f50  
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
\$a_{m1}x_1 + a_{m2}x_2 + a_{m3}x_3 + ... + a_{mn}x_n <= b_1\$  \

# STEPS FOR SIMPLEX ALGORITHM :
	- Set the problem in Standard (correct) form.
	- Set the objective function as maximum problem (if you have minimum problem multiply the objective function by -1
	- Set all the constraints as ≤ format (if there is a ≥ constraint multiply constraint by -1
	- All the variables should be positive
	- Add requisite slack variables (these variables are added to make ≥ constraint into = type
	- Create the initial simplex tableau
	- Identify the Original Basis Solution corresponding to the basis variables
	- 

