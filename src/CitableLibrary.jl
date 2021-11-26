module CitableLibrary

using Documenter, DocStringExtensions
using CitableBase

import CitableBase: cex
import CitableBase: urncontains

export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection

export urncontains, urnequals

export CiteLibrary

include("librarytype.jl")
include("librarytrait.jl")

end # module
