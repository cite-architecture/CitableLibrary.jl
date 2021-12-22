


```@setup cex
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


# The `CitableLibrary`




isbns = [Isbn10Urn("urn:isbn:022661283X"),Isbn10Urn("urn:isbn:3030234134"),Isbn10Urn("urn:isbn:022656875X")]
rl = ReadingList(isbns)

citelib = citeLibrary([rl])



```
citelib
```

## Library metadata

```
libname(citelib)
```

```
liburn(citelib)
```
```
license(citelib)
```

```
cexversion(citelib)
```


## Find out about collections in library

```
collectiontypes(citelib)
```

```
collections(citelib)
```

```
collections(citelib, ReadingList)
```

## Query library by URN value

```
urn = Isbn10Urn("urn:isbn:022661283X")
urnequals(urn, citelib, ReadingList)
```



```
urncontains(urn, citelib, ReadingList)
```

## Serialize

A library can be serialized to CEX format.

```
cex(citelib) |> print
```


Individual collections can be instantiated from complete CEX blocks.


!!! warning

    `fromcex` is not yet implemented for an entire library. Follow this [issue in the issue tracker](https://github.com/cite-architecture/CitableLibrary.jl/issues/12).

Instantiate a `ReadingList` from a CEX block:

```
block = """#!fakecexblock
urn:isbn:022661283X
urn:isbn:3030234134
urn:isbn:022656875X
"""
fromcex(block, ReadingList)
```

```
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end

```

function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end