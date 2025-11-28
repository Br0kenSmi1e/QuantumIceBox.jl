export QuantumSpinGlass, Coupling

"""
H = \\sum_{m} h_m a_m + \\sum{m, n} u_{m n} a_m a_n 
"""
struct QuantumSpinGlass{T}
    size::Int
    op::AbstractMatrix{Complex{T}} # a_m
    field::AbstractVector{T} # h_m
    coupling::AbstractMatrix{T} # u_{m n}
end

"""
H_I = \\sum_{m, n} v_{m n} a_m b_n
"""
struct Coupling{T}
    size1::Int
    size2::Int
    op1::AbstractMatrix{Complex{T}} # a_m
    op2::AbstractMatrix{Complex{T}} # b_n
    coupling::AbstractMatrix{T} # v_{m n}
end