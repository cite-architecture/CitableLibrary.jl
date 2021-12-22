# Citable collections

A `CiteLibrary` has a list of zero or more citable collections. Citable collections can be queried using URN logic because their contents must in turn be citable objects.  

For this example, we'll define a custom type of citable collection that we'll use throughout this documentation.  The type will manage a list of books, identified by their ISBN numbers.  We'll invent our own URN type for ISBN numbers, and define a `ReadingList` type as just a list of these ISBN values.  For our URN type, we'll follow the URN syntax requirements for a URN type named `isbn`.

The [ISBN-10 format](https://en.wikipedia.org/wiki/International_Standard_Book_Number) is incredibly complicated, with each of its four components being variable in length.    We'll restrict ourselves to ISBNs for books published in English-, French- or German-speaking countries, indicated by an initial digit of `0` or `1` (English), `2` (French) or `3` (German).  


!!! warning

    In a real program, we would enforce this limitation with appropriate validation of the constructor, but to keep this example brief and focused on the requirements of citable collections, we'll pass through strings to the constructor unchecked.


As a convenience, we'll implement the equality function `==` for our new type.  We'll define two `ReadingList`s as equivalent if their `reff` fields have equivalent content.


```@example citelib
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

import Base.==
function ==(rl1::ReadingList, rl2::ReadingList)
    r1.reff == r2.reff
end

rl = ReadingList([distanthorizons,enumerations, enumerations, wrong, jane])
length(rl.reff)
```



## Recognizing behaviors


CitableLibraryTrait



Note that `Isbn10Urn` is a subtype of `Urn`: this makes objects of that type recognizable as values we can compare using URN logic.

```@example citelib
urncomparable(distanthorizons)
```

On the next page, we'll look at how to implement URN comparison for our `Isbn10Urn` type, and for our collection type, `ReadingList`.