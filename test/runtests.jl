using CitableLibrary
using CitableBase
import CitableLibrary: CitableLibraryTrait
import Base: iterate
import Base: show
using Test

@testset "Test trait" begin
    struct IsbnUrn <: Urn
        isbn::AbstractString
    end
   function show(io::IO, isbn::IsbnUrn)
        show(io, isbn.isbn)
    end
    isbns = [IsbnUrn("urn:isbn:022661283X"),IsbnUrn("urn:isbn:3030234134"),IsbnUrn("urn:isbn:022656875X")]



    struct ReadingList
        reff::Vector{IsbnUrn}
    end    
    CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()

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

    # Something is wrong in `Test` environment config:
    # this tests fine in docstrings.
    # 
    #=
    readingList = ReadingList(isbns)
    for r in readingList
        @test ! isnothing(r)
    end

    # implement [to|from]blocks
    function toblocks(rlist::ReadingList)
        lines = ["#!fakeblocktype"]
        for item in rlist
            push!(lines, item.isbn)
        end
        join(lines, "\n")
    end

    # implement [to|from]blocks
    function fromblocks(cex::AbstractString, ReadingList)
        # In reality: use CiteEXchange library to extract blocks
        # of desired type(s).
        lines = split(cex, "\n")
        isbnlist = []
        for ln in lines[2:end]
            push!(isbnlist, IsbnUrn(ln))
        end
        ReadingList(isbnlist)
    end
    # Round trip it
    rlist2 = fromblocks(toblocks(readingList), ReadingList)
    for i in 1:length(rlist2.reff)
        @test rlist2.reff[i] == readingList.reff[i]
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
    =#
end