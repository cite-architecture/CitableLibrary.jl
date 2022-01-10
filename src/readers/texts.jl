
"""Instantiate text corpora from CEX source.
$(SIGNATURES)
`typesdict` can map either or both of:

1. a string for the block label `ctsdata`
2. a CtsUrn 

These keys should point to a Julia type implementing the `CitableLibraryTrait` (including the `fromcex` function).
"""
function instantiatetexts(cexsrc::AbstractString, typesdict; delimiter = "|")
   @warn("Instantiating texts with config ", typesdict)
    #=
    allblocks = blocks(cexsrc)
    alltexturns = texts(allblocks, delimiter = delimiter, strict = strict)
    specialtexts = filter(k -> k isa CtsUrn, keys(typesdict)) |> collect
    regulartexts = []
    for texturn in alltexturns
        for special in specialtexts
            if ! urncontains(special, texturn)
                push!(regulartexts, texturn)
            end
        end
    end
    
    corpora = []
    # Extra data by URN, and apply approrpiate type:
    # first, special list:
    for special in specialtexts
        specialdata = dataforctsurn(allblocks, special, delimiter = delimiter)
        specialcex = "#!ctsdata\n" * join(specialdata, "\n") * "\n"
        push!(corpora, fromcex(specialcex, typesdict[special]))
    end
    # Now get corpora that are not special.
    #if "ctsdata" in keys(typesdict)
    for regularurn in regulartexts
        regulardata = dataforctsurn(allblocks, regularurn, delimiter = delimiter)
        regularcex = "#!ctsdata\n" * join(regulardata, "\n") * "\n"
        push!(corpora, fromcex(regularcex, typesdict["ctsdata"]))
    end
    #end
    corpora
    =#
end