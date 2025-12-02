#import "@preview/touying:0.6.1": *
#import "@preview/touying-simpl-hkustgz:0.1.2": *
#import "@preview/cetz:0.4.2": *

// Specify `lang` and `font` for the theme if needed.
#show: hkustgz-theme.with(
  // lang: "zh",
  // font: (
  //   (
  //     name: "Linux Libertine",
  //     covers: "latin-in-cjk",
  //   ),
  //   "Source Han Sans SC",
  //   "Source Han Sans",
  // ),
  config-info(
    title: [Computing by Cooling],
    short-title: [Computing by Cooling],
    subtitle: [],
    author: [Longli Zheng\ \ #text(size: 0.6em)[https://github.com/Br0kenSmi1e/QuantumIceBox.jl]],
    date: datetime.today(),
    institution: [AMAT, FUNH, HKUST(GZ)]
  ),
)

#title-slide()

// #outline-slide()

// = Computation using Ground State

== Computation by Logic Gates

Conventional computation are based on gates, e.g., classic NAND gate, quantum Clifford gates.
We apply these gates to the input state to get the output state.

Example: Quantum NAND Gate

// A quantum NAND gate can be implemented using a Toffoli gate (CCNOT):
// $|a, b, c> -> |a, b, c + (a and b) mod 2>$

$
  |s_1, s_2, s_3 = not(s_1 and s_2) chevron.r = "Toffoli" |s_1, s_2, 1 chevron.r
$

// #v(0.3em)

// Circuit: $|a> times |b> times |1> -> "Toffoli" -> |a> times |b> times |"NAND"(a,b)>$

#v(0.5em)
#figure(
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
  
  // Labels - using simple text
  content((-0.4, 0), [$s_1$])
  content((-0.4, -sp), [$s_2$])
  content((-0.4, -2 * sp), [$1$])
  content((wl + 0.4, 0), [$s_1$])
  content((wl + 0.4, -sp), [$s_2$])
  content((wl + 2.4, -2 * sp), [$s_3 = not(s_1 and s_2)$])
}))

#place(
  bottom + right,
  dx: 0em, dy: 0.5em,
  [
    #text(size: 0.6em)[
      Nielsen, M. A., & Chuang, I. L. (2010). _Quantum computation and quantum information_. Cambridge University Press.
    ]
  ]
)

== Computation by Ground State

Another formalism is to encode the rules into ground states of certain Hamiltonians.

Take NAND logic as example:

There are four items in the truth table of NAND logic:

#grid(
  columns: 2,
  column-gutter: 1.5em,
  [
    #table(
      columns: (64pt, 64pt, 64pt),
      table.header([$s_1$], [$s_2$], [$s_3$]),
      [$0$], [$0$], [$1$],
      [$0$], [$1$], [$1$],
      [$1$], [$0$], [$1$],
      [$1$], [$1$], [$0$],
    )
  ],
  [
    Consider a Ising spin glass with Hamiltonian,
    $
      H = s_1 s_2 + 2s_2 s_3 + 2s_1 s_3 + s_1 + s_2 + 2s_3,
    $
    which has 4-fold degenerate ground states
    $
      // (arrow.b -1, -1, +1), (-1, +1, -1), (+1, -1, -1), (+1, +1, -1),
      s_1 s_2 s_3 = arrow.t arrow.t arrow.b, arrow.t arrow.b arrow.b, arrow.b arrow.t arrow.b, arrow.b arrow.b arrow.t
    $
    that corresponds to the 4 items in the truth table (map $arrow.b$ to $1$ and $arrow.t$ to $0$).
  ],
)

#place(
  bottom + right,
  dx: 0em, dy: 0.5em,
  [
    #text(size: 0.6em)[
      Nguyen et al. _Quantum optimization with arbitrary connectivity using Rydberg atom arrays_. PRX Quantum, 4(1), p.010316.
    ]
  ]
)

== Computation by Annealing

Since we can write the computational rules into the ground states of certain Hamiltonians, computation is the process of cooling or annealing the system to the ground state.

For classical computers, we have many well-known algorithms such as simulated annealing.

On quantum computers, there are mainly two approaches:

- annealing through adiabatic evolution.
- cooling through interaction with a structured bath (heat sink).

== Quantum Adiabatic Algorithm (QAA)

In this algorithm, we construct a time-dependent Hamiltonian $H(t)$ that evolves from a simple Hamiltonian $H_D$ to the problem Hamiltonian $H_P$ adiabatically.

$
  H(t) = (1 - s(t)) H_D + s(t) H_P quad
  (s(0) = 0, s(T) = 1),
$

(by simple we mean the ground state is easy to prepare.)

If the system is in the ground state of $H_D$ at time $t = 0$, and the evolution is sufficiently slow, we hope the system would remain in the ground state throughout the evolution.

#place(
  bottom + right,
  dx: 0em, dy: 0.5em,
  [
    #text(size: 0.6em)[
      Rajak et al. _Quantum annealing: An overview_. Philosophical Transactions of the Royal Society A, 381(2241), p.20210417.
    ]
  ]
)

// numeric example
== Numerical Simulation of QAA

#grid(
  columns: 2,
  column-gutter: 1.5em,
  [
    $
      H_D &= - (X_1 + X_2 + X_3)\
      H_P &= Z_1 Z_2 + 2Z_2 Z_3 + 2Z_1 Z_3 \ & quad + Z_1 + Z_2 + 2Z_3\
      s &= v t
    $

  ],
  [
    #figure(
      image("nand_qa.pdf", height: 95%)
    )
  ],
)

== Quantum Ice Box Algorithm

In this algorithm, we separate the system into two parts: the computational system and the bath.
$
  H = H_s + H_b + H_i,
$
- The computational system $H_s$ encodes the problem.
- The bath $H_b$ is a simple system with easy-to-prepare ground state.
- The coupling $H_i$ allows energy transfer from the computational system to the bath.

In this algorithm, the Hamiltonian is *time-independent*.

#place(
  bottom + right,
  dx: 0em, dy: 0.5em,
  [
    #text(size: 0.6em)[
      Feng, J.J., Wu, B. and Wilczek, F. _Quantum computing by coherent cooling_. Physical Review A, 105(5), p.052601.
    ]
  ]
)


// numeric example
== Numerical Simulation of Quantum Ice Box
#grid(
  columns: 2,
  column-gutter: 0.5em,
  [
    $
      H_s &= Z_1 Z_2 + 2Z_2 Z_3 + 2Z_1 Z_3 \ & quad + Z_1 + Z_2 + 2Z_3\
      H_b &= - (bold(S)_4 dot.c bold(S)_5 + bold(S)_5 dot.c bold(S)_6 + bold(S)_6 dot.c bold(S)_4)\
      H_i &= -lambda (X_1 X_4 + X_2 X_5 + X_3 X_6)
    $
  ],
  [
    #figure(
      image("nand_cc.pdf", height: 90%)
    )
  ]
)

== Discussion and Outlook

Summary:
- Annealing formalism is introduced.
- Quantum annealing vs quantum ice box.

Outlook:
- Scaling law of bath size with problem size.
- Abstraction of finite size bath and finite coupling (non-Markovian memory kernel).
