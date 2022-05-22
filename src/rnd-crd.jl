function crd(N::Array{Int64}, w::Array{Float64}; kwargs...)
    # probabilities of tretament assignments
    return w / sum(w)
end