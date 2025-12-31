module App

using GenieFramework
using LinearAlgebra, Combinatorics, Printf

# Include the logic directly or ensure the module is available.
# Since simplex_method.jl is in the parent dir, we can include it.
# However, to capture output, it's best to adapt the functions slightly 
# or use `redirect_stdout`.
# adapted from ../simplex_method.jl

# ==========================================
# SIMPLEX LOGIC (Adapted for Web Output)
# ==========================================

mutable struct SimplexTableau
  z_c     ::Array{Float64} # z_j - c_j
  Y       ::Array{Float64} # inv(B) * A
  x_B     ::Array{Float64} # inv(B) * b
  obj     ::Float64        # c_B * x_B
  b_idx   ::Array{Int64}   # indices for basic variables x_B
end

function is_nonnegative(x::Vector)
  return length( x[ x .< 0] ) == 0
end

function is_nonpositive(z::Array)
  return length( z[ z .> 0] ) == 0
end

function initial_BFS(A, b)
  m, n = size(A)

  comb = collect(combinations(1:n, m))
  for i in length(comb):-1:1
    b_idx = comb[i]
    B = A[:, b_idx]
    
    # Handle singular matrix
    try
        x_B = inv(B) * b
        if is_nonnegative(x_B)
            return b_idx, x_B, B
        end
    catch e
        continue
    end
  end

  error("Infeasible")
end

function print_tableau(io::IO, t::SimplexTableau)
  m, n = size(t.Y)

  hline0 = repeat("-", 6)
  hline1 = repeat("-", 7*n)
  hline2 = repeat("-", 7)
  hline = join([hline0, "+", hline1, "+", hline2])

  println(io, hline)

  @printf(io, "%6s|", "")
  for j in 1:length(t.z_c)
    @printf(io, "%6.2f ", t.z_c[j])
  end
  @printf(io, "| %6.2f\n", t.obj)

  println(io, hline)

  for i in 1:m
    @printf(io, "x[%2d] |", t.b_idx[i])
    for j in 1:n
      @printf(io, "%6.2f ", t.Y[i,j])
    end
    @printf(io, "| %6.2f\n", t.x_B[i])
  end

  println(io, hline)
end

function pivoting!(io::IO, t::SimplexTableau)
  m, n = size(t.Y)

  entering, exiting = pivot_point(t)
  println(io, "Pivoting: entering = x_$entering, exiting = x_$(t.b_idx[exiting])")

  # Pivoting: exiting-row, entering-column
  # updating exiting-row
  coef = t.Y[exiting, entering]
  t.Y[exiting, :] /= coef
  t.x_B[exiting] /= coef

  # updating other rows of Y
  for i in setdiff(1:m, exiting)
    coef = t.Y[i, entering]
    t.Y[i, :] -= coef * t.Y[exiting, :]
    t.x_B[i] -= coef * t.x_B[exiting]
  end

  # updating the row for the reduced costs
  coef = t.z_c[entering]
  t.z_c -= coef * t.Y[exiting, :]'
  t.obj -= coef * t.x_B[exiting]

  # Updating b_idx
  t.b_idx[ findfirst(t.b_idx .== t.b_idx[exiting]) ] = entering
end

function pivot_point(t::SimplexTableau)
  # Finding the entering variable index
  entering = findfirst( t.z_c .> 0)[2]
  if entering == 0
    error("Optimal")
  end

  # min ratio test / finding the exiting variable index
  pos_idx = findall( t.Y[:, entering] .> 0 )
  if length(pos_idx) == 0
    error("Unbounded")
  end
  exiting = pos_idx[ argmin( t.x_B[pos_idx] ./ t.Y[pos_idx, entering] ) ]

  return entering, exiting
end

function initialize(c, A, b)
  c = Array{Float64}(c)
  A = Array{Float64}(A)
  b = Array{Float64}(b)

  m, n = size(A)

  # Finding an initial BFS
  b_idx, x_B, B = initial_BFS(A,b)

  Y = inv(B) * A
  c_B = c[b_idx]
  obj = dot(c_B, x_B)

  # z_c is a row vector
  z_c = zeros(1,n)
  n_idx = setdiff(1:n, b_idx)
  z_c[n_idx] = c_B' * inv(B) * A[:,n_idx] - c[n_idx]'

  return SimplexTableau(z_c, Y, x_B, obj, b_idx)
end

function is_optimal(t::SimplexTableau)
  return is_nonpositive(t.z_c)
end

function solve_simplex(c, A, b)
  io = IOBuffer()
  try
      tableau = initialize(c, A, b)
      print_tableau(io, tableau)

      while !is_optimal(tableau)
        pivoting!(io, tableau)
        print_tableau(io, tableau)
      end

      opt_x = zeros(length(c))
      opt_x[tableau.b_idx] = tableau.x_B

      return String(take!(io)), opt_x, tableau.obj
  catch e
      return String(take!(io)) * "\nError: " * string(e), [], NaN
  end
end

# ==========================================
# GENIE UI
# ==========================================

@genietools

@app begin
  @in c_str = "-3 -2 -1 -5 0 0 0"
  @in A_str = "7 3 4 1 1 0 0\n2 1 1 5 0 1 0\n1 4 5 2 0 0 1"
  @in b_str = "7 3 8"
  @in button_solve = false
  
  @out logs = ""
  @out optimal_x = ""
  @out optimal_obj = ""
  
  @onchange button_solve begin
    try
        # Parse inputs
        c = map(x -> parse(Float64, x), split(c_str))
        
        # Parse Matrix A
        rows = split(strip(A_str), "\n")
        A_data = [map(x -> parse(Float64, x), split(row)) for row in rows]
        # Convert vector of vectors to matrix
        A = permutedims(hcat(A_data...))
        
        b = map(x -> parse(Float64, x), split(b_str))
        
        if size(A, 2) != length(c)
             logs = "Error: Dimension mismatch between A columns ($(size(A, 2))) and c length ($(length(c)))"
             return
        end
        
        output_log, x_res, obj_res = solve_simplex(c, A, b)
        
        logs = output_log
        optimal_x = string(x_res)
        optimal_obj = string(obj_res)
        
    catch e
        logs = "Parsing or Execution Error: " * string(e)
    end
  end
end

function ui()
  [
    h1("Simplex Method Solver")
    
    row([
      cell(class="st-col-4", [
        h4("C Vector (Objective Coefficients)")
        textfield("", :c_str)
      ])
    ])
    
    row([
      cell(class="st-col-6", [
        h4("A Matrix (Constraints LHS)")
        textfield("", :A_str, rows=5, type="textarea")
      ])
      cell(class="st-col-4", [
         h4("b Vector (Constraints RHS)")
         textfield("", :b_str)
      ])
    ])
    
    btn("Solve Simplex", @click(:button_solve), color="primary")
    
    h3("Results")
    p("Optimal X: {{optimal_x}}")
    p("Optimal Objective: {{optimal_obj}}")
    
    h3("Logs / Tableau")
    textfield("", :logs, rows=20, readonly=true, style="font-family: monospace;", type="textarea")
  ]
end

@page("/", ui)

end
