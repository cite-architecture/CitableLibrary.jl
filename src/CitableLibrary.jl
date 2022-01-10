module CitableLibrary
using Documenter, DocStringExtensions
using Random, UUIDs

import Base: iterate
import Base: show

using CiteEXchange

using CitableBase
using CitableText

import CitableBase: CitableTrait
import CitableBase: urn
import CitableBase: label

import CitableBase: cextrait
import CitableBase: cex
import CitableBase: fromcex
export LibraryCex

# Citable trait:
import CitableBase: citabletrait


# Cite library:
export CiteLibrary, library
export collectiontypes, collections
export license, cexversion

export CitableCollectionsLibrary
export SectionConfig 


CURRENT_CEX_VERSION = v"3.0.2"


include("librarytype.jl")
include("uuidurn.jl")
include("sections.jl")
include("libcex.jl")
# include("readers/texts.jl")

end # module
