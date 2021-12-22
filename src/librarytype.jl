"""A library with contents citable by URN."""
struct CiteLibrary
    collections
    libname::AbstractString
    liburn::U where {U <: Urn}
    license::AbstractString
    cexversion::VersionNumber

    function CiteLibrary(collectionlist, 
        libname, liburn, license, cexvers::VersionNumber)
        if ! (typeof(liburn) <: Urn)
            throw(DomainError(liburn, " is not a Urn."))
        end
        for coll in collectionlist
            if ! citablecollection(coll)
                #@info(typeof(coll),CitableLibraryTrait(typeof(coll)) )
                msg = "Type does not implement CitableLibraryTrait: $(typeof(coll))"
                DomainError(typeof(coll), msg) |> throw

            else
                #@info(typeof(coll), CitableLibraryTrait(typeof(coll)))
            end
        end
        new(collectionlist, libname, liburn, license, cexvers)
    end
end

"""Name of library.
$(SIGNATURES)
"""
function libname(lib::CiteLibrary)::AbstractString
    lib.libname
end

"""URN identifying library.
$(SIGNATURES)
"""
function liburn(lib::CiteLibrary)
    lib.liburn
end


"""License for collected material in library as a whole.
$(SIGNATURES)
"""
function license(lib::CiteLibrary)::AbstractString
    lib.license
end

"""CEX version to use in serialization.
$(SIGNATURES)
"""
function cexversion(lib::CiteLibrary)::VersionNumber
    lib.cexversion
end


"""Override `Base.show` for `CiteLibrary`.
$(SIGNATURES)
"""
function show(io::IO, lib::CiteLibrary)
    if isempty(lib.collections) 
        "Empty library"
    else
        count = length(lib.collections) == 1 ? "1 collection" : "$(length(lib.collections)) collections"
        msglines = [
            join([lib.libname, " <", lib.liburn, ">"]),
            join(["Citable library with ", count])
        ]
        print(io, join(msglines, "\n"))
    end
end

"""Construct a `CiteLibrary`.
$(SIGNATURES)
"""
function citeLibrary(collections; 
    libname::AbstractString = "Automatically assembled citable library",
    liburn = nothing,
    license::AbstractString = "Creative Commons Attribution, Non-Commercial 4.0 License <https://creativecommons.org/licenses/by-nc/4.0/>",
    cexversion::VersionNumber = v"3.0.2"
    )
    if isnothing(liburn)
        liburn = CitableLibrary.uuidUrn()
    end
    CiteLibrary(collections, libname, liburn, license, cexversion)    
end


"""Serialize contents of `lib` to a CEX string.

$(SIGNATURES)
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


"""List types of collections in library.
$(SIGNATURES)
"""
function collectiontypes(lib::CiteLibrary)
    typelist = []
    for c in lib.collections
        push!(typelist, typeof(c))
    end
    unique(typelist)
end

"""List all collections in the library.
$(SIGNATURES)
"""
function collections(lib::CiteLibrary)
    lib.collections
end

"""List all collections in the library of type `T`.
$(SIGNATURES)
"""
function collections(lib::CiteLibrary, T)
    filter(c -> c isa T, lib.collections)
end


"""Apply `urnequals` to all collections in `lib` of type `T`.
$(SIGNATURES)
Returns a possibly empty list of objects.
"""
function urnequals(urn::U, lib::CiteLibrary, T) where {U <: Urn}
    clist = collections(lib, T)
    rslts = []
    for c in clist
        oneresult = urnequals(urn, c)
        if ! isnothing(oneresult) 
            push!(rslts, oneresult)
        end
    end

    if length(rslts) > 1
        @warn("Multiple results for URN == $(urn)")
        rslts
    elseif isempty(rslts)
        nothing
    else
        rslts
    end
end


"""Apply `urncontains` to all collections in `lib` of type `T`.
$(SIGNATURES)
Returns a possibly empty list of objects.
"""
function urncontains(urn::U, lib::CiteLibrary, T) where {U <: Urn}
    clist = collections(lib, T)
    rslts = []
    for c in clist
        onecollection = urncontains(urn, c)
        if ! isnothing(onecollection) 
            push!(rslts, onecollection)
        end
    end

    rslts  |> Iterators.flatten |> collect
end
