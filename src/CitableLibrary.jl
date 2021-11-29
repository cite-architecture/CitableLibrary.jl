module CitableLibrary

import Base: iterate
import Base: show

using CitableObject
using Random, UUIDs

using CitableBase
import CitableBase: cex
import CitableBase: urncontains

using Documenter, DocStringExtensions


# Citable trait:
export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection
export urncontains, urnequals, cex
export iterate
export citable


# Cite library:
export CiteLibrary, citeLibrary
export collectiontypes, collections
export libname, liburn, license, cexversion

include("librarytrait.jl")
include("librarytype.jl")

end # module
