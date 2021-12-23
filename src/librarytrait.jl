"""Abstraction of values for a citable library collection trait."""
abstract type CitableLibraryTrait end

"""Value for the CitableLibraryTrait for citable collections."""
struct CitableLibraryCollection <: CitableLibraryTrait end

"""Value for the CitableLibraryTrait for evertything that is not a citable library collection."""
struct NotCitableLibraryCollection <: CitableLibraryTrait end

"""Define default value of CitableLibraryTrait as NotCitableLibraryCollection."""
CitableLibraryTrait(::Type) = NotCitableLibraryCollection() 


"""True if `x` has the value `CitableLibraryCollection` for the `CitableLibraryTrait`.

$(SIGNATURES)
"""
function citablecollection(x::T) where {T} 
    CitableLibraryTrait(T) != NotCitableLibraryCollection()
end

