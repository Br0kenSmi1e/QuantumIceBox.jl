#import "@preview/cetz:0.4.2": *

#set page(margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))
// #set text(font: "Linux Libertine", size: 11pt)
// #set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

#show math.equation: set block(above: 0.8em, below: 0.8em)

#align(center)[= Computing by Cooling]

#align(center)[
  #text(weight: "regular", size: 12pt)[
    Longli Zheng \
    (https://github.com/Br0kenSmi1e/QuantumIceBox.jl)
  ]
  #v(0.3em)
  #text(size: 10pt)[
    AMAT, FUNH, HKUST(GZ)
  ]
]

// == Abstract

// This report explores alternative paradigms for computation that move beyond traditional gate-based approaches. We examine how computational rules can be encoded into the ground states of physical Hamiltonians, transforming computation into a process of thermal relaxation or quantum annealing. Two primary quantum approaches are discussed: quantum adiabatic algorithms, which employ time-dependent Hamiltonians, and the quantum ice box algorithm, which utilizes time-independent Hamiltonians with structured baths. Using the NAND logic gate as a concrete example, we demonstrate how both classical gate-based computation and ground state encoding can achieve the same computational goals through fundamentally different physical mechanisms.

// == Introduction

// Conventional computation, whether classical or quantum, is typically based on the application of logic gates to input states to produce output states. In classical computing, gates like NAND form the basis of digital circuits, while quantum computing employs gates such as Clifford gates and the Toffoli gate. However, an alternative formalism exists that encodes computational rules directly into the ground states of certain Hamiltonians. This approach transforms computation from an active process of gate application into a passive process of thermal relaxation or quantum annealing, where the system naturally evolves toward its ground state, which encodes the solution.

// This report explores this alternative computational paradigm, beginning with a comparison of gate-based and ground-state-based approaches using the NAND logic gate as a concrete example. We then examine two quantum algorithms for reaching these ground states: quantum adiabatic algorithms and the quantum ice box algorithm. Through numerical simulations, we demonstrate the effectiveness of both approaches and discuss their relative advantages and future prospects.

== Computation by Logic Gates

Traditional computation relies on the sequential application of logic gates to transform input states into output states. In classical computing, gates such as AND, OR, and NAND form the fundamental building blocks of digital circuits. Quantum computing extends this paradigm with quantum gates, including the Toffoli gate (also known as the controlled-controlled-NOT or CCNOT gate), which can implement classical logic operations in a quantum context.

As an illustrative example, consider the quantum NAND gate. A quantum NAND operation can be implemented using a Toffoli gate, which acts on three qubits. The Toffoli gate performs the transformation:

$
  |s_1, s_2, s_3 chevron.r → |s_1, s_2, s_3 ⊕ (s_1 ∧ s_2) chevron.r
$

where $⊕$ denotes addition modulo 2. To implement NAND, we initialize the third qubit to $|1⟩$ and apply the Toffoli gate, resulting in:

$
  |s_1, s_2, 1 chevron.r → |s_1, s_2, "NAND"(s_1, s_2) chevron.r
$

The quantum circuit for this operation is shown in @nand-circuit, where the first two qubits serve as control qubits and the third qubit is the target.

#figure(
  caption: [Quantum circuit for NAND gate implementation using Toffoli gate],
  canvas({
    import draw: *
    
    let sp = 1.2
    let wl = 3.5
    let gx = 1.5
    
    // Three horizontal wires
    line((0, 0), (wl, 0), width: 1pt)
    line((0, -sp), (wl, -sp), width: 1pt)
    line((0, -2 * sp), (wl, -2 * sp), width: 1pt)
    
    // Control dots
    circle((gx, 0), radius: 0.12, fill: black)
    circle((gx, -sp), radius: 0.12, fill: black)
    
    // Vertical control line
    line((gx, 0), (gx, -2 * sp - 0.2), width: 1pt)
    circle((gx, -2 * sp), radius: 0.2)
    
    // Labels
    content((-0.4, 0), [$s_1$])
    content((-0.4, -sp), [$s_2$])
    content((-0.4, -2 * sp), [$1$])
    content((wl + 0.4, 0), [$s_1$])
    content((wl + 0.4, -sp), [$s_2$])
    content((wl + 1.9, -2 * sp), [$s_3 = "NAND"(s_1, s_2)$])
  })
) <nand-circuit>

This gate-based approach requires active control of the quantum system to apply the gate operations. The computation proceeds deterministically through the sequential application of gates, with each gate transforming the quantum state in a well-defined manner @nielsen2010quantum.

== Computation by Ground State

An alternative computational paradigm encodes computational rules directly into the ground states of physical Hamiltonians. Rather than actively applying gates, this approach relies on the system's natural tendency to relax to its ground state, which encodes the solution to the computational problem.

To illustrate this concept, we again use NAND logic as an example. The NAND truth table contains four entries, as shown in @nand-truth-table.

