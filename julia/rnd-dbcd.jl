function dbcd(N::Array{Int64}, w::Array{Float64}; γ::Float64)
    # target allocation proportions
    ρ = w ./ sum(w)

    if ~all(N .> 0)
        # probabilities of tretament assignments are equal to 
        # target allocation proportions
        return ρ
    else
        # current subject's ID
        j = sum(N) + 1

        num = ρ .* (ρ ./ (N./(j-1))).^γ

        # probabilities of tretament assignments
        return num ./ sum(num)
    end
end