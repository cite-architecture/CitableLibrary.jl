# The `CitableLibrary`

> - a library has a list of 0 or more collection objects implementing the `CitableLibraryTrait`
> - content can be selected from collections using URN logic
> - the library can be serialized to plain text in CEX format

This example builds a library with a single citable collection.  The collection is of a type called `ReadingList`, and its contents are a list of ISBN values.  (The following section on the `CitableLibraryTrait` shows you how to implement your own citable collection by walking through the implementation of the `ReadingList` type.)


```@setup citelib
using CitableLibrary
using CitableBase

struct IsbnUrn <: Urn
    isbn::AbstractString
end
import Base: show
function show(io::IO, u::IsbnUrn)
    print(io, u.isbn)
end

struct ReadingList
    reff::Vector{IsbnUrn}
end

import CitableLibrary: CitableLibraryTrait
import CitableLibrary: urnequals
import CitableLibrary: urncontains
CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()


function urnequals(isbn::IsbnUrn, rlist::ReadingList)
    matches = filter(i -> i == isbn, rlist.reff)
    isempty(matches) ? nothing : matches[1]
end

function urncontains(isbn::IsbnUrn, rlist::ReadingList)
    filter(i -> i == isbn, rlist.reff)
end

import CitableBase: CitableTrait
struct IsbnCitable <: CitableTrait end
CitableTrait(::Type{ReadingList})  = IsbnCitable
import CitableLibrary: cex
function cex(reading::ReadingList; delimiter = "|")
    header = "#!fakecexblock\n"
    strings = map(ref -> ref.isbn, reading.reff)
    header * join(strings, "\n")
end

import CitableBase: fromcex
function fromcex(src::AbstractString, ReadingList)
    isbns = []
    lines = split(src, "\n")
    for i in 2:length(lines)
        push!(isbns,IsbnUrn(lines[i]))
    end
    ReadingList(isbns)
end

isbns = [IsbnUrn("urn:isbn:022661283X"),IsbnUrn("urn:isbn:3030234134"),IsbnUrn("urn:isbn:022656875X")]
readingList = ReadingList(isbns)

citelib = citeLibrary([readingList])
```


```@example citelib
citelib
```

## Library metadata

```@example citelib
libname(citelib)
```

```@example citelib
liburn(citelib)
```
```@example citelib
license(citelib)
```

```@example citelib
cexversion(citelib)
```


## Find out about collections in library

```@example citelib
collectiontypes(citelib)
```

```@example citelib
collections(citelib)
```

```@example citelib
collections(citelib, ReadingList)
```

## Query library by URN value

```@example citelib
urn = IsbnUrn("urn:isbn:022661283X")
urnequals(urn, citelib, ReadingList)
```



```@example citelib
urncontains(urn, citelib, ReadingList)
```

## Serialize

```@example citelib
cex(citelib)
```

```@example citelib
block = """#!fakecexblock
urn:isbn:022661283X
urn:isbn:3030234134
urn:isbn:022656875X
"""
fromcex(block, ReadingList)
```