"""Lazily read URN values from `citedatablocks`.  Assume that the first line is a header line to skip, and all other lines have a Cite2Urn in the first delimited column.

$(SIGNATURES)
"""
function lazycite2urns(citedatablocks::Vector{CiteEXchange.Block}; delimiter = "|")::Vector{Cite2Urn}
    urnlist = []
    for dblock in citedatablocks
        for ln in dblock.lines[2:end]
            # Assume URN is first field when not strict
            parts = split(ln, delimiter)
            u = Cite2Urn(parts[1])
            push!(urnlist, dropobject(u))
        end
    end
    urnlist |> unique
end

"""Lazily read URN values from `citedatablocks`.  Assume that the first line is a header line to skip, and all other lines have a CtsUrn in the first delimited column.

$(SIGNATURES)
"""
function lazyctsurns(citedatablocks::Vector{CiteEXchange.Block}; delimiter = "|")::Vector{CtsUrn}
    urnlist = []
    for dblock in citedatablocks
        for ln in dblock.lines[2:end]
            # Assume URN is first field when not strict
            parts = split(ln, delimiter)
            u = CtsUrn(parts[1])
            push!(urnlist, droppassage(u))
        end
    end
    urnlist |> unique
end
