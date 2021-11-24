#= A retrievable collection implements:

- the `CitableLibraryTrait`, and consequently  defines a `lookup` function, with a single parameter that is `<: Urn`.
-   implements `iterate`  [[iterables]]
-   implement `cex` [[serialization]]
=#

"""Abstraction of values for a citable library collection trait."""
abstract type CitableLibraryTrait end

"""Value for the CitableLibraryTrait for citable collections."""
struct CitableLibraryCollection <: CitableLibraryTrait end

"""Value for the CitableLibraryTrait for evertything that is not a citable library collection."""
struct NotCitableLibraryCollection <: CitableLibraryTrait end

"""Define default value of CitableLibraryTrait as NotCitableLibraryCollection."""
CitableLibraryTrait(::Type) = NotCitableLibraryCollection() 

"""Delegate to specific functions based on 
type's CitableLibraryTrait value.

$(SIGNATURES)
"""
function lookupurn(urn::U, x::T) where {T, U <: Urn} 
    lookupurn(CitableLibraryTrait(T), urn, x)
end


# Catch attempts to use these functions on NotCitableLibraryCollection:
"""It is an error to invoke the `lookupurn` function with collections that are not citable.

$(SIGNATURES)
"""
function lookupurn(::NotCitableLibraryCollection, urn::U, x) where {T, U <: Urn} 
    throw(DomainError(x, string("Type ", typeof(x), " is not a citable collection.")))
end


# function lookup() ...?
# function iterate(x::T) {where T....}
# function iterate(x::T, state) {where T....}
# function cex() ...?
