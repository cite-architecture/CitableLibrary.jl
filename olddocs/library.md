```@setup lib
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

import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()



import CitableBase: CexTrait
CexTrait(::Type{ReadingList}) = CexSerializable()

import CitableBase: cex
function cex(reading::ReadingList; delimiter = "|")
    header = "#!citecollection\n"
    strings = map(ref -> ref.isbn, reading.reff)
    header * join(strings, "\n")
end

import CitableBase: fromcex
function fromcex(src::AbstractString, ReadingList; delimiter = "|")
    isbns = []
    lines = split(src, "\n")
    inblock = false
    for ln in lines
        if ln == "#!citecollection"
            inblock = true
        elseif inblock
            push!(isbns,Isbn10Urn(ln))
        end 
    end
    ReadingList(isbns)
end


rl = ReadingList([distanthorizons,enumerations, enumerations, wrong, jane])
```


# The `CiteLibrary`: a citable object

Once we have a list of citable collections, we can build a library as easily as passing the list to the `library` function.


```@example lib
citelib = library([rl])
```

The library is itself a citable object!

```@example lib
citable(citelib)
```




## Finding out about the library

Since the library is a citable object, it implements the `urn` and `label` functions.

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



Default values for other data you can optionally define manually:

```@example lib
license(citelib)
```

```@example lib
cexversion(citelib)
```


## Find out about the library' collections

A single library might include collections of multiple types.  You find out what types of collecetions appear in your library.

```@example lib
collectiontypes(citelib)
```

Of course you can also get a list of the colletions themselves.
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

## Instantiating a whole library from CEX

For citable objects and citable collections, the inverse function of `cex` is `fromcex`.  In each case, the `fromcex` function instantiates objects of a single type.

Citable libraries, however, need to be able to instantiate many types of citable collections, and therefore cannot be built directly from CEX source with the `fromcex` function.  You can instead use the `CiteEXchange.citelibrary`  function as the inverse of `cex` for citable libraries.   See the [documentation of the `CiteEXchange` package](https://cite-architecture.github.io/CiteEXchange.jl/stable/) for full information about how to use `citelibrary` to create a `CiteLibrary`.

!!! warning

    If you do try to create a `CiteLibrary` with `fromcex`, you will receive a warning, and the function will return `nothing`.


```@example lib
fromcex(cexview, CiteLibrary)
```

