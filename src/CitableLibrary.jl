module CitableLibrary

import Base: iterate
import Base: show

using Random, UUIDs

using CitableBase
import CitableBase: cex
import CitableBase: urncontains

using Documenter, DocStringExtensions


# Citable trait:
export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection
export urncontains, urnequals, cex, fromcex
export iterate
export citable
export urn, label

# Cite library:
export CiteLibrary, citeLibrary
export collectiontypes, collections
export libname, liburn, license, cexversion

include("librarytrait.jl")
include("librarytype.jl")
include("uuidurn.jl")

end # module
