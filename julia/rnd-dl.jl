function randomize_dl(nsbj::Int64, nsim::Int64, w::Array{Int64}, seed::Int64; a::Int64)
    # getting number of treatments
    ntrt = length(w)

    # an array to collect treatment assignments
    δ = zeros(Int64, nsbj, ntrt, nsim)

    # an array to collect allocation probabilities
    ϕ = zeros(Float64, nsbj, ntrt, nsim)

    seed_ = seed
    for s ∈ 1:nsim
        # numbers of subjects allocated to treatments (treatment numbers)
        N = zeros(Int64, ntrt)

        # initial urn state
        balls = collect(0:length(w)) # balls' types in an urn
        nballs = [1; w]              # numbers of balls in an urn
        for j ∈ 1:nsbj
            flag = true
            while flag
                seed_ += 1
                Random.seed!(seed_)
                ball = sample(balls, weights(nballs))
                if ball == 0
                    nballs[2:end] += a .* w
                else
                    # calculating probability of treatment assignment, 
                    # given the current values of tretament numbers (N1, N2)
                    ϕ[j, :, s] = nballs[2:end] ./ sum(nballs)

                    # here, the tretament assignment is made
                    δ[j, ball, s] = 1

                    # removing a ball from urn
                    nballs[ball+1] -= 1

                    # updating flag
                    flag = false
                end
            end
        end
    end
    
    return SimulatedRCT([], δ, ϕ)
end

