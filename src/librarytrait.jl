
"""Abstraction of values for a citable library collection trait."""
abstract type CitableLibraryTrait end

"""Value for the CitableLibraryTrait for citable collections."""
struct CitableLibraryCollection <: CitableLibraryTrait end

"""Value for the CitableLibraryTrait for evertything that is not a citable library collection."""
struct NotCitableLibraryCollection <: CitableLibraryTrait end

"""Define default value of CitableLibraryTrait as NotCitableLibraryCollection."""
CitableLibraryTrait(::Type) = NotCitableLibraryCollection() 


"""Delegate `fromblocks` to specific functions based on 
type's CitableLibraryTrait value.

$(SIGNATURES)
"""
function fromblocks(cexblocks, T)
    fromblocks(CitableLibraryTrait(T), cexblocks)
end

"""Delegate `toblocks` to specific functions based on 
type's CitableLibraryTrait value.

$(SIGNATURES)
"""
function toblocks(x::T) where {T} 
    toblocks(CitableLibraryTrait(T), x)
end

"""True if `x` has the value `CitableLibraryCollection` for the `CitableLibraryTrait`.

$(SIGNATURES)
"""
function citable(x::T) where {T} 
    citable(CitableLibraryTrait(T), x)
end

"""True if `x` has the value `CitableLibraryCollection` for the `CitableLibraryTrait`.

$(SIGNATURES)
"""
function citable(::CitableLibraryCollection, x)
    true
end

function citable(::NotCitableLibraryCollection, x)
    false
end


#=
# Catch attempts to use these functions on NotCitableLibraryCollection:
"""It is an error to invoke the `urnequals` function with collections that are not citable.

$(SIGNATURES)
"""
function urnequals(::NotCitableLibraryCollection, urn::U, x) where {T, U <: Urn} 
    throw(DomainError(x, string("Type ", typeof(x), " does not implement urnequals.")))
end

"""It is an error to invoke the `urncontains` function with collections that are not citable.

$(SIGNATURES)
"""
function urncontains(::NotCitableLibraryCollection, urn::U, x) where {T, U <: Urn} 
    throw(DomainError(x, string("Type ", typeof(x), " does not implement urncontains.")))
end


"""It is an error to invoke the `cex` function with collections that are not citable.

$(SIGNATURES)
"""
function cex(::NotCitableLibraryCollection, urn::U, x) where {T, U <: Urn} 
    throw(DomainError(x, string("Type ", typeof(x), " does not implement cex.")))
end
=#