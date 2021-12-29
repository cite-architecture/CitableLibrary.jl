
```@setup library
root = pwd() |> dirname |> dirname
textfile = joinpath(root, "test", "assets", "gettsyburgdata.cex")
textcex = read(textfile, String)
```



# Building a library from CEX using customized text corpora

!!! note

    In the following example, we've predefined a CEX string `textcex`.  It contains the contents of the file `test/assets/gettysburgdata.cex` in this repository.


Required Julia packages:

```@example library
using CiteEXchange
using CitableLibrary
```

## Define the custom types

```@example library
using CitableText
struct MyText
    u::CtsUrn
    t::AbstractString
end
import CitableBase: CitableTrait
CitableTrait(::Type{MyText}) = CitableByCtsUrn()

struct MyCorpus
    v::Vector{MyText}
end
import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{MyCorpus}) = CitableLibraryCollection()


import CitableBase: CexSerializable
CexSerializable(::Type{MyCorpus}) = CexSerializable()


import CitableBase: fromcex
function fromcex(s::AbstractString, MyCorpus; delimiter = "|")
    srcblocks = blocksfortype("ctsdata", blocks(s))
    psgs = []
    for b in srcblocks
        for ln in  b.lines
            parts = split(ln, delimiter)
            push!(psgs, MyText(CtsUrn(parts[1]), parts[2]))
        end
    end
    MyCorpus(psgs)
end
```

## Build from CEX source

```@example library
banc = CtsUrn("urn:cts:citedemo:gburg.bancroft:")
tdict = Dict(banc => MyCorpus, "ctsdata" => MyCorpus)
lib = citelibrary(textcex, tdict)
```


