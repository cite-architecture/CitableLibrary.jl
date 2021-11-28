module CitableLibrary

using Documenter, DocStringExtensions
using CitableBase, CitableObject

using Random, UUIDs

import CitableBase: cex
import CitableBase: urncontains

export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection



export urncontains, urnequals

export CiteLibrary, citeLibrary

include("librarytype.jl")
include("librarytrait.jl")

end # module
