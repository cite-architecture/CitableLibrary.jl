
"""Singleton tyupe for value of `CexTrait` on `CiteLibrary`."""
struct LibraryCex <: CexTrait end

"""Assign the concrete value `LibraryCex()` for `CexTrait` on type `CiteLibrary`.
$(SIGNATURES)
"""
function cextrait(::Type{CiteLibrary})
    LibraryCex()
end

"""Serialize contents of `lib` to a CEX string.
$(SIGNATURES)
Required function for `CexTrait`.
"""
function cex(lib::CiteLibrary; delimiter = "|") 
    lines = ["#!cexversion", string(lib.cexversion),"", 
    "#!citelibrary", 
    join(["name",lib.libname],  delimiter),
    join(["urn", lib.liburn], delimiter),
    join(["license", lib.license], delimiter),
    ""
    ]
    for c in lib.collections
        push!(lines, cex(c, delimiter = delimiter))
    end
    join(lines, "\n")
end



"""Construct a `CiteLibrary` from CEX source string and 
a dictionary mapping content to Julia types.
$(SIGNATURES)
"""
function fromcex(traitvalue::LibraryCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration, strict = true)
      
    if strict
        @warn("Strict parsing not yet implemented.")
        strictly = strictlibrary(cexsrc, configuration, delimiter = delimiter)
        strictly
    else
        lazily = laxlibrary(cexsrc, configuration, delimiter = delimiter)
        lazily
    end
   
end



function strictlibrary(cexsrc::AbstractString, typesdict; delimiter = "|")
    @warn("Substituting lax parsing.")
    laxlibrary(cexsrc, typesdict, delimiter = delimiter)
end

"""Lazily construct a `CiteLibrary` from CEX source string and 
a dictionary mapping content to Julia types.  Data for text corpora and CITE collections are not required to be cataloged in corresponding CEX blocks.
$(SIGNATURES)
"""
function laxlibrary(cexsrc::AbstractString, typesdict; delimiter = "|")
    citables = []
    sections = []
    #=
    corpora = instantiatetexts(cexsrc, typesdict, delimiter = delimiter, strict = false)
    if ! isempty(corpora)
        push!(citables, corpora)
    end

    relsets = instantiaterelations(cexsrc, typesdict, delimiter = delimiter, strict = false)
    if ! isempty(relsets)
        push!(citables, relsets)
    end
    =#
    append!(citables, instantiatecollections(cexsrc, typesdict, delimiter = delimiter))

    #collected = []
    if ! isempty(citables)
        #flattened = Iterators.flatten(citecolls) |> collect
        #push!(citables, flattened)
        push!(sections, fill(CollectionSections, length(citables)))
    end
    library(citables, sections)

    # Flatten the citables list:
    #finalcollectables = citables |> Iterators.flatten |> collect
    #finalsections = sections |> Iterators.flatten |> collect
    
    #aslib = library(citables, sections)
    #@warn("Final lax lib/from", aslib, citables)
    #aslib
end
