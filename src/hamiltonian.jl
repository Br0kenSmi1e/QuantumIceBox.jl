export get_system_hamiltonian
export get_coupling_hamiltonian
export get_total_hamiltonian

function get_system_hamiltonian(sys::QuantumSpinGlass{T}) where T
    a = matblock(sys.op)
    local_hamiltonians = [
        (m == n ?
        sys.field[m] * Yao.kron(sys.size, m => a) :
        sys.coupling[m, n] * Yao.kron(sys.size, m => a, n => a))
        for m in 1:sys.size for n in 1:sys.size
    ]
    return sum(local_hamiltonians)
end

function get_coupling_hamiltonian(couple::Coupling{T}) where T
    a = matblock(couple.op1)
    b = matblock(couple.op2)
    local_hamiltonians = [
        couple.coupling[m, n] * Yao.kron(couple.size1 + couple.size2, m => a, n + couple.size1 => b)
        for m in 1:couple.size1 for n in 1:couple.size2
    ]
    return sum(local_hamiltonians)
end

function get_total_hamiltonian(
    sys::QuantumSpinGlass{T},
    bath::QuantumSpinGlass{T},
    couple::Coupling{T}
) where T
    total_size = sys.size + bath.size
    @assert total_size == couple.size1 + couple.size2 "system size inconsistent"
    return sum([
        put(total_size, 1:sys.size => get_system_hamiltonian(sys)),
        put(total_size, sys.size + 1:total_size => get_system_hamiltonian(bath)),
        put(total_size, 1:total_size => get_coupling_hamiltonian(couple))
    ])
end
