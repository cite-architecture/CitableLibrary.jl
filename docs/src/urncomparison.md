```@setup citelib
using CitableLibrary
using CitableBase

struct Isbn10Urn <: Urn
    isbn::AbstractString
end

distanthorizons = Isbn10Urn("urn:isbn:022661283X")
quantitativeintertextuality = Isbn10Urn("urn:isbn:3030234134")
enumerations = Isbn10Urn("urn:isbn:022656875X")
wrong = Isbn10Urn("urn:isbn:1108922036")
jane = Isbn10Urn("urn:isbn:0141395203") # Because all computational literary analysis is required to use Jane Austen as an example

struct ReadingList
    reff::Vector{Isbn10Urn}
end

rl = ReadingList([distanthorizons,enumerations, enumerations, wrong, jane])
```

# Filtering with URN logic


The [`CitableBase` package](https://cite-architecture.github.io/CitableBase.jl/stable/) identifies three kinds of URN comparison: *equality*, *containment* and *similarity*.  We want to be able to apply that logic to query our new `ReadingList` type.  If your citable collection includes objects cited by `Cite2Urn` or `CtsUrn`, this is as simple as filtering the collection using their `urnequals`, `urncontains` or `urnsimilar` functions.  Since we have defined a custom `Isbn10Urn` type, we'll need to implement those functions for our new URN type. We'll digress briefly with that implementation before turning to filtering our citable collection.



!!! note

    For an introduction to defining URN types and implementing the `UrnComparable` trait, see the documentation for the [CitableBase package](https://cite-architecture.github.io/CitableBase.jl/stable/urns/) 


## Digression: implementing URN comparison on `Isbn10Urn`


The `CitableBase` package provides a concrete implementation of `urnequals`, but we need to import and define functions for `urncontains` and `urnsimilar`


### Containment

For our ISBN type, we'll define "containment" as true when two ISBNS belong to the same initial-digit group (`0` - `4`).  We'll use the `components` functions from `CitableBase` to extract the third part of the URN string, and compare its first character.

```@example citelib
import CitableBase: urncontains
function urncontains(u1::Isbn10Urn, u2::Isbn10Urn)
    initial1 = components(u1.isbn)[3][1]
    initial2 = components(u2.isbn)[3][1]

    initial1 == initial2
end
```

Both *Distant Horizons* and *Enumerations* are in ISBN group 0.

```@example citelib
urncontains(distanthorizons, enumerations)
```

But *Can We Be Wrong?* is in ISBN group 1.

```@example citelib
urncontains(distanthorizons, wrong)
```


### Similarity

We'll define "similarity" as belonging to the same language area.  In this definition, both `0` and `1` indicate English-language countries.


```@example citelib
# True if ISBN starts with `0` or `1`
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
```

Both *Distant Horizons* and *Can We Be Wrong?* are published in English-language areas.

```@example citelib
urnsimilar(distanthorizons, wrong)
```



## Filtering a citable collection

Whether you use `Cite2Urn`s, `CtsUrn`s, or define your own URN type, as we did for ISBNs, filtering a collection of your content with URN logic is straightforward. All you need to do is define functions for `urnequals`, `urncontains` and `urnsimilar` that take a URN parameter to filter with (here, an `Isbn10Urn`), and a citable collection to filter (here, a `ReadingList`).  If no objects match, we'll return `nothing`; otherwise, we'll return a list of content matching your URN.


```@example citelib
function urnequals(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> i == isbn, rlist.reff)
    isempty(matches) ? nothing : matches
end

function urncontains(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> urncontains(i, isbn), rlist.reff)
    isempty(matches) ? nothing : matches
end

function urnsimilar(isbn::Isbn10Urn, rlist::ReadingList)
    matches = filter(i -> urnsimilar(i, isbn), rlist.reff)
    isempty(matches) ? nothing : matches
end
```

```@example citelib
urnequals(jane, rl)
```


```@example citelib
group1 = Isbn10Urn("urn:isbn:1")
urncontains(group1, rl)
```

```@example citelib
urnsimilar(group1, rl)
```