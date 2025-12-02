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
    author: [Longli Zheng],
    date: datetime.today(),
    institution: [HKUST(GZ)],
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
      [$1$], [$0$], [$1$],
      [$0$], [$1$], [$1$],
      [$1$], [$1$], [$0$],
      [$0$], [$0$], [$1$],
    )
  ],
  [
    Consider a Ising spin glass with Hamiltonian,
    $
      H = s_1 s_2 + 2s_2 s_3 + 2s_1 s_3 + s_1 + s_2 + 2s_3,
    $
    which has 4-fold degenerate ground states
    $
      (-1, -1, +1), (-1, +1, -1), (+1, -1, -1), (+1, +1, -1),
    $
    that corresponds to the 4 items in the truth table (map $-1$ to $1$ and $+1$ to $0$).
  ],
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

A frequently used choice is the transverse field Ising model $H_D = - sum_i X_i$ and the problem Hamiltonian $H_P = sum_i h_i Z_i + sum_(i j) J_(i j) Z_i Z_j$.

// numeric example

== Quantum Ice Box Algorithm

In this algorithm, we separate the system into two parts: the computational system and the bath.
$
  H = H_s + H_b + H_i,
$
- The computational system $H_s$ encodes the problem.
- The bath $H_b$ is a simple system with easy-to-prepare ground state.
- The coupling $H_i$ allows energy transfer from the computational system to the bath.

In this algorithm, the Hamiltonian is *time-independent*.

// numeric example

== Discussion and Outlook

- Annealing formalism is introduced.
- Quantum annealing vs quantum ice box.
- finite size bath and finite coupling (non-Markovian)
