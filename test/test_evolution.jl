using Test
using QuantumIceBox
using Yao

@testset "evolve" begin
    ψ = arrayreg(bit"0") + arrayreg(bit"1")
    cache = evolve!(ψ, Z, 2π, 1)
    @test cache[1] ≈ cache[2]
end