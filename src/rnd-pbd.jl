function pbd(N::Array{Int64}, w::Array{Float64}; λ::Int64)
    # calculating block size
    bs = λ*sum(w)

    # current subject's ID
    j = sum(N) + 1

    # number of complete blocks among the previous assignments
    k = floor((j-1)/bs)
    
    # probabilities of tretament assignments
    return (λ.*w.*(1 + k) .- N) ./ (bs*(1 + k) - (j-1))
end
