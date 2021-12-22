module CitableLibrary
using Documenter, DocStringExtensions
using Random, UUIDs

import Base: iterate
import Base: show

using CitableBase

import CitableBase: CexTrait
import CitableBase: cex
import CitableBase: fromcex

import CitableBase: UrnComparisonTrait
import CitableBase: urncontains
import CitableBase: urnsimilar
import CitableBase: urnequals


# Citable trait:
export CitableLibraryTrait, CitableLibraryCollection, NotCitableLibraryCollection
#export urncontains, urnequals, cex, fromcex
#export iterate
export citablecollection
#export urn, label
export fromblocks, toblocks

# Cite library:
export CiteLibrary, citeLibrary
export collectiontypes, collections
export libname, liburn, license, cexversion

include("librarytrait.jl")
include("librarytype.jl")
include("uuidurn.jl")

end # module
