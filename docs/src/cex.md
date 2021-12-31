```@setup lib
using CitableBase
struct Isbn10Urn <: Urn
    isbn::AbstractString
end

import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end

struct IsbnComparable <: UrnComparisonTrait end
import CitableBase: urncomparisontrait
function urncomparisontrait(::Type{Isbn10Urn})
    IsbnComparable()
end

import CitableBase: urnequals
function urnequals(u1::Isbn10Urn, u2::Isbn10Urn)
    u1 == u2
end

import CitableBase: urncontains
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]
    initial1 == initial2
end

function english(urn::Isbn10Urn)
    langarea = components(urn.isbn)[3][1]
    langarea == '0' || langarea == '1'
end

import CitableBase: urnsimilar
function urnsimilar(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    (english(u1) && english(u2)) ||  initial1 == initial2
end

abstract type CitablePublication <: Citable end
struct CitableBook <: CitablePublication
    urn::Isbn10Urn
    title::AbstractString
    authors::AbstractString
end

function show(io::IO, book::CitableBook)
    print(io, book.authors, ", *", book.title, "* (", book.urn, ")")
end

import Base.==
function ==(book1::CitableBook, book2::CitableBook)
    book1.urn == book2.urn && book1.title == book2.title && book1.authors == book2.authors
end

struct CitableByIsbn10 <: CitableTrait end
import CitableBase: citabletrait
function citabletrait(::Type{CitableBook})
    CitableByIsbn10()
end

import CitableBase: urn
function urn(book::CitableBook)
    book.urn
end

import CitableBase: label
function label(book::CitableBook)
    string(book)
end


struct BookComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{CitableBook})
    BookComparable()
end

function urnequals(bk1::CitableBook, bk2::CitableBook)
    bk1.urn == bk2.urn
end
function urncontains(bk1::CitableBook, bk2::CitableBook)
    urncontains(bk1.urn, bk2.urn)
end
function urnsimilar(bk1::CitableBook, bk2::CitableBook)
    urnsimilar(bk1.urn, bk2.urn)
end

struct BookCex <: CexTrait end
import CitableBase: cextrait
function cextrait(::Type{CitableBook})
    BookCex()
end

import CitableBase: cex
"Implement for CitableBook"
function cex(book::CitableBook; delimiter = "|")
    join([string(book.urn), book.title, book.authors], delimiter)
end

import CitableBase: fromcex
function fromcex(traitvalue::BookCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing)
    fields = split(cexsrc, delimiter)
    urn = Isbn10Urn(fields[1])
    CitableBook(urn, fields[2], fields[3])
end



struct ReadingList
    publications::Vector{<: CitablePublication}
end
function show(io::IO, readingList::ReadingList)
    print(io, "ReadingList with ", length(readingList.publications), " items")
end

struct CitableReadingList <: CitableCollectionTrait end

import CitableBase: citablecollectiontrait
function citablecollectiontrait(::Type{ReadingList})
    CitableReadingList()
end

struct ReadingListComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{ReadingList})
    ReadingListComparable()
end

function urnequals(urn::Isbn10Urn, reading::ReadingList, )
    filter(item -> urnequals(item.urn, urn), reading.publications)
end

function urncontains(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urncontains(item.urn, urn), reading.publications)
end

function urnsimilar(urn::Isbn10Urn, reading::ReadingList)
    filter(item -> urnsimilar(item.urn, urn), reading.publications)
end


struct ReadingListCex <: CexTrait end
function cextrait(::Type{ReadingList})
    ReadingListCex()
end


function cex(reading::ReadingList; delimiter = "|")
    header = "#!citedata\n"
    strings = map(ref -> cex(ref, delimiter=delimiter), reading.publications)
    header * join(strings, "\n") * "\n"
end

function fromcex(trait::ReadingListCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing)

    lines = split(cexsrc, "\n")
    isbns = CitableBook[]
    inblock = false
    for ln in lines
        if ln == "#!citedata"
            inblock = true
        elseif inblock && !isempty(ln)
            bk = fromcex(ln, CitableBook)
            push!(isbns, bk)
        end
    end
    ReadingList(isbns)
end


import Base: iterate

function iterate(rlist::ReadingList)
    isempty(rlist.publications) ? nothing : (rlist.publications[1], 2)
end

function iterate(rlist::ReadingList, state)
    state > length(rlist.publications) ? nothing : (rlist.publications[state], state + 1)
end

import Base: length
function length(readingList::ReadingList)
    length(readingList.publications)
end

import Base: eltype
function eltype(readingList::ReadingList)
    CitablePublication
end

distanthorizons = Isbn10Urn("urn:isbn10:022661283X")
enumerations = Isbn10Urn("urn:isbn10:022656875X")
wrong = Isbn10Urn("urn:isbn10:1108922036")
qi = Isbn10Urn("urn:isbn10:3030234133")

distantbook = CitableBook(distanthorizons, "Distant Horizons: Digital Evidence and Literary Change", "Ted Underwood")
enumerationsbook = CitableBook(enumerations, "Enumerations: Data and Literary Study", "Andrew Piper")
wrongbook = CitableBook(wrong, "Andrew Piper", "Can We Be Wrong? The Problem of Textual Evidence in a Time of Data")
qibook = CitableBook(qi, "Quantitative Intertextuality: Analyzing the Markers of Information Reuse","Christopher W. Forstall and Walter J. Scheirer")

books = [distantbook, enumerationsbook, wrongbook, qibook]
rl = ReadingList(books)

using CitableLibrary
citelib = library([rl])
```


# Reading and writing a library

## Serialization to CEX

A citable library is serializable to and from CEX.

```@example lib
cexserializable(citelib)
```

Therefore we can use the `cex` function to generate a plain-text representation of the library's contents.

```@example lib
cexview = cex(citelib)
println(cexview)
```



# Instantiating a library from CEX

The inverse function of `cex` is `fromcex`.  For citable objects and citable collections, the `fromcex` function simply instantiates objects of a single type identified in a parameter. For example, we could instantiate a `CitableBook` like this:

```@example lib
cexoutput = cex(distantbook)
```
```@example lib
restored = fromcex(cexoutput, CitableBook)
restored == distantbook
```

Citable libraries, however, need to be able to instantiate not only the `CiteLibrary` type, but the appropriate types of collections for all of its content.  To achieve this, you include the optional `configuration` parameter with a list of `BlockConfig` objects.



```@example lib
libcex = cex(citelib)
```

Model on 1 coll. how to do for all collections in lib:

```@example lib
conf = [BlockConfig("citecollection", ReadingList, Isbn10Urn, nothing)]
collcex = "#!citedata\n" * join(data(libcex,"citedata"), "\n")
fromcex(collcex, conf[1].C)

# restoredlib = fromcex(libcex, CiteLibrary, configuration = conf)
```
