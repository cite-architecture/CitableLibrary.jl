function configureddata(cexsrc::AbstractString, u::Cite2Urn; delimiter = "|")
    #pool = urnpool(cexsrc, delimiter = delimiter)
    
    relsets = crsurns(cexsrc, delimiter = delimiter)
    if u in relsets
        relblocks = blocks(cexsrc, "citerelationset")
    end

end


function relsetforurn(cexsrc::AbstractString, u::Cite2Urn; delimiter = "|")
    relblocks = blocks(cexsrc, "citerelationset")
    for rblock in relblocks
    end
end

# read citedata in cexsrc, and group into citedatablocks
# paired with a URN
function reblock(cexsrc; delimiter = "|")
    datablocks = blocks(cexsrc, "citedata")

    datapairs = []
    @warn("Cycle $(length(datablocks)) blocks")
    for db in datablocks
        hdr = db.lines[1]
        cols = split(hdr, "|")
        orderdict = Dict()
        for i in 1:length(cols)
            orderdict[lowercase(cols[i])] = i
        end
        urncol = orderdict["urn"]
        for ln in db.lines[2:end]
            cols = split(ln, delimiter)
            u = Cite2Urn(cols[urncol]) |> dropobject
            push!(datapairs,(u, ln))
        end
    end
    datapairs
end

#=
dataforurn()

- reblocked datablocks, urn, dmmap, 

=#
function urnpool(cexsrc; delimiter = "|")
    vcat([
        crsurns(cexsrc, delimiter = delimiter), 
        collcaturns(cexsrc, delimiter = delimiter), 
        txturns(cexsrc, delimiter = delimiter)] ) |> Iterators.flatten |> collect
end

# TBD
function txturns(cexsrc::AbstractString; delimiter = "|")
    []
end
function crsurns(cexsrc::AbstractString; delimiter = "|")
    urnlist = Cite2Urn[]
    for b in blocks(cexsrc, "citerelationset")
        cols = split(b.lines[1], delimiter)
        push!(urnlist, Cite2Urn(cols[2]))
    end
    urnlist
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


# Get URN identifying a data model block
function dmurn(b::Block; delimiter = "|")
    cols = split(b.lines[2], delimiter)
    Cite2Urn(cols[1])
end

function relblockurn(b::Block; delimiter = "|")