#figure(
  table(
    columns: (64pt, 64pt, 64pt),
    align: center,
    [$s_1$], [$s_2$], [$s_3$],
    [$0$], [$0$], [$1$],
    [$0$], [$1$], [$1$],
    [$1$], [$0$], [$1$],
    [$1$], [$1$], [$0$],
  ),
  caption: [Truth table for NAND logic]
) <nand-truth-table>

Consider an Ising spin glass with the Hamiltonian:

$
  H = s_1 s_2 + 2s_2 s_3 + 2s_1 s_3 + s_1 + s_2 + 2s_3
$

where $s_i ∈ {arrow.t, arrow.b}$ are Ising spin variables. This Hamiltonian has a four-fold degenerate ground state manifold with the following configurations:

$
  s_1 s_2 s_3 = arrow.t arrow.t arrow.b, arrow.t arrow.b arrow.b, arrow.b arrow.t arrow.b, arrow.b arrow.b arrow.t
$

Mapping $-1$ to $0$ and $+1$ to $1$, these ground states correspond exactly to the four entries in the NAND truth table. Thus, the computational problem of evaluating NAND logic is encoded in the ground state structure of this Hamiltonian @nguyen2023quantum.

This ground-state encoding approach offers several potential advantages. The computation becomes a passive process of thermal relaxation or quantum annealing, potentially requiring less active control than gate-based methods. Additionally, the degenerate ground state manifold provides natural error tolerance, as any state within the ground state subspace represents a valid solution.

== Computation by Annealing

Since computational rules can be encoded into the ground states of certain Hamiltonians, computation becomes the process of cooling or annealing the system to reach its ground state. This perspective unifies classical and quantum approaches to optimization and computation.

For classical systems, numerous well-established algorithms exist for finding ground states, most notably simulated annealing. In simulated annealing, the system is initialized at a high temperature and gradually cooled, allowing it to escape local minima and settle into the global minimum (ground state) as the temperature approaches zero.

In the quantum realm, there are two primary approaches to reaching ground states:

1. *Annealing through adiabatic evolution*: The system evolves under a time-dependent Hamiltonian that slowly transitions from an easily prepared initial state to the problem Hamiltonian.

2. *Cooling through interaction with a structured bath*: The system interacts with a carefully designed bath (heat sink) that facilitates energy transfer from the computational system to the bath, driving the system toward its ground state.

Both approaches aim to guide the system to its ground state, but they employ fundamentally different mechanisms. The adiabatic approach relies on quantum adiabaticity, requiring slow evolution to maintain the system in its instantaneous ground state. The bath-based approach relies on open quantum system dynamics, where the bath acts as a structured environment that selectively removes energy from the computational system.

== Quantum Adiabatic Algorithm

The Quantum Adiabatic Algorithm (QAA) is a prominent approach to quantum computation and optimization that leverages the adiabatic theorem of quantum mechanics @rajak2023quantum. In this algorithm, one constructs a time-dependent Hamiltonian $H(t)$ that evolves smoothly from a simple initial Hamiltonian $H_D$ to the problem Hamiltonian $H_P$:

$
  H(t) = (1 - s(t)) H_D + s(t) H_P
$

where $s(t)$ is a scheduling function with $s(0) = 0$ and $s(T) = 1$, and $T$ is the total evolution time. The initial Hamiltonian $H_D$ is chosen such that its ground state is easy to prepare—typically a uniform superposition or a product state.

The adiabatic theorem guarantees that if the system is initialized in the ground state of $H_D$ at time $t = 0$, and the evolution is sufficiently slow (i.e., $T$ is large enough), the system will remain in the instantaneous ground state throughout the evolution. At time $t = T$, the system will be in the ground state of $H_P$, which encodes the solution to the computational problem.

The key challenge in QAA is determining the appropriate evolution time $T$. The adiabatic condition requires that $T$ scales inversely with the square of the minimum energy gap between the ground state and first excited state. For many problems, this gap can be exponentially small, leading to exponentially long evolution times. However, for certain classes of problems, polynomial scaling can be achieved.

=== Numerical Simulation of QAA

To demonstrate the quantum adiabatic algorithm, we perform a numerical simulation for the NAND logic problem. We choose:

$
  H_D &= -(X_1 + X_2 + X_3), \
  H_P &= Z_1 Z_2 + 2Z_2 Z_3 + 2Z_1 Z_3 + Z_1 + Z_2 + 2Z_3,\
  s(t) &= v t
$

where $X_i$ and $Z_i$ are Pauli operators acting on qubit $i$. The initial Hamiltonian $H_D$ has a ground state that is a uniform superposition over all computational basis states, which is easy to prepare. The problem Hamiltonian $H_P$ encodes the NAND logic in its ground state, as discussed in the previous section.

We use a linear scheduling function $s(t) = v t$, where $v$ is the annealing velocity. The results of the numerical simulation are shown in @qaa-simulation.

#figure(
  caption: [Numerical simulation of quantum adiabatic algorithm for NAND logic],
  image("nand_qa.pdf", width: 60%)
) <qaa-simulation>

