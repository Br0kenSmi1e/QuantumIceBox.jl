using QuantumIceBox
using Documenter

DocMeta.setdocmeta!(QuantumIceBox, :DocTestSetup, :(using QuantumIceBox); recursive=true)

makedocs(;
    modules=[QuantumIceBox],
    authors="LongliZheng",
    sitename="QuantumIceBox.jl",
    format=Documenter.HTML(;
        canonical="https://Br0kenSmi1e.github.io/QuantumIceBox.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Br0kenSmi1e/QuantumIceBox.jl",
    devbranch="main",
)
