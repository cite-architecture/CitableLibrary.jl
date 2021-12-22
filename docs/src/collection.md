# Citable collections

A `CiteLibrary` has a list of 0 or more citable collections. Citable collections can be queried using URN logic because their contents in turn must be citable objects.  

We'll define a custom type of citable collection that we'll use throughout this documentation.  The type will manage a list of books, identified by their ISBN numbers.  We'll invent our own URN type for ISBN numbers, and define a `ReadingList` type as just a list of these ISBN values.  

The [ISBN-10 format](https://en.wikipedia.org/wiki/International_Standard_Book_Number) is incredibly complicated, with each of its four components being variable in length.  We'll restrict ourselves to ISBNs for books in the English language indicated by an initial of `0` or `1`.  


!!! warn

    In a real program, we would enforce this limitation with appropriate validation of the constructor, but to keep this example brief and focused on the requirements of citable collections, we'll pass through strings to the constructor unchecked.


```@example citelib
using CitableLibrary
using CitableBase

struct Isbn10EnglishUrn <: Urn
    isbn::AbstractString
end

struct ReadingList
    reff::Vector{Isbn10EnglishUrn}
end
isbns = [Isbn10EnglishUrn("urn:isbn:022661283X"),Isbn10EnglishUrn("urn:isbn:3030234134"),Isbn10EnglishUrn("urn:isbn:022656875X")]
rl = ReadingList(isbns)
```

Note that `Isbn10EnglishUrn` is a subtype of `Urn`: this makes objects of that type recognizable as values we can compare using URN logic.

```@example citelib
distanthorizons = isbns[1]
urncomparable(distanthorizons)
```

On the next page, we'll look at how to implement URN comparison for our `Isbn10EnglishUrn` type, and for our collection type, `ReadingList`.