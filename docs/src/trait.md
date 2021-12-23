# The `CitableLibraryTrait`

The  `CitableLibraryTrait` applies to collections of content that can be retrieved by reference to URNs. Implementations of the `CitableLibraryTrait` can be searched by URN value, can be serialized to CEX format, and can be iterated using Julia's generic `Iteration` interface.

To comply with Julia's `Iterators` interface, types supporting the `CitableLibraryTrait` should implement at least `iterate(iter)` and `iterate(iter, state)`:  see the [Julia documentation](https://docs.julialang.org/en/v1/manual/interfaces/).

To make the collection searchable and serializable, the type should support the `urnequals`, `urncontains` and `cex` functions.  The following example illustrates how you can do that.

## How to implement the `CitableLibraryTrait`

In this example, we'll create a collection type for a reading list of books, and make it comply with the `CitableLibraryTrait`.  To do that, we'll need to use both the `CitableLibrary` and `CitableBase` packages.

```@example citetrait
using CitableLibrary
using CitableBase
```

The `CitableLibraryTrait` requires us to be able to find contain by URN values. We could use existing implementations of the `URN` abstraction (such as the `Cite2Urn` and the `CtsUrn`), but for this example we'll invent our own URN type. Our `ReadingList` type will be nothing more than a list of those URN values.

```@example citetrait
struct Isbn10Urn <: Urn
    isbn::AbstractString
end
isbns = [Isbn10Urn("urn:isbn:022661283X"),Isbn10Urn("urn:isbn:3030234134"),Isbn10Urn("urn:isbn:022656875X")]
```
To print and display our custom type, it can be convenient to override `Base.show`.

```@example citetrait
import Base: show
function show(io::IO, u::Isbn10Urn)
    print(io, u.isbn)
end
isbns[1]
```


A `ReadingList` will maintain a Vector of these `Isbn10Urn`s.

```@example citetrait
struct ReadingList
    reff::Vector{Isbn10Urn}
end
readingList = ReadingList(isbns)
```





### Defining a `CitableLibraryTrait`

The first step is to define that our new type fulfills the `CitableLibraryTrait`.

```@example citetrait
import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()
```

We can verify that we've done that correctly.

```@example citetrait
CitableLibraryTrait(typeof(readingList))
```

This can also be verified using the `citable` function:

```@example citetrait
citable(readingList)
```

## Implement the required functions

### Iteration


```@example citetrait
import CitableLibrary: toblocks
import CitableLibrary: fromblocks
```



### Serialization to CEX

A real application would serialize a citable collection to one of the defined blocks of a CEX document.  For this demo, we'll use a fake block heading, and serialize our URNs one per line.

```@example citetrait
# Format as one ISBN string per line.
function cex(reading::ReadingList)
    header = "#!fakecexblock\n"
    strings = map(ref -> ref.isbn, reading.reff)
    header * join(strings, "\n")
end
```

```@example citetrait
# Instantiate a ReadingList from CEX:
function fromcex(src::AbstractString, ReadingList)
    isbns = []
    lines = split(src, "\n")
    for i in 2:length(lines)
        push!(isbns,Isbn10Urn(lines[i]))
    end
    ReadingList(isbns)
end
```

`cex` returns a text block. This demo returns a simple list of values with a header line.

```@example citetrait
cex(readingList) |> print
```

`fromcex` reads a CEX block and instantiates a collection.

```@example citetrait
block = """#!fakecexblock
urn:isbn:022661283X
urn:isbn:3030234134
urn:isbn:022656875X
"""
fromcex(block, ReadingList)
```

### `CitableLibraryTrait` functions


```@example citetrait
import CitableLibrary: toblocks
import CitableLibrary: fromblocks

function fromblocks(src::AbstractString, ReadingList)
    fromcex(src, ReadingList)
end

function toblocks(reading::ReadingList)
    cex(reading)
end
```

```@example citetrait
cexstring = toblocks(readingList)
```

```@example citetrait
list2 = fromblocks(cexstring, ReadingList)
```

