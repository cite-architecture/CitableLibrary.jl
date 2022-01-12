module CitableLibrary
using Documenter, DocStringExtensions
using Random, UUIDs

import Base: iterate
import Base: show

using CiteEXchange

using CitableBase

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
export sections, insection
export license, cexversion

export CitableCollectionsLibrary

export SectionConfiguration, LibrarySections 
export CollectionSections, TextSections, DataModelSections, RelationSections

CURRENT_CEX_VERSION = v"3.0.2"


include("sections.jl")
include("librarytype.jl")
include("uuidurn.jl")
include("libcex.jl")

include("readers/collections.jl")

end # module
