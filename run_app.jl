using Pkg
Pkg.activate(".")
include("genie_simplex/app.jl")
using .App
println("Starting server on port 8000...")
App.Genie.up(8000, async=false)
