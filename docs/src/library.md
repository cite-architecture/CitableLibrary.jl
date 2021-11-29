# The `CitableLibrary`

- has a list of 0 or more collection objects implementing the `CitableLibraryTrait`
- can be serialized to plain text in CEX format

This example assumes we have a library with a single citable collection.  The collection is of a type called `ReadingList`, and its contents are a list of ISBN values.  (The following section on the `CitableLibraryTrait` shows you how to implement your own citable collection by walking through the implementation of the `ReadingList` type.)


```@setup citelib
using CitableLibrary
using CitableBase
struct IsbnUrn <: Urn
    isbn::AbstractString
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

