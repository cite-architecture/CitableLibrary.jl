"""A library with contents citable by URN."""
struct CiteLibrary <: Citable
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
                msg = "Type does not implement CitableCollectionTrait: $(typeof(coll))"
                DomainError(typeof(coll), msg) |> throw

            else
                #@info(typeof(coll), CitableLibraryTrait(typeof(coll)))
            end
        end
        new(collectionlist, libname, liburn, license, cexvers)
    end
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


struct CitableCollectionsLibrary <: CitableTrait end
import CitableBase: citabletrait
function citabletrait(::Type{CiteLibrary})
    CitableCollectionsLibrary()
end

"""Construct a `CiteLibrary`.
$(SIGNATURES)
## Optional parameters

- `liburn` Unique identifier for this library. Must be a subtype of `Urn`.
- `libname` Name of library (value returned by `label`)
- `license` License. Default is cc-nc-by.
- `cexversion` Version of the CEX standard used in serializing library. Default is the current version.

"""
function library(collections; 
    libname::AbstractString = "Automatically assembled citable library",
    liburn = nothing,
    license::AbstractString = "Creative Commons Attribution, Non-Commercial 4.0 License <https://creativecommons.org/licenses/by-nc/4.0/>",
    cexversion::VersionNumber = CURRENT_CEX_VERSION
    )
    if isnothing(liburn)
        liburn = CitableLibrary.uuidUrn()
    end
    @warn("Build lib named", libname)
    CiteLibrary(collections, libname, liburn, license, cexversion)    
end


"""Name of library.
$(SIGNATURES)
Required function for `CitableTrait`.
"""
function label(lib::CiteLibrary)::AbstractString
    lib.libname
end

"""URN identifying library.
Required function for `CitableTrait`.
$(SIGNATURES)
"""
function urn(lib::CiteLibrary)
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



#=
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
=#