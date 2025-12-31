#### Create a custom datatye ####
# They are five fields : 
# z_c for storing the row represinting zj - cj
# Y for Y
# x_b for xB = b(bar) = B⁻¹b 
# obj for z = cTBB⁻¹b 
# b_idx for the indices

mutable struct SimplexTableau
    z_c          ::Array{Float64}
    Y            ::Array{Float64}
    x_b          ::Array{Float64}
    obj          ::Float64
    b_idx        ::Array{Int64}
end

# Create un example of un simlplex method 
z_c = [3 2 1 5 0 0 0]
Y = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
x_B = [7; 3; 8]
obj = 0
b_idx = [5, 6, 7]

# Create an instance of the SimplexTableau
tableau = SimplexTableau(z_c, Y, x_B, obj, b_idx)
# println(typeof(tableau))
# println(fieldnames(typeof(tableau)))
# println(tableau.b_idx)

# Create a function for simplex method :
# The function initialize() first finds an initial BFS and create the first tableau
#
function simplex_method(c, A, b)
    tableau = initialize(c, A, b)

    while !is_optimal(tableau)
        pivoting!(tableau)
    end 

    # compute opt_x (x*) from tableau
    opt_x = zeros(length(c))
    opt_x[tableau.b_idx] = tableau.b_idx

    return opt_x, tableau.obj
end




