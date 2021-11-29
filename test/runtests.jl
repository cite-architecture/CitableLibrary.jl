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


    # make iterable:
    function iterate(rlist::ReadingList)
        (rlist.reff[1], 2)
    end
    function iterate(rlist::ReadingList, state)
        if state > length(rlist.reff)
            nothing
        else
            (rlist.reff[state], state + 1)
        end
    end


    @test CitableLibraryTrait(typeof(readingList)) == CitableLibraryCollection()
    @info(typeof(readingList),CitableLibraryTrait(typeof(readingList)))
    #= I don't understand why in the Test environment the
    CitableLibraryTrait for ReadingList type is lost.
    ?
    =#
    @test_broken citable(readingList)
    #citelib = citeLibrary([readingList])
    #@test citelib isa CiteLibrary
end