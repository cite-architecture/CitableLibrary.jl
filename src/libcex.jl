
"""Define type as serializable."""
CexTrait(::Type{CiteLibrary}) = CexSerializable()

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


"""`CiteLibrary` requires additional information to be instantiated from CEX source.  Warn and return `nothing`.
$(SIGNATURES)
Required function for `CexTrait`.
"""
function fromcex(s::AbstractString, CiteLibrary; delimiter = "|") 
    msg = """A CiteLibrary cannot be instantiated using `fromcex`.  Please use the `CiteEXchange.citelibrary` instead.
    """
    @warn(msg)
    nothing
end
