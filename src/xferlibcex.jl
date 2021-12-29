"""Lazily construct a `CiteLibrary` from CEX source string and 
a dictionary mapping content to Julia types.  Data for text corpora and CITE collections are not required to be cataloged in corresponding CEX blocks.
$(SIGNATURES)
"""
function laxlibrary(cexsrc::AbstractString, typesdict; delimiter = "|")
    citables = []
    corpora = instantiatetexts(cexsrc, typesdict, delimiter = delimiter, strict = false)
    if ! isempty(corpora)
        push!(citables, corpora)
    end

    relsets = instantiaterelations(cexsrc, typesdict, delimiter = delimiter, strict = false)
    if ! isempty(relsets)
        push!(citables, relsets)
    end

    citecolls = instantiatecollections(cexsrc, typesdict, delimiter = delimiter, strict = false)
    #collected = []
    if ! isempty(citecolls)
        push!(citables, Iterators.flatten(citecolls) |> collect)
    end
    # Flatten the citables list:
    finalcollectables = citables |> Iterators.flatten |> collect
    aslib = finalcollectables |> library
    #@warn("Final lax lib/from", aslib, citables)
    aslib
end

"""Construct a `CiteLibrary` from CEX source string and 
a dictionary mapping content to Julia types.
$(SIGNATURES)
"""
function citelibrary(cexsrc::AbstractString, typesdict; delimiter = "|", strict = true)
    #@warn("library: ", strict, typesdict)
    if strict
        @warn("library: strict parsing not yet implemented.")
        strictly = laxlibrary(cexsrc, typesdict, delimiter = delimiter)
        #@warn("result: ", strictly)
        strictly
    else
        #@warn("Going lax")
        lazily = laxlibrary(cexsrc, typesdict, delimiter = delimiter)
        #@warn("result: ", lazily)
        lazily
    end
end