struct SimulatedRCT
    rsp::Array{Number}
    trt::Array{Int64}
    prb::Array{Float64}
end

function Base.show(io::IO, trial::SimulatedRCT)
    nsbj, nsim = size(trial.trt)
    println("Simulated RCT: 1:1 allocation, $(nsbj) subjects, $(nsim) simulations.")
    println("\nSubjects' responses:")
    print("rsp = ")
    if trial.rsp == []
        println("[ ] (not set)")
    else
        display(trial.rsp)
    end
    println("\nTreatment assignments:")
    print("trt = ")
    display(trial.trt)
    println("\nProbabilities of treatment assignments:")
    print("prb = ")
    display(trial.prb)
end