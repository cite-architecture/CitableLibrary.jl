# The `CitableLibraryTrait`

The  `CitableLibraryTrait` applies to collections of content that can be retrieved by reference to URNs. Implementations of the `CitableLibraryTrait` can be searched by URN value, can be serialized to CEX format, and can be iterated using Julia's generic `Iteration` interface.

To comply with Julia's `Iteration` interface, types supporting the `CitableLibraryTrait` should implement at least `iterate(iter)` and `iterate(iter, state)`:  see the [Julia documentation](https://docs.julialang.org/en/v1/manual/interfaces/).

To make the collection searchable and serializable, the type should support the `urnequals`, `urncontains` and `cex` functions.  The following example illustrates how you can do that.

## How to implement the CitableLibraryTrait

In this example, we'll create a collection type for a reading list of books, and make it comply with the `CitableLibraryTrait`.  To do that, we'll need to use both the `CitableLibrary` and `CitableBase` packages.

```@example citelib
using CitableLibrary
using CitableBase
```

The `CitableLibraryTrait` requires us to be able to find contain by URN values. We could use existing implementations of the `URN` abstraction (such as the `Cite2Urn` and the `CtsUrn`), but for this example we'll invent our own URN type. Our `ReadingList` type will be nothing more than a list of those URN values.

```@example citelib
struct IsbnUrn <: Urn
    isbn::AbstractString
end

struct ReadingList
    reff::Vector{IsbnUrn}
end
```

Now we can instantiate a `ReadingList`.

```@example citelib
isbns = [IsbnUrn("urn:isbn:022661283X"),IsbnUrn("urn:isbn:3030234134"),IsbnUrn("urn:isbn:022656875X")]
readingList = ReadingList(isbns)
```

The next step is to define that our new type fulfills the `CitableLibraryTrait`.


```@example citelib
import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{ReadingList}) = CitableLibraryCollection()
```

We can verify that we've done that correctly.

```@example citelib
CitableLibraryTrait(typeof(readingList))
```

This can also be verified using the `citable` function:


```@example citelib
citable(readingList)
```



Now we need to define specific methods for the three functions `urnequals`, `urncontains` and `cex`.  First we *import* them (rather than *using* them).

```@example citelib
import CitableLibrary: urnequals
import CitableLibrary: urncontains
import CitableLibrary: cex
```


All our implementation needs to do is specify the correct type for our collection.  (For ISBN URNs, we've chosen to implement `urncontains` and `urnequals` similarly, but you can define URN containment in whatever way is appropriate for the URN type you are using.)

```@example citelib
# Returns one IsbnUrn or nothing
function urnequals(u::IsbnUrn, faves::ReadingList)
    filtered = filter(ref -> ref == u, faves.reff)
    isempty(filtered) ? nothing : filtered[1]
end

# Returns a (possibly empty) list of IsbnUrns
function urncontains(u::IsbnUrn, faves::ReadingList)
    filter(ref -> ref == u, faves.reff)
end

# Format as one ISBN string per line.
# In a real implementation, you would certainly
# implement `write` for your URN type instead of directly 
# manipulating fields.
function cex(reading::ReadingList)
    header = "ISBN\n"
    strings = map(ref -> ref.isbn, reading.reff)
    header * join(strings, "\n")
end
```

Finally, we should also implement the `Base.iterate` method.


```@example citelib
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

Let's test our new type.

`urnequals` returns a single object or `nothing`.

```@example citelib
# URN we'll search for:
distant = isbns[1]
urnequals(distant, readingList)
```

`urncontains` returns a (possibly empty) Vector.

```@example citelib
urncontains(distant, readingList)
```

`cex` returns a text block. This demo returns only an unhelpful list of values with a header line.

```@example citelib
cex(readingList) |> print
```

Iteration:

```@example citelib
for isbn in readingList
   println(isbn)
end
```