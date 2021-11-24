# CitableLibrary.jl

## How to implement the CitableLibraryTrait


```@jldoctest citelib
using CitableLibrary
using CitableBase
using CitableText

struct IsbnUrn <: Urn
    isbn::AbstractString
end

struct ReadingList
    reff::Vector{IsbnUrn}
end

isbnlist = ["022661283X","3030234134","022656875X"]
isbns = map(i -> IsbnUrn(i), isbnlist)

readingList = ReadingList(isbns)

import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()

import CitableLibrary: lookupurn

function lookupurn(u::IsbnUrn, faves::ReadingList)
    filter(ref -> ref == u, faves.reff)
end


```