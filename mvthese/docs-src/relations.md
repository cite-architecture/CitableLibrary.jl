
```@setup library
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "assets", "relationblocks.cex")
relationcex = read(f, String)
```

# Building a library from CEX using customized relation sets

Two options:

1. map a datamodel
2. map a specific collection


```@example library
using CiteEXchange
using CitableLibrary
```


!!! note

    In the following example, we've predefined a CEX string `relationscex`.  It contains the contents of the file `test/assets/relationsblocks.cex` in this repository.




## Create a custom type for relation sets

```@example library
using CitableObject
using CitableText
struct MyDSE
    psg::CtsUrn
    img::Cite2Urn
    surf::Cite2Urn
end
import CitableBase: CitableTrait
CitableTrait(::Type{MyDSE}) = CitableByCite2Urn()

struct MyDSESet
    v::Vector{MyDSE}
end
import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{MyDSESet}) = CitableLibraryCollection()

import CitableBase: CexSerializable
CexSerializable(::Type{MyDSESet}) = CexSerializable()

import CitableBase: fromcex
function fromcex(s::AbstractString, MyDSESet; delimiter = "|")
    srcblocks = blocksfortype("citerelationset", blocks(s))
    records = []
    for b in srcblocks
        #@warn("blocklines",b.lines)   
        for ln in  b.lines[4:end]
            #@warn("fromcex for MyDSESet: line", ln)
            parts = split(ln, delimiter)
            push!(records, MyDSE(CtsUrn(parts[1]), Cite2Urn(parts[2]), Cite2Urn(parts[3])))
        end
    end
    MyDSESet(records)
end
```

## Build from CEX source


Now we can build a library by mapping specific DSE relation sets to our new class. Each of the following three examples instantiates

## Mapping content with a containing URN

In this example, we map a collection-level URN to our class.  This will get both collections in our CEX, since they are both members of that collection.



```@example library
hmtdse = Cite2Urn("urn:cite2:hmt:dse.v1:")
tdict1 = Dict(hmtdse => MyDSESet)
lib1 = citelibrary(relationcex, tdict1)
```

## Mapping content with a data model

This time, we map a data model for DSE relation sets to our new class. This mapping will be applied to all relation sets that the source CEX defines as implementing the mapped models.

```@example library
modelurn = Cite2Urn("urn:cite2:cite:datamodels.v1:dsemodel")
tdict2 = Dict(modelurn => MyDSESet)
lib2 = citelibrary(relationcex, tdict2)
```


## Mapping content with a mixed dictionary


```@example library
vburn = Cite2Urn("urn:cite2:hmt:dse.v1:msBil8")
tdict3 = Dict(vburn => MyDSESet, modelurn => MyDSESet)
lib3 = citelibrary(relationcex, tdict3)
```

## Including only some relations



```@example library
tdict4 = Dict(vburn => MyDSESet)
lib4 = citelibrary(relationcex, tdict4)
```