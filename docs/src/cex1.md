# Serializing collections

.from `CitableBase`, the `CexTrait`, which 



```@example cex
```


```
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
        push!(isbns,Isbn10EnglishUrn(lines[i]))
    end
    ReadingList(isbns)
end
```