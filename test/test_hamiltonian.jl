using Test
using QuantumIceBox
using Yao

@testset "system hamiltonian" begin
    pauli_z = ComplexF64[1 0; 0 -1]
    sg = QuantumSpinGlass(2, pauli_z, Float64[0, 0], Float64[0 1; 0 0])
    hamiltonian = Diagonal(ComplexF64[1, -1, -1, 1])
    @test hamiltonian ≈ mat(get_system_hamiltonian(sg))
end

@testset "coupling hamiltonian" begin
    pauli_z = ComplexF64[1 0; 0 -1]
    c = Coupling(1, 1, pauli_z, pauli_z, ones(Float64, 1, 1))
    hamiltonian = Diagonal(ComplexF64[1, -1, -1, 1])
    @test hamiltonian ≈ mat(get_coupling_hamiltonian(c))
end

@testset "total hamiltonian" begin
    pauli_z = ComplexF64[1 0; 0 -1]
    sg2 = QuantumSpinGlass(2, pauli_z, Float64[0, 0], Float64[0 1; 0 0])
    c = Coupling(2, 2, pauli_z, pauli_z, Float64[0 0; 1 0])
    sg4 = QuantumSpinGlass(4, pauli_z, Float64[0, 0, 0, 0], Float64[0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0])
    @test mat(get_system_hamiltonian(sg4)) ≈ mat(get_total_hamiltonian(sg2, sg2, c))
end
