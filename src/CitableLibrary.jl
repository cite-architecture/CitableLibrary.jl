module CitableLibrary
using Documenter, DocStringExtensions
using Random, UUIDs

import Base: iterate
import Base: show

using CitableBase

import CitableBase: CitableTrait
import CitableBase: urn
import CitableBase: label

import CitableBase: CexTrait
import CitableBase: cex
import CitableBase: fromcex

# Citable trait:
import CitableBase: citabletrait

# Cite library:
export CiteLibrary, library
export collectiontypes, collections
export license, cexversion

CURRENT_CEX_VERSION = v"3.0.2"


include("librarytype.jl")
include("uuidurn.jl")
include("libcex.jl")

end # module
