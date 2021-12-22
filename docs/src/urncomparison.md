```@setup citelib
using CitableLibrary
using CitableBase

struct Isbn10Urn <: Urn
    isbn::AbstractString
end

distanthorizons = Isbn10Urn("urn:isbn:022661283X")
quantitativeintertextuality = Isbn10Urn("urn:isbn:3030234134")
enumerations = Isbn10Urn("urn:isbn:022656875X")
jane = Isbn10Urn("0141395203")

struct ReadingList
    reff::Vector{Isbn10Urn}
end

rl = ReadingList([distanthorizons,enumerations, enumerations, jane])
```

# Filtering with URN logic


The [`CitableBase` package](https://cite-architecture.github.io/CitableBase.jl/stable/) identifies three kinds of URN comparison: *equality*, *containment* and *similarity*.  We want to be able to apply that logic to query our new `ReadingList` type.  If your citable collection includes objects cited by `Cite2Urn` or `CtsUrn`, this is as simple as filtering the collection using their `urnequals`, `urncontains` or `urnsimilar` functions.  Since we have defined a custom `Isbn10Urn` type, we'll need to implement those functions for our new URN type. We'll digress briefly with that implementation before turning to filtering our citable collection.



!!! note

    For an introduction to defining URN types and implementing the `UrnComparable` trait, see the documentation for the [CitableBase package](https://cite-architecture.github.io/CitableBase.jl/stable/urns/) 


## Digression: implementing URN comparison on `Isbn10Urn`


The `CitableBase` package provides a concrete implementation of `urnequals`, but we need to import and define functions for `urncontains` and `urnsimilar`
 
```@example citelib
import CitableBase: urncontains
import CitableBase: urnsimilar
```

For our ISBN type, we'll define "containment" as belonging to the same initial-digit group (`0` - `4`).  We'll use the `components` functions from `CitableBase` to extract the third part of the URN string, and compare its first character.

```@example citelib
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    components1 = components(u1.isbn)[3]
    components2 = components(u2.isbn)[3]
    components1[1] == components2[1]
end
```



```@example citelib
```



First for the ISBN.





Next for a library.
```@example citelib
function urnequals(isbn::Isbn10Urn, rlist::ReadingList)
    #matches = filter(i -> i == isbn, rlist.reff)
   # isempty(matches) ? nothing : matches[1]
end

function urncontains(isbn::Isbn10Urn, rlist::ReadingList)
    #filter(i -> i == isbn, rlist.reff)
end

function similar(isbn::Isbn10Urn, rlist::ReadingList)
    #filter(i -> i == isbn, rlist.reff)
end

```