The simulation demonstrates the evolution of the system's state as it transitions from the initial Hamiltonian to the problem Hamiltonian. The success of the algorithm depends on the annealing velocity $v$: if $v$ is too large, the system may transition to excited states, violating the adiabatic condition; if $v$ is sufficiently small, the system remains in the ground state throughout the evolution.

== Quantum Ice Box Algorithm

The Quantum Ice Box Algorithm represents an alternative approach to quantum computation that does not require time-dependent Hamiltonians @feng2022quantum. Instead, the system is divided into two parts: the computational system and a structured bath. The total Hamiltonian is:

$
  H = H_s + H_b + H_i
$

where:
- $H_s$ is the computational system Hamiltonian, which encodes the problem to be solved.
- $H_b$ is the bath Hamiltonian, which is a simple system with an easily prepared ground state.
- $H_i$ is the interaction Hamiltonian, which couples the computational system to the bath and allows energy transfer.

The key insight is that the bath is designed to have a lower energy scale than the computational system, creating a natural direction for energy flow. As the system evolves under this time-independent Hamiltonian, energy flows from the computational system to the bath, effectively cooling the computational system and driving it toward its ground state.

This approach offers several potential advantages over adiabatic algorithms. First, the Hamiltonian is time-independent, which may be easier to implement experimentally. Second, the bath provides a natural mechanism for error correction, as any excess energy in the computational system can be dissipated into the bath. Third, the approach may be more robust to certain types of noise, as the bath can absorb fluctuations.

=== Numerical Simulation of Quantum Ice Box

For the NAND logic problem, we construct the quantum ice box system as follows:

$
  H_s &= Z_1 Z_2 + 2Z_2 Z_3 + 2Z_1 Z_3 + Z_1 + Z_2 + 2Z_3, \
  H_b &= -(bold(S)_4 dot.c bold(S)_5 + bold(S)_5 dot.c bold(S)_6 + bold(S)_6 dot.c bold(S)_4), \
  H_i &= -lambda(X_1 X_4 + X_2 X_5 + X_3 X_6)
$

where $H_s$ encodes the NAND problem (as before), $H_b$ is a simple spin system with an easily prepared ground state (a triangle of spins with antiferromagnetic interactions), and $H_i$ couples each qubit in the computational system to a corresponding spin in the bath with coupling strength $lambda$.

The results of the numerical simulation are shown in @icebox-simulation.

#figure(
  caption: [Numerical simulation of quantum ice box algorithm for NAND logic],
  image("nand_cc.pdf", width: 60%)
) <icebox-simulation>

The simulation demonstrates how the computational system evolves toward its ground state as it interacts with the bath. The coupling strength $lambda$ plays a crucial role: if $lambda$ is too small, the energy transfer is too slow, and the maximum energy transfered is small.

== Discussion and Outlook

=== Summary

This report has explored alternative paradigms for computation that move beyond traditional gate-based approaches. We have demonstrated how computational rules can be encoded into the ground states of physical Hamiltonians, transforming computation into a process of thermal relaxation or quantum annealing. Using the NAND logic gate as a concrete example, we have shown that both gate-based and ground-state-based approaches can achieve the same computational goals through fundamentally different physical mechanisms.

We have examined two primary quantum algorithms for reaching ground states:
- *Quantum Adiabatic Algorithm*: Employs time-dependent Hamiltonians that evolve from an easily prepared initial state to the problem Hamiltonian, relying on quantum adiabaticity to maintain the system in its ground state.
- *Quantum Ice Box Algorithm*: Utilizes time-independent Hamiltonians with structured baths that facilitate energy transfer from the computational system to the bath, driving the system toward its ground state.

Both approaches have their advantages and challenges. The adiabatic approach is well-studied and has been implemented on quantum annealing devices, but requires careful control of the evolution schedule and may suffer from exponentially small energy gaps. The ice box approach offers the advantage of time-independent Hamiltonians and natural error correction through the bath, but requires careful design of the bath structure and coupling.

=== Outlook

Several important questions remain for future research:

1. *Scaling laws*: How does the required bath size scale with the problem size? Understanding this scaling is crucial for determining the practical viability of the quantum ice box approach for large-scale problems.

2. *Finite-size effects*: Real baths are finite in size, and the coupling between the computational system and bath is finite in strength. This introduces non-Markovian effects and memory kernels that may affect the dynamics. Developing a theoretical framework to understand and optimize these effects is an important direction for future work.

// 3. *Comparison with other approaches*: A systematic comparison of the quantum ice box algorithm with other quantum optimization and computation methods, including quantum adiabatic algorithms, variational quantum algorithms, and gate-based quantum computing, would help clarify the relative advantages and limitations of each approach.

// 4. *Experimental implementation*: While numerical simulations demonstrate the feasibility of these approaches, experimental implementation on quantum hardware will be necessary to validate their practical utility. Identifying suitable physical platforms and developing robust control protocols are important next steps.

The exploration of alternative computational paradigms, such as those based on ground state encoding and thermal relaxation, may lead to new insights into the fundamental nature of computation and provide practical advantages for certain classes of problems.

#bibliography("references.bib")
