
# Get URN identifying a data model block
function dmurn(b::Block; delimiter = "|")
    cols = split(b.lines[2], delimiter)
    Cite2Urn(cols[1])
end

function collcaturns(cexsrc::AbstractString; delimiter = "|")
    urnlist = Cite2Urn[]
    for catentry in data(cexsrc, "citecollections")
        cols = split(catentry, delimiter)
        push!(urnlist, Cite2Urn(cols[1]))
    end
    urnlist
    #split(data(blks, "citecollections")[1] , "\n")

end

function dmmap(cexsrc::AbstractString; delimiter = "|")
    pairings = Tuple{Cite2Urn, Cite2Urn}[]
    for ln in data(cexsrc, "datamodels")
        cols = split(ln, delimiter)
        push!(pairings,
        (Cite2Urn(cols[2]),Cite2Urn(cols[1]))
        )
    end
    pairings
end