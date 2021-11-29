"""A library with contents citable by URN."""
struct CiteLibrary
    collections
    libname::AbstractString
    liburn::Cite2Urn
    license::AbstractString
    cexversion::VersionNumber

    function CiteLibrary(collectionlist, 
        libname, liburn, license, cexvers::VersionNumber)
        @info("Initialized libary")
        for coll in collectionlist
            #if CitableLibraryTrait(typeof(coll)) != CitableLibraryCollection()
            if ! citable(coll)
                @info(typeof(coll),CitableLibraryTrait(typeof(coll)) )
                msg = "Type does not implement CitableLibraryTrait: $(typeof(coll))"
                DomainError(typeof(coll), msg) |> throw

            else
                @info(typeof(coll), CitableLibraryTrait(typeof(coll)))
            end
        end
        new(collectionlist, libname, liburn, license, cexvers)
    end
end


"""Construct a `CiteLibrary`.
$(SIGNATURES)
"""
function citeLibrary(collections; 
    libname::AbstractString = "Automatically assembled citable library",
    baseurn::Cite2Urn = Cite2Urn("urn:cite2:citearchitecture:uuid.v1:"),
    license::AbstractString = "Creative Commons Attribution, Non-Commercial 4.0 License <https://creativecommons.org/licenses/by-nc/4.0/>",
    cexversion::VersionNumber = v"3.0.2")

    rng = MersenneTwister(1234)
    uuid = uuid1(rng) |> string
    libid = replace(uuid, "-" => "_")

    CiteLibrary(collections, libname, addobject(baseurn, libid), license, cexversion)    
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