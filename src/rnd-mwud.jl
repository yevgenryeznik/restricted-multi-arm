function mwud(N::Array{Int64}, w::Array{Float64}; α::Float64)
    # current subject's ID
    j = sum(N) + 1

    # target allocation proportions
    ρ = w ./ sum(w)
    
    num = (α .* ρ - N + (j-1) .* ρ) .* ((α .* ρ - N + (j-1) .* ρ) .> 0)

    # probabilities of tretament assignments
    return num ./ sum(num)
end