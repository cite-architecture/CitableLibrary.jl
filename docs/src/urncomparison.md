```@setup citelib
using CitableLibrary
using CitableBase

struct Isbn10EnglishUrn <: Urn
    isbn::AbstractString
end
import Base: show
function show(io::IO, u::Isbn10EnglishUrn)
    print(io, u.isbn)
end

struct ReadingList
    reff::Vector{Isbn10EnglishUrn}
end
isbns = [Isbn10EnglishUrn("urn:isbn:022661283X"),Isbn10EnglishUrn("urn:isbn:3030234134"),Isbn10EnglishUrn("urn:isbn:022656875X")]
rl = ReadingList(isbns)
```

# Filtering with URN logic


The `CitableBase` package identifies three kinds of URN comparison: *equality*, *containment* and *similarity*.  We want to be able to apply that logic to query our new `ReadingList` type.  If your citable collection includes objects cited by `Cite2Urn` or `CtsUrn`, this is as simple as filtering the collection using their `urnequals`, `urncontains` or `urnsimilar` functions.  Since we have defined a custom `Isbn10EnglishUrn` type, we'll need to implement those functions for our new URN type.  


## Digression: implementing URN comparison on `Isbn10EnglishUrn`


The `CitableBase` package provides a concrete implementation of `urnequals`, but we need to import and define functions for `urncontains` and `urnsimilar`
 


```@example citelib
import CitableBase: urncontains
import CitableBase: urnsimilar
```

For our ISBN type, we'll define containment as belonging to the same initial-digit group (`0` or `1`).

```@example citelib
```


First for the ISBN.




!!! note

    For an introduction to defining URN types and implementing the `UrnComparable` trait, see the documentation for the [CitableBase package](https://cite-architecture.github.io/CitableBase.jl/stable/urns/) 

Next for a library.
```@example citelib
function urnequals(isbn::Isbn10EnglishUrn, rlist::ReadingList)
    #matches = filter(i -> i == isbn, rlist.reff)
   # isempty(matches) ? nothing : matches[1]
end

function urncontains(isbn::Isbn10EnglishUrn, rlist::ReadingList)
    #filter(i -> i == isbn, rlist.reff)
end

function similar(isbn::Isbn10EnglishUrn, rlist::ReadingList)
    #filter(i -> i == isbn, rlist.reff)
end

```