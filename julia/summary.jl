# function to calculate Momentum Probability Mass (MPM)
function calculate_mpm(rct::SimulatedRCT, ρ::Array{Float64})
    trt = rct.trt
    nsbj, _, _ = size(trt)

    sbj = collect(1:nsbj)
    N = cumsum(trt, dims = 1)

    imb = sqrt.(sum((N .- sbj*ρ').^2, dims = 2))
    
    return mean(imb, dims = 3)[:, 1, 1]
end


# function to calculate Average Forcing Index (AFI)
function calculate_afi(rct::SimulatedRCT, ρ::Array{Float64})
    prb = rct.prb
    nsbj, _, _ = size(prb)

    e = ones(nsbj)

    FIj = sqrt.(sum((prb .- e*ρ').^2, dims = 2))
    FI = cumsum(FIj, dims = 1) ./ (1:nsbj)

    return mean(FI, dims = 3)[:, 1, 1]
end


# function to calculate “average standard deviation” (ASD) f the 
# allocation proportions, scaled by the value of the current sample size
function calculate_asd(rct::SimulatedRCT)
    trt = rct.trt
    nsbj, _, _ = size(trt)

    sbj = collect(1:nsbj)

    # simulated allocation proportions
    prp = cumsum(trt, dims = 1)./sbj

    # SD of simulated allocation proportions 
    prp_sd = std(prp, dims = 3)

    return sqrt.(sbj.*sum(prp_sd.^2, dims = 2))[:, 1, 1]
end


function calculate_final_prp(rct::SimulatedRCT)
    trt = rct.trt
    nsbj, ntrt, _ = size(trt)

    sbj = collect(1:nsbj)

    # simulated allocation proportions
    prp = cumsum(trt, dims = 1)./sbj

    return reduce(hcat, [prp[nsbj, k, :] for k in 1:ntrt])
end