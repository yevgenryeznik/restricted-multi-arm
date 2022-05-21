function assign_trt(prb::Array{Float64}, u::Float64)
    ntrt = length(prb)
    cumulative_prb = cumsum([0; prb])
    idx = cumulative_prb[1:end-1] .< u .<= cumulative_prb[2:end]

    return Int.(idx) 
end