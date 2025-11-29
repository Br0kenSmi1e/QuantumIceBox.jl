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
    return heisenburg_spinglass(J_mat)
end

sys = QuantumSpinGlass{Float64}(1, mat(Z), ones(Float64, 1), zeros(Float64, 1, 1))
couple_mat = zeros(Float64, 1, 13)
couple_mat[1, 7] = 1.0
couple = Coupling{Float64}(1, 13, mat(Y), mat(Y), couple_mat)
bath_H = heisenburg_chain(13, -1.0)
H = put(14, 1 => get_system_hamiltonian(sys)) +
    put(14, 2:14 => bath_H) +
    put(14, 1:14 => get_coupling_hamiltonian(couple))

ψ0 = arrayreg(bit"00000000000000")
cache = evolve!(ψ0, H, 0.1, 20)

function marginal_probs(ψ::ArrayReg, idx::NTuple{N, Int}) where N
    p = focus(probs, ψ, idx)
    b = focus(collect∘basis, ψ, idx)
    return (probs=p, basis=b)
end

prob_cache = [map(ψ -> marginal_probs(ψ, (n, )), cache) for n in 1:14]