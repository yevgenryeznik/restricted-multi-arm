function maxent(N::Array{Int64}, w::Array{Float64}; η::Float64)
    # getting number of treatment arms
    ntrt = length(w)

    # current subject's ID
    j = sum(N) + 1

    # target allocation proportions
    ρ = w ./ sum(w)

    # the hypothetical "lack of balance"
    B = zeros(ntrt)
    N1 = N
    for k ∈ 1:ntrt
        N1[k] += 1
        B[k] = maximum(abs.(N1./j - ρ))
        N1[k] -= 1 
    end

    # probabilities of tretament assignments
    if var(B) <= 1e-16
        return ρ
    else
        f(μ) = minimum(B)*η + (1-η)*sum(ρ.*B) - sum(B.*ρ.*exp.(-μ.*B))/sum(ρ.*exp.(-μ.*B))
        zfp = ZeroProblem(f, 0)
        μ = solve(zfp)

        p_num = ρ .* exp.(-μ .* B)
        
        return p_num/sum(p_num)
    end
end