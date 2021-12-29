

```@setup library
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "assets", "critsigns.cex")
collectioncex = read(f, String)
```



# Building a library from CEX using customized CITE collections


There are two ways to map a CITE collection to a Julia type:


1. directly map a collection by its URN (possibly using URN containment)
1. map the datamodel defined for the collection in the source CEX data


```@example library

```



!!! note

    In the following example, we've predefined a CEX string `collectioncex`.  It contains the contents of the file `test/assets/critsigns.cex` in this repository.




## Define the custom types

```@example library
using CiteEXchange
using CitableLibrary

using CitableObject, CitableBase

struct TerribleTuples
    urn::Cite2Urn
    fieldproperties
    data
end

import CitableBase: CitableTrait
CitableTrait(::Type{TerribleTuples}) = CitableByCite2Urn()

import CitableLibrary: CitableLibraryTrait
CitableLibraryTrait(::Type{TerribleTuples}) = CitableLibraryCollection()

import CitableBase: CexSerializable
CexSerializable(::Type{TerribleTuples}) = CexSerializable()

function tuplematch(fields, u::Cite2Urn)
    urncontains(u, Cite2Urn(fields[1]))
end

import CitableBase: fromcex
function fromcex(s::AbstractString, TerribleTuples; delimiter = "|")
    allblocks =  blocks(s)
    propertyblocks = blocksfortype("citeproperties", allblocks)
    collectionprops = []
    for b in propertyblocks
        for ln in b.lines[2:end]
            push!(collectionprops, split(ln, delimiter))
        end
    end

    datablocks = blocksfortype("citedata", allblocks)
    collectiondata = []
    for b in datablocks
        for ln in b.lines[2:end]
            push!(collectiondata, split(ln, delimiter))
        end
    end
    collectionurns = CiteEXchange.collections(allblocks, delimiter = delimiter, strict = false)


    terrible  = []
    for u in collectionurns
        currprops = filter(p -> tuplematch(p,u), collectionprops)
        currdata = filter(p -> tuplematch(p,u), collectiondata)
        push!(terrible, TerribleTuples(u, currprops, currdata))
    end
    terrible
end

```



## Build from CEX source

Now we can build a library by mapping specific CITE collections to our new class. 

### Mapping content with a containing URN

In this example, we map a collection-level URN to our type. 

```@example library
signcollection = Cite2Urn("urn:cite2:hmt:va_signs:")
tdict1 = Dict(signcollection => TerribleTuples)
lib1 = citelibrary(collectioncex, tdict1, strict = false)
```

### Mapping content with a data model

Since the one collection in this sample is mapped to a data model, we can create a library with equivalent contents using the data model's URN as the key to the Julia type.

```@example library
annotationmodel = Cite2Urn("urn:cite2:demo:datamodels.v1:annotationmodel")
tdict2 = Dict(annotationmodel => TerribleTuples)
lib2 = citelibrary(collectioncex, tdict2)
```