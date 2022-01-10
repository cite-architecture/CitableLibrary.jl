"""For a block of type `citerelationset`, return `Cite2Urn`
identifying the set.
$(SIGNATURES)
"""
function relationseturn(relationblock::CiteEXchange.Block; divider = "|")
    if relationblock.label != "citerelationset"
        throw(DomainError(relationblock,"CiteEXchange.Block is not of type `citerelationset`"))
    else
        parts = split(relationblock.lines[1],divider)
        if parts[1] != "urn"
            throw(DomainError(relationblock.lines[1], "First data line must define URN for relation set. "))
        end
        Cite2Urn(parts[2])
    end
end


"""Find data for all relationsets matching URN value `u`.
$(SIGNATURES)
Shouldl return a *Vector*.
"""
function relationsdataforurn(citeblocks::Vector{CiteEXchange.Block}, u::Cite2Urn; delimiter = "|")
    allblocks = blocksfortype("citerelationset", citeblocks)
    blocksdata = []
    for blk in allblocks
        data = []
        if urncontains(u, relationseturn(blk))
            for ln in blk.lines
                push!(data, ln)
            end 
        end
        push!(blocksdata, data)
    end
    filter(v -> ! isempty(v), blocksdata)
end

"""Instantiate relation sets from CEX source.
$(SIGNATURES)
Keys in `typesdict` may be either of:

1. a `Cite2Urn` identifying the relation set (possibly by URN containment)
2. a `Cite2Urn` identifying a datamodel defined in `cexsrc`

These keys should point to a Julia type implementing the `CitableLibraryTrait` (including the `fromcex` function).
"""
function instantiaterelations(cexsrc::AbstractString, typesdict; delimiter = "|", strict = false)
    if strict
        @warn("instantiaterelations: strict parsing not yet implemented")
    end
    allblocks = blocks(cexsrc)
    relseturns = relationsets(allblocks, delimiter = delimiter)

    # get urns for sets directly mapped to a Julia type
    directlymapped = Dict()
    for seturn in relseturns
        for k in keys(typesdict)
            if (k isa Cite2Urn) && urncontains(k, seturn)
                directlymapped[seturn] = typesdict[k]
            end
        end
    end

    # get urns for sets following a data model
    modelled = Dict()
    dmdict = modelleddict(allblocks, delimiter = delimiter)
    for k in keys(dmdict)
        coll = k
        collmodel = dmdict[k]
        for tkey in keys(typesdict)
            if tkey == collmodel
                modeltype = typesdict[tkey]
                modelledcollections = filter(rel -> urncontains(coll, rel), relseturns)
                #@warn("For", coll, collmodel, modeltype, modelledcollections)
                for c in modelledcollections
                    modelled[c] = modeltype
                end 
            end
        end
    end
      

    relsets = []
    for directurn in keys(directlymapped)
        directdata = relationsdataforurn(allblocks, directurn, delimiter = delimiter)
        directcex = map(rset -> "#!citerelationset\n" * join(rset, "\n") * "\n", directdata)
        push!(relsets, fromcex(join(directcex, "\n"), directlymapped[directurn]))
    end

    for modelledurn in setdiff(keys(modelled), keys(directlymapped))
        modelleddata = relationsdataforurn(allblocks, modelledurn, delimiter = delimiter)
        modelledcex = map(rset -> "#!citerelationset\n" * join(rset, "\n") * "\n", modelleddata)
        push!(relsets, fromcex(join(modelledcex, "\n"), modelled[modelledurn]))
    end
    relsets
end


"""Gather a (possibly empty) list of `Cite2Urn`s
identifying all relation sets in a list of `CiteEXchange.Block`s.
$(SIGNATURES)
If `strict` is true, all relations sets appearing in `relationsets` blocks must appear in a `datamodel` entry.
"""
function relationsets(blocklist::Vector{CiteEXchange.Block}; delimiter = "|")#::Vector{Cite2Urn}
    relationurns = []
    relsetblocks = blocksfortype("citerelationset", blocklist)
    for relationblock in relsetblocks
        parts = split(relationblock.lines[1], delimiter)
        push!(relationurns, Cite2Urn(parts[2]))
    end
    relationurns
end
