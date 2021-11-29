module CitableLibrary

using Documenter, DocStringExtensions
using CitableBase, CitableObject

using Random, UUIDs

import CitableBase: cex
import CitableBase: urncontains

export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection

import Base: iterate

export urncontains, urnequals, cex
export iterate
export citable

export CiteLibrary, citeLibrary

include("librarytype.jl")
include("librarytrait.jl")


## For debugging:
include("dummy.jl")
export IsbnUrn, ReadingList

end # module
