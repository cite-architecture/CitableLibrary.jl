# Run this from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Run this from repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter, DocStringExtensions
using CitableLibrary

makedocs(
    sitename="CitableLibrary.jl",
    pages = [
        "Home" => "index.md",
        "The CitableLibrary" => "library.md",
        "The CitableLibraryTrait" => "trait.md",
        "API documentation" => "api.md"
    ],
    )

deploydocs(
        repo = "github.com/cite-architecture/CitableLibrary.jl.git",
)