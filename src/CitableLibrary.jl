module CitableLibrary

using Documenter, DocStringExtensions
using CitableBase

export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection

export lookupurn

include("library.jl")

end # module
