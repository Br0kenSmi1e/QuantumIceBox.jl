using Yao
using QuantumIceBox
using CairoMakie

function heisenburg_spinglass(J::AbstractMatrix{Float64})
    n, _n = size(J)
    @assert n == _n "coupling J should be square, got size(J) = (n, _n)"
    x_comp = QuantumSpinGlass(n, mat(X), zeros(Float64, n), J)
    y_comp = QuantumSpinGlass(n, mat(Y), zeros(Float64, n), J)
    z_comp = QuantumSpinGlass(n, mat(Z), zeros(Float64, n), J)
    return get_system_hamiltonian(x_comp) +
        get_system_hamiltonian(y_comp) +
        get_system_hamiltonian(z_comp)
end

function heisenburg_chain(n::Int, J::Float64)
    J_mat = zeros(Float64, n, n)
    for i in 1:n-1
        J_mat[i, i + 1] = J
    end
    J_mat[n, 1] = J
    return heisenburg_spinglass(J_mat)
end

function marginal_probs(ψ::ArrayReg, idx::NTuple{N, Int}) where N
    p = focus(probs, ψ, idx)
    b = focus(collect∘basis, ψ, idx)
    return (probs=p, basis=b)
end

function main(nb::Int, Jb::Float64, N::Int, dt::Float64)
    sys = QuantumSpinGlass{Float64}(
        3, mat(Z),
        Float64[1, 1, 2],
        Float64[
            0 1 2;
            0 0 2;
            0 0 0
        ]
    )
    couple_mat = zeros(Float64, 3, nb)
    for i in 1:3
        couple_mat[i, i] = -Jb
    end
    couple = Coupling{Float64}(3, nb, mat(X), mat(X), couple_mat)
    bath_H = heisenburg_chain(nb, -1.0)
    total_H = put(nb+3, 1:3 => get_system_hamiltonian(sys)) +
        put(nb+3, 4:nb+3 => bath_H) +
        put(nb+3, 1:nb+3 => get_coupling_hamiltonian(couple))

    ψ0 = zero_state(nb+3) |> repeat(nb+3, H)
    cache = evolve!(ψ0, total_H, dt, N)
    prob_cache = map(ψ -> marginal_probs(ψ, (1, 2, 3)), cache)
    return prob_cache
end

N, dt = 100, 0.01
fig = Figure()
ax = Axis(fig[1, 1], xlabel="t", ylabel="probability")
for Jb in (1.0, 0.5, 0.25)
    prob_cache = main(3, Jb, N, dt)
    lines!(ax, collect(0:N) * dt, [sum(prob_cache[n].probs[[4, 5, 6, 7]]) for n in 1:N+1], label="λ=$(Jb)")
end
axislegend(ax)
fig
