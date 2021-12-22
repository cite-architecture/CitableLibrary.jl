
```@setup iterator
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




# Iterating collections

Citable collections should be usable with any Julia functions that recognize the `Iterators` conventions.  We need to implement the `Base.iterate` method for our collection with two functions:  one with a single parameter for our collection, and one with a second parameter you can use to maintain state through an iteration.  The return value should be one element of the collection, or `nothing` when you reach the end.

Since our reading list is just a Vector, we can keep an index to the Vector in our state parameter, and trivially walk through the Vector by index value.


```@example iterator
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

```@example iterator
for item in rl
    println(item)
end
```
