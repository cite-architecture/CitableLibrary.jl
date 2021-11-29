struct IsbnUrn <: Urn
    isbn::AbstractString
end

import Base:  write
export write
function write(isbn::IsbnUrn)
    isbn.isbn
end

struct ReadingList
    reff::Vector{IsbnUrn}
end

CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()


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

function cex(rlist::ReadingList; delimiter = "|")
    "isbn\n" * join(rlist.reff, "\n")
end
