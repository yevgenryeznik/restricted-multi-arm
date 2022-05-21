function bud(N::Array{Int64}, w::Array{Float64}; λ::Int64)
    # current subject's ID
    j = sum(N) + 1

    # the number of minimal balanced sets among previous assignments
    k = minimum(floor.(N ./ w))
    
    # probabilities of tretament assignments
    return (w.*(λ + k) .- N) ./ (sum(w)*(λ + k) - (j-1))
end