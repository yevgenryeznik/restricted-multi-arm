function randomize(nsbj::Int64, nsim::Int64, w::Array{Float64}, seed::Int64, rnd::Function; kwargs...)
    # getting number of treatments
    ntrt = length(w)

    Random.seed!(seed)
    u = rand(Uniform(0, 1), nsbj, nsim)

    # an array to collect treatment assignments
    δ = zeros(Int64, nsbj, ntrt, nsim)

    # an array to collect allocation probabilities
    ϕ = zeros(Float64, nsbj, ntrt, nsim)

    for s ∈ 1:nsim
        # numbers of subjects allocated to treatments (treatment numbers)
        N = zeros(Int64, ntrt)

        for j ∈ 1:nsbj
            # calculating probability of treatment assignment, 
            # given the current values of tretament numbers (N1, N2)
            ϕ[j, :, s] = rnd(N, w; kwargs...)

            # here, the tretament assignment is made
            δ[j, :, s] = assign_trt(ϕ[j, :, s], u[j, s])

            # updating treatment numbers
            N += δ[j, :, s]
        end
    end
    
    return SimulatedRCT([], δ, ϕ)
end