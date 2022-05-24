using CSV
using Distributions
using LinearAlgebra
using StatsBase
using Random

include("src/simulated-rct.jl")
include("src/assign-trt.jl")
include("src/rnd-bud.jl")
include("src/rnd-pbd.jl")
include("src/rnd-minqd.jl")
include("src/randomization.jl")


nsbj = 50
nsim = 10000
w = float.([4, 3, 2, 1])


@time trial = randomize(nsbj, nsim, w, 314159, minqd, η = 1.);