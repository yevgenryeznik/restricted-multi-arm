using CSV
using DataFrames
using Distributions
using LinearAlgebra
using StatsBase
using StatsPlots
using Random
using Roots


include("simulated-rct.jl")
include("assign-trt.jl")
include("rnd-bud.jl")
include("rnd-crd.jl")
include("rnd-dbcd.jl")
include("rnd-dl.jl")
include("rnd-mwud.jl")
include("rnd-pbd.jl")
include("rnd-maxent.jl")
include("randomization.jl")
include("summary.jl")


# simulation example from a SiM paper: 
# title:   "A comparative study of restricted randomization procedures for 
#          multiarm trials with equal or unequal treatment allocation ratios."
# authors: Ryeznik Y, Sverdlov O 
# journal: Statistics in Medicine
# year:    2018
# volume:  37
# pages:   3056–3077.
# doi:     10.1002/sim.7817

# sample size
nsbj = 200

# number of simulations
nsim = 10000

# target unequal allocation
w = [4, 3, 2, 1]
wf = float.(w)

# target allocation proportions
ρ = w ./ sum(w)

# setting seed for reproducibility
seed = 314159

# setting up randomization procedures to simulate
rnd_procs = Dict(
             "CRD" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, crd),
          "PBD(1)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, pbd, λ = 1),
          "PBD(2)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, pbd, λ = 2),
          "PBD(3)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, pbd, λ = 3),
          "PBD(4)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, pbd, λ = 4),
          "PBD(5)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, pbd, λ = 5),
          "BUD(2)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, bud, λ = 2),
          "BUD(3)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, bud, λ = 3),
          "BUD(4)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, bud, λ = 4),
          "BUD(5)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, bud, λ = 5),
         "MWUD(2)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, mwud, α = 2.),
         "MWUD(4)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, mwud, α = 4.),
         "MWUD(6)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, mwud, α = 6.),
         "MWUD(8)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, mwud, α = 8.),
           "DL(2)" => (nsbj, nsim) -> randomize_dl(nsbj, nsim, w, seed, a = 2),
           "DL(4)" => (nsbj, nsim) -> randomize_dl(nsbj, nsim, w, seed, a = 4),
           "DL(6)" => (nsbj, nsim) -> randomize_dl(nsbj, nsim, w, seed, a = 6),
           "DL(8)" => (nsbj, nsim) -> randomize_dl(nsbj, nsim, w, seed, a = 8),
         "DBCD(1)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, dbcd, γ = 1.),
         "DBCD(2)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, dbcd, γ = 2.),
         "DBCD(4)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, dbcd, γ = 4.),
         "DBCD(5)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, dbcd, γ = 5.),
        "DBCD(10)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, dbcd, γ = 10.),
    "MaxEnt(0.05)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, maxent, η = 0.05),
     "MaxEnt(0.1)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, maxent, η = 0.1),
    "MaxEnt(0.25)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, maxent, η = 0.25),
     "MaxEnt(0.5)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, maxent, η = 0.5),
       "MaxEnt(1)" => (nsbj, nsim) -> randomize(nsbj, nsim, wf, seed, maxent, η = 1.)
)

# running simulations
designs = [key for key in keys(rnd_procs)]
@time sim_output = map(designs) do design
    rnd_proc = getindex(rnd_procs, design)
    return [design, rnd_proc(nsbj, nsim)] 
end;

# calculating operational characteristics
@time op = vcat(map(sim_output) do output
    design = output[1]
    simulated_rct = output[2]
    return DataFrame(
        design = design,
        sbj = 1:nsbj, 
        mpm = calculate_mpm(simulated_rct, ρ), # momentum of probability mass
        afi = calculate_afi(simulated_rct, ρ), # average forcing inces
        asd = calculate_asd(simulated_rct)     # variability of allocation proportions
    )
end...)

# collecting distributions of final allocation proportions
@time prop = vcat(map(sim_output) do output
    design = output[1]
    simulated_rct = output[2]
    prop = DataFrame(
        calculate_final_prp(simulated_rct),    # distribution of final proportions
        ["trt$(k)" for k in 1:length(w)]
    )
    return insertcols!(prop, 1, :design => design)
end...)

# saving simulation output
CSV.write("simulation-csv/op.csv", op)
CSV.write("simulation-csv/prop.csv", prop)