using Yao
using QuantumIceBox
using CairoMakie

function quantum_anneal!(
    ψ::ArrayReg,
    HD::AbstractBlock, HP::AbstractBlock,
    s::AbstractVector{T}, dt::T
) where T
    cache = [copy(ψ)]
    for si in s
        Ht = (1 - si) * HD + si * HP
        evolution_op = time_evolve(Ht, dt)
        apply!(ψ, evolution_op)
        push!(cache, copy(ψ))
    end
    return cache
end

function marginal_probs(ψ::ArrayReg, idx::NTuple{N, Int}) where N
    p = focus(probs, ψ, idx)
    b = focus(collect∘basis, ψ, idx)
    return (probs=p, basis=b)
end

function main(dsdt; ds=0.01)
    sysP = QuantumSpinGlass{Float64}(
        3, mat(Z),
        Float64[1, 1, 2],
        Float64[
            0 1 2;
            0 0 2;
            0 0 0
        ]
    )
    sysD = QuantumSpinGlass{Float64}(
        3, mat(X),
        -ones(Float64, 3),
        zeros(Float64, 3, 3)
    )
    ψ0 = zero_state(3) |> repeat(3, H)
    s = 0.0:ds:1.0
    dt = ds / dsdt
    cache = quantum_anneal!(ψ0, get_system_hamiltonian(sysD), get_system_hamiltonian(sysP), s, dt)
    prob_cache = map(ψ -> marginal_probs(ψ, (1, 2, 3)), cache)
    return prob_cache
end

ds = 0.01
fig = Figure()
ax = Axis(fig[1, 1], xlabel="s", ylabel="probability")
for dsdt in (1.0, 0.5, 0.25)
    prob_cache = main(dsdt; ds=ds)
    N = length(prob_cache)
    lines!(ax, collect(0:N-1) * ds, [sum(prob_cache[n].probs[[4, 5, 6, 7]]) for n in 1:N], label="ds/dt=$(dsdt)")
end
axislegend(ax, position=:rb)
fig
