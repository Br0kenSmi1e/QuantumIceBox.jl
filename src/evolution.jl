export evolve!

function evolve!(ψ::ArrayReg, H::AbstractBlock, dt::T, N::Int) where T
    evolution_op = time_evolve(H, dt)
    cache = [copy(ψ)]
    for _ in 1:N
        apply!(ψ, evolution_op)
        push!(cache, copy(ψ))
    end
    return cache
end