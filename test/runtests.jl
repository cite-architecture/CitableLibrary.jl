using CitableLibrary
using CitableBase
import CitableLibrary: CitableLibraryTrait

using Test

@testset "Test trait" begin
    struct IsbnUrn <: Urn
        isbn::AbstractString
    end
    
    struct ReadingList
        reff::Vector{IsbnUrn}
    end
    
    CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()

    isbns = [IsbnUrn("urn:isbn:022661283X"),IsbnUrn("urn:isbn:3030234134"),IsbnUrn("urn:isbn:022656875X")]
    readingList = ReadingList(isbns)


    @test CitableLibraryTrait(typeof(readingList)) == CitableLibraryCollection()

    #citelib = CiteLibrary([readingList])
    #@test_broken citelib isa CiteLibrary

end