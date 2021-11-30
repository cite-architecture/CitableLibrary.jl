# The `CitableLibraryTrait`

The  `CitableLibraryTrait` applies to collections of content that can be retrieved by reference to URNs. Implementations of the `CitableLibraryTrait` can be searched by URN value, can be serialized to CEX format, and can be iterated using Julia's generic `Iteration` interface.

To comply with Julia's `Iteration` interface, types supporting the `CitableLibraryTrait` should implement at least `iterate(iter)` and `iterate(iter, state)`:  see the [Julia documentation](https://docs.julialang.org/en/v1/manual/interfaces/).

To make the collection searchable and serializable, the type should support the `urnequals`, `urncontains` and `cex` functions.  The following example illustrates how you can do that.

## How to implement the CitableLibraryTrait

In this example, we'll create a collection type for a reading list of books, and make it comply with the `CitableLibraryTrait`.  To do that, we'll need to use both the `CitableLibrary` and `CitableBase` packages.

```@example citetrait
using CitableLibrary
using CitableBase
```

The `CitableLibraryTrait` requires us to be able to find contain by URN values. We could use existing implementations of the `URN` abstraction (such as the `Cite2Urn` and the `CtsUrn`), but for this example we'll invent our own URN type. Our `ReadingList` type will be nothing more than a list of those URN values.

```@example citetrait
struct IsbnUrn <: Urn
    isbn::AbstractString
end

struct ReadingList
    reff::Vector{IsbnUrn}
end
```

Now we can instantiate a `ReadingList`.

```@example citetrait
isbns = [IsbnUrn("urn:isbn:022661283X"),IsbnUrn("urn:isbn:3030234134"),IsbnUrn("urn:isbn:022656875X")]
readingList = ReadingList(isbns)
```


To print and display our custom type, it can be convenient to override `Base.show`.

```@example citetrait
import Base: show
function show(io::IO, u::IsbnUrn)
    print(io, u.isbn)
end
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

### Implementing the four required functions

Now we need to define specific methods for the four functions `urnequals`, `urncontains`, `cex` and `fromcex`.  First we *import* them (rather than *using* them). Note that we need to import `cex` and `fromcex` from `CitableBase`.

```@example citetrait
import CitableLibrary: urnequals
import CitableLibrary: urncontains
import CitableBase: cex
import CitableBase: fromcex
```


### Selection by URN logic

All our implementation needs to do is specify the correct types for our urn and our collection.  (For ISBN URNs, we've chosen to implement `urncontains` and `urnequals` similarly, but you can define URN containment in whatever way is appropriate for the URN type you are using.)

```@example citetrait
# Returns one IsbnUrn or nothing
function urnequals(u::IsbnUrn, faves::ReadingList)
    filtered = filter(ref -> ref == u, faves.reff)
    isempty(filtered) ? nothing : filtered[1]
end

# Returns a (possibly empty) list of IsbnUrns
function urncontains(u::IsbnUrn, faves::ReadingList)
    filter(ref -> ref == u, faves.reff)
end
```


Let's test our new functions.  `urnequals` returns a single object or `nothing`.

```@example citetrait
# URN we'll search for:
distant = isbns[1]
urnequals(distant, readingList)
```

`urncontains` returns a (possibly empty) Vector.

```@example citetrait
urncontains(distant, readingList)
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
        push!(isbns,IsbnUrn(lines[i]))
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

### Iteration

Finally, we should also implement the `Base.iterate` method.


```@example citetrait
import Base: iterate

function iterate(rlist::ReadingList)
    (rlist.reff[1], 2)
end

function iterate(rlist::ReadingList, state)
    if state > length(rlist.reff)
        nothing
    else
        (rlist.reff[state], state + 1)
    end
end
```



Iteration:

```@example citetrait
for isbn in readingList
   println(isbn)
end
```