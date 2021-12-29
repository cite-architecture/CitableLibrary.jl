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
    header = "#!citecollection\n"
    strings = map(ref -> cex(ref, delimiter=delimiter), reading.publications)
    header * join(strings, "\n") * "\n"
end

function fromcex(trait::ReadingListCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing)

    lines = split(cexsrc, "\n")
    isbns = CitableBook[]
    inblock = false
    for ln in lines
        if ln == "#!citecollection"
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

```


# CitableLibrary.jl


The  `CitableLibrary` package defines a type, the `CiteLibrary`, which includes one or more *collections of citable resources*. The `CiteLibrary` itself is a *citable object*:  it can be cited by URN, and identified with a human-readable label.  It is also serializable, and can be losslessly represented in CEX format and instantiated from the same plain-text representation.

A `CiteLibrary` can work with any citable collection, containing any kind of citable object, citable by any kind of URN, so long as they fulfill the contract of the `CitableCollectionTrait` from `CitableBase`.  In the following walk through, we'll use the sample collection type that is developed in the [documentation for `CitableBase`](https://cite-architecture.github.io/CitableBase.jl/stable/).

The libary has two CITE traits:

- `CitableTrait`
- `CexTrait`

Each collections has the `CitableCollectionTrait` which entails `Iterators`, `UrnComparisonTrait`, and `CexTrait`.


!!! info "More about the CITE architecture"

    For an introduction to citable objects, citable collections, and their implementation in Julia, see the [documentation for `CitableBase`](https://cite-architecture.github.io/CitableBase.jl/stable/).


## An example collection: the `ReadingList` type

Our example collection is a reading list of citable books instantiated as a citable collection of type `ReadingList`.  Individual books are `CitableBook`s, and are cited by `Isbn10Urn`.  The setup block for this page has created a `ReadingList` with four entries.


```@example lib
rl
```



## The `CiteLibrary`: a citable object

We can build a library as easily as giving the `library` function a list of citable collections.


```@example lib
using CitableLibrary
citelib = library([rl])
```

The library is itself a citable object, as we can verify with the `citable` function from `CitableBase`.

```@example lib
citable(citelib)
```

That means we can find a URN and label for the library as whole.

```@example lib
urn(citelib)
```


```@example lib
label(citelib)
```

These values were generated automatically, but you can supply your own values with optional parameters. (See the API documentation for full details.)

```@example lib
labelledlib = library([rl], libname = "Library id'ed by automatically generated URN, but manually supplied label")

label(labelledlib)
```

Other metadata about the library that you can optionally define manually include its license and the version of the CEX specification it uses.  Here are  the default values.

```@example lib
license(citelib)
```

```@example lib
cexversion(citelib)
```


## Find out about the library's collections

A single library might include collections of multiple types.  You can find out what types of collections appear in your library with the `collectiontypes` function.

```@example lib
collectiontypes(citelib)
```

Of course you can also get a list of the collections themselves.
```@example lib
collections(citelib)
```

You can include a second parameter to limit the returned list to collections of a particular type.  This example finds all collections of type `ReadingList`.

```@example lib
collections(citelib, ReadingList)
```


## Serializing to CEX

A citable library is serializable to and from CEX.

```@example lib
cexserializable(citelib)
```


Therefore we can use the `cex` function to generate a plain-text representation of the library's contents.


```@example lib
cexview = cex(citelib)
println(cexview)
```