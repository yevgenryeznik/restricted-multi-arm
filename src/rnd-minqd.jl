function minqd(N::Array{Int64}, w::Array{Float64}; η::Float64)
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
        μ = 2/((ntrt-1)*var(B))*η*(sum(B .* ρ)-minimum(B))
        p = ρ .- 0.5 .* μ .* (B .- mean(B))
        p1 = [ifelse(p[k] < 0, 0, p[k]) for k ∈ 1:ntrt]
        
        return p1/sum(p1)
    end
end