
"""Construct dictionary of data models to a list of URNs of implementations as collections or relationsets.
$(SIGNATURES)
Note that URNs of implementations may use URN semantics to map a class of collections of relation sets (e.g. mapping a CITE collection at an abstract collection rather than version level).
"""
function modeldict(blocklist::Vector{Block}; delimiter = "|")
    mappings = Dict()
    dms = blocksfortype("datamodels", blocklist)
    for dm in dms
        # skip header:
        for mapping in dm.lines[2:end]
            cols = split(mapping, delimiter)
            dmurn = Cite2Urn(cols[2])
            target = Cite2Urn(cols[1])
            #mappings[target] = dmurn
            if haskey(mappings, dmurn)
                prev = mappings[dmurn]
                curr = push!(prev, target)
            else
                mappings[dmurn] = [target]
            end
        end
    end
    mappings
end

"""Map implementations of models to their model.
$(SIGNATURES)
"""
function modelleddict(blocklist::Vector{Block}; delimiter = "|")
    mappings = Dict()
    dms = blocksfortype("datamodels", blocklist)
    for dm in dms
        # skip header:
        for mapping in dm.lines[2:end]
            cols = split(mapping, delimiter)
            dmurn = Cite2Urn(cols[2])
            target = Cite2Urn(cols[1])
            mappings[target] = dmurn
        end
    end
    mappings